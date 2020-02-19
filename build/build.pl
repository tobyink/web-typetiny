#!/usr/bin/env perl

use v5.16;
use strict;
use warnings;
use FindBin qw($Bin);
use TOBYINK::Pod::HTML;
use HTML::Entities qw(encode_entities);
use Lingua::EN::Titlecase;
use Path::Tiny qw(path);
use Type::Tiny;
use XML::LibXML::PrettyPrint;
use HTML::HTML5::Writer;
use HTML::HTML5::Parser;
use HTML::HTML5::Sanity qw(fix_document);

my $srcdir  = path('/home/tai/src/p5/p5-type-tiny/lib/');
my $destdir = path($Bin)->parent;
my $upload  = 'server:vhosts/typetiny.toby.ink';

my $version = Type::Tiny->VERSION;
if ($version =~ /^(.+)\.(...)(...)/ and $2 % 2) {
	$version = "$1\.$2\_$3";
}

my $stable_version = '1.010000';

# chdir $srcdir; find -type f | grep Manual
my @files = map substr($_, 2), qw(
	./Type/Tiny/Manual.pod
	./Type/Tiny/Manual/Installation.pod
	./Type/Tiny/Manual/UsingWithMoo.pod
	./Type/Tiny/Manual/UsingWithMoo2.pod
	./Type/Tiny/Manual/UsingWithMoo3.pod
	./Type/Tiny/Manual/Libraries.pod
	./Type/Tiny/Manual/UsingWithMoose.pod
	./Type/Tiny/Manual/UsingWithMouse.pod
	./Type/Tiny/Manual/UsingWithClassTiny.pod
	./Type/Tiny/Manual/UsingWithOther.pod
	./Type/Tiny/Manual/UsingWithTestMore.pod
	./Type/Tiny/Manual/Params.pod
	./Type/Tiny/Manual/NonOO.pod
	./Type/Tiny/Manual/Optimization.pod
	./Type/Tiny/Manual/Coercions.pod
	./Type/Tiny/Manual/AllTypes.pod
	./Type/Tiny/Manual/Policies.pod
	./Type/Tiny/Manual/Contributing.pod
	
	./Devel/TypeTiny/Perl56Compat.pm
	./Devel/TypeTiny/Perl58Compat.pm
	./Error/TypeTiny/Assertion.pm
	./Error/TypeTiny/Compilation.pm
	./Error/TypeTiny.pm
	./Error/TypeTiny/WrongNumberOfParameters.pm
	./Eval/TypeTiny.pm
	./Reply/Plugin/TypeTiny.pm
	./Test/TypeTiny.pm
	./Type/Coercion/FromMoose.pm
	./Type/Coercion.pm
	./Type/Coercion/Union.pm
	./Type/Library.pm
	./Type/Params.pm
	./Type/Parser.pm
	./Type/Registry.pm
	./Types/Common/Numeric.pm
	./Types/Common/String.pm
	./Types/Standard/ArrayRef.pm
	./Types/Standard/CycleTuple.pm
	./Types/Standard/Dict.pm
	./Types/Standard/HashRef.pm
	./Types/Standard/Map.pm
	./Types/Standard.pm
	./Types/Standard/ScalarRef.pm
	./Types/Standard/StrMatch.pm
	./Types/Standard/Tied.pm
	./Types/Standard/Tuple.pm
	./Types/TypeTiny.pm
	./Type/Tiny/Class.pm
	./Type/Tiny/ConstrainedObject.pm
	./Type/Tiny/Duck.pm
	./Type/Tiny/Enum.pm
	./Type/Tiny/_HalfOp.pm
	./Type/Tiny/Intersection.pm
	./Type/Tiny.pm
	./Type/Tiny/Role.pm
	./Type/Tiny/Union.pm
	./Type/Utils.pm
);

my %known = map {
	my $pod = $_;
	$pod =~ s/\.(pod|pm)$//;
	$pod =~ s/\//::/g;
	$pod => 1;
} @files;

my $menu = join '', map {
	my ($f) = m{\/([^/]+)\.pod$};
	sprintf('<li class="dropdown-item"><a href="%s">%s</a></li>', $f eq 'Manual' ? '/' : "$f.html", $f);
} grep /Manual\//, @files;

my $parser = TOBYINK::Pod::HTML->new(
	code_highlighting => 1,
	pretty => 1,
);

my $template = $destdir->child('build/template.html')->slurp_utf8;

my $html5_pp      = XML::LibXML::PrettyPrint->new_for_html();
my $html5_parser  = HTML::HTML5::Parser->new;
my $html5_writer  = HTML::HTML5::Writer->new(
	doctype => HTML::HTML5::Writer::DOCTYPE_HTML5."\n",
);

push @{$html5_pp->{element}{block}}, 'main';

for my $f (@files) {
	my $srcfile   = $srcdir->child($f);
	my $pageclass;
	my $destfile  = do {
		$f =~ s/Type.Tiny.Manual.//;
		$f =~ s/(pod|pm)$/html/;
		$f =~ s/\//-/g;
		$f = 'index.html' if $f eq 'html';
		($pageclass = $f) =~ s/\.html$//;
		path($f);
	};
	
	my $pod = $srcfile->slurp_utf8;	
	$pod =~ s/=head1 AUTHOR.*//s;  # remove ending boilerplate
	$pod =~ s/=head1 SEE ALSO.*//s if $f eq 'index.html';
	
	my $dom = $parser->string_to_dom($pod);
	
	$dom->querySelectorAll('a[href]')->foreach(sub {
		if ($_->{href} =~ m{^https?://metacpan\.org/pod/(.+)$}) {
			my $man = $1;
			my $anchor;
			($man, $anchor) = split /#/, $man;
			$man =~ s/%3A/:/g;
			if ($man eq 'Type::Tiny::Manual') {
				$_->{href} = '/';
			}
			elsif ($man =~ m'Type::Tiny::Manual::(.+)') {
				$_->{href} = "$1\.html";
			}
			elsif ($known{$man}) {
				my $html = $man;
				$html =~ s/::/-/g;
				$_->{href} = "$html\.html";
			}
			else {
				$_->{href} = "https://metacpan.org/pod/$man";
			}
			$_->{href} .= '#'.$anchor if $anchor;
		}
	});
	
	$dom->querySelectorAll('pre.highlighting-perl')->foreach(sub {
		my $e = $_;
		my $new = $dom->createElement('div');
		$new->{class} = 'card p-3 my-3 bg-light';
		$new->appendChild($e->cloneNode(1));
		$e->replaceNode($new);
	});
	
	my $title = '';
	my $lede  = '';
	my $main  = '';
	my $cards = '';
	my @toc;
	my $ns = '';
	
	if ($f eq 'index.html' or $f eq 'Installation.html') {
		#https://metacpan.org/release/Type-Tiny
		$cards .= 
			'<div class="card bg-info text-white mb-3">' .
			'<div class="card-header">Get Type::Tiny</div>' .
			'<div class="card-body">' .
			sprintf('<p>Type::Tiny&nbsp;%s is available on CPAN.</p>', $version) . 
			( $stable_version lt $version
				? sprintf(
					'<p style="font-size:85%%"><a style="text-decoration:none!important" href="https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Type-Tiny-%s.tar.gz"><i class="fa fa-download"></i> <b>Stable version %s</b></a><br><a style="text-decoration:none!important" href="https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Type-Tiny-%s.tar.gz"><i class="fa fa-download"></i> <b>Trial version %s</b></a></p>',
					$stable_version,
					$stable_version,
					$version,
					$version,
				)
				: sprintf(
					'<p style="font-size:85%%"><a style="text-decoration:none!important" href="https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Type-Tiny-%s.tar.gz"><i class="fa fa-download"></i> <b>Version %s</b></a></p>',
					$stable_version,
					$stable_version,
				)
			).
			"</div></div>\n";
	}
	elsif ($f =~ /-/) {
		$cards .= 
			'<div class="card bg-secondary mb-3">' .
			'<div class="card-header">Manual</div>' .
			'<div class="card-body">' .
			sprintf('The best place to start learning about this module is <a href="/">the manual</a>.') . 
			"</div></div>\n";
	}
	
	my @kids = $dom->querySelector('body')->childNodes;
	LOOP: while (@kids) {
		my $e = shift @kids;
		if ($e->nodeName eq 'h1' and $e->textContent eq 'NAME') {
			while ($kids[0]->nodeName ne 'h1') {
				my $maybe_p = shift @kids;
				if ($maybe_p->nodeName eq 'p') {
					($title, $lede) = split / - /, $maybe_p->textContent, 2;
				}
			}
			next LOOP;
		}
		elsif ($e->nodeName eq 'h1' and $e->textContent eq 'NEXT STEPS') {
			while (@kids and $kids[0]->nodeName ne 'h1') {
				$ns .= shift @kids;
			}
		}
		elsif ($e->nodeName eq 'h1' and $e->textContent eq 'MANUAL' and $f ne 'index.html') {
			# skip
		}
		elsif ($e->nodeName eq 'h1') {
			my $heading = Lingua::EN::Titlecase->new($e->textContent);
			$e->setNodeName('h2');
			$e->querySelector('span')->childNodes->[0]->setData($heading->title);
			push @toc, {
				title => $e->textContent,
				id    => $e->querySelector('span')->{id},
			};
			$main .= "$e";
		}
		elsif ($e->nodeName eq 'h2') {
			push @toc, {
				title => $e->textContent,
				id    => $e->querySelector('span')->{id},
			};
			$main .= "$e";
		}
		elsif ($e->nodeName eq 'h3') {
			push @{$toc[-1]{subheadings}||=[]}, {
				title => $e->textContent,
				id    => $e->querySelector('span')->{id},
			};
			$main .= "$e";
		}
		else {
			$main .= "$e";
		}
	}
	
	$cards .=
		'<div class="card bg-primary mb-3">' .
		'<div class="card-header">Contents</div>' .
		sprintf(
			'<ul class="list-group list-group-flush">%s</ul>',
			join '', map {
				my $h = $_;
				my $sh = '';
				if ($h->{subheadings}) {
					$sh .= '<ul class="list-subgroup">';
					$sh .= join '', map {
						sprintf(
							'<li class="list-subgroup-item"><a href="#%s">%s</a></li>',
							encode_entities($_->{id}),
							encode_entities($_->{title}),
						);
					} @{$h->{subheadings}};
					$sh .= '</ul>';
				}
				sprintf(
					'<li class="list-group-item"><a href="#%s">%s</a>%s</li>',
					encode_entities($h->{id}),
					encode_entities($h->{title}),
					$sh,
				);
			} @toc,
		) .
		"</div>\n" if @toc;
	
	$cards .= path("cards/$destfile.cards")->slurp_utf8 if -f "cards/$destfile.cards";
	
	$main .= 
		'<div class="card bg-dark text-white mb-3">' .
		'<div class="card-header">Next Steps</div>' .
		'<div class="card-body">' .
		$ns .
		"</div></div>\n" if $ns;
	
	my $nicetitle = $title;
	if ($nicetitle =~ /Manual/) {
		$nicetitle =~ s/::/&nbsp;» /g;
		$nicetitle =~ s/&nbsp;»\s/::/;
	}
	
	my $banner = '';
	if ($f eq 'index.html') {
		$banner = '<img class="fullwidth" src="/assets/banner.jpeg" alt="">';
	}
	
	my $page = $template;
	$page =~ s/#TITLE#/$title/g;
	$page =~ s/#NICETITLE#/$nicetitle/g;
	$page =~ s/#LEDE#/$lede/g;
	$page =~ s/#CONTENT#/$main/;
	$page =~ s/#CARDS#/$cards/;
	$page =~ s/#MENU#/$menu/;
	$page =~ s/#VERSION#/Type::Tiny->VERSION/e;
	$page =~ s/#PAGECLASS#/$pageclass/;
	$page =~ s/#FULLWIDTHBANNER#/$banner/;
	$page =~ s{<span id="___top"/>}{};   # this screws up things

	eval {
		my $final_dom = fix_document( $html5_parser->parse_string($page) );
		$html5_pp->pretty_print($final_dom);
		$page = $html5_writer->document($final_dom);
	} or warn "error pretty-printing for $destfile\n";
	
	$destfile->spew_utf8($page);
}

system(
	rsync => (
		'-r',
		'--exclude'  => '.hg*',
		"$destdir/",
		$upload,
	)
);
