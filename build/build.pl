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

my $srcdir  = path('/home/tai/src/p5/p5-type-tiny/lib/');
my $destdir = path($Bin)->parent;
my $upload  = 'server:vhosts/typetiny.toby.ink';

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
);

my $menu = join '', map {
	my ($f) = m{\/([^/]+)\.pod$};
	sprintf('<li class="dropdown-item"><a href="%s">%s</a></li>', $f eq 'Manual' ? '/' : "/$f.html", $f);
} @files;

my $parser = TOBYINK::Pod::HTML->new(
	code_highlighting => 1,
	pretty => 1,
);

my $template = $destdir->child('build/template.html')->slurp_utf8;

for my $f (@files) {
	my $srcfile   = $srcdir->child($f);
	my $destfile  = do {
		$f =~ s/Type.Tiny.Manual.//;
		$f =~ s/pod/html/;
		$f = 'index.html' if $f eq 'html';
		path($f);
	};
	
	my $pod = $srcfile->slurp_utf8;	
	$pod =~ s/=head1 AUTHOR.*//s;  # remove ending boilerplate
	$pod =~ s/=head1 SEE ALSO.*//s if $f eq 'index.html';
	
	my $dom = $parser->string_to_dom($pod);
	
	$dom->querySelectorAll('a')->foreach(sub {
		if ($_->{href} =~ m{^https?://metacpan\.org/pod/(.+)$}) {
			my $man = $1;
			$man =~ s/%3A/:/g;
			if ($man eq 'Type::Tiny::Manual') {
				$_->{href} = '/';
			}
			elsif ($man =~ m'Type::Tiny::Manual::(.+)') {
				$_->{href} = "/$1\.html";
			}
			else {
				$_->{href} = "https://metacpan.org/pod/$man";
			}
		}
	});
	
	my $title = '';
	my $lede  = '';
	my $main  = '';
	my $cards = '';
	my @toc;
	my $ns = '';
	
	if ($f eq 'index.html') {
		#https://metacpan.org/release/Type-Tiny
		$cards .= 
			'<div class="card bg-info text-white mb-3">' .
			'<div class="card-header"><i class="fa fa-download"></i> Get Type::Tiny</div>' .
			'<div class="card-body">' .
			sprintf('<a style="text-decoration:none!important" href="https://metacpan.org/release/Type-Tiny">Type::Tiny&nbsp;%s is available on CPAN</a>', Type::Tiny->VERSION) . 
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
		elsif ($e->nodeName eq 'pre') {
			$main .= "<div class=\"card p-3 my-3 bg-light\">$e</div>";
		}
		else {
			$main .= "$e";
		}
	}
	
	$cards .=
		'<div class="card bg-primary mb-3">' .
		'<div class="card-header text-white">Contents</div>' .
		sprintf(
			'<ul class="list-group list-group-flush">%s</ul>',
			join '', map {
				sprintf(
					'<li class="list-group-item"><a href="#%s">%s</a></li>',
					encode_entities($_->{id}),
					encode_entities($_->{title}),
				);
			} @toc,
		) .
		"</div>\n" if @toc;
	
	$cards .= path("$destfile.cards")->slurp_utf8 if -f "$destfile.cards";
	
	$main .= 
		'<div class="card bg-dark text-white mb-3">' .
		'<div class="card-header">Next Steps</div>' .
		'<div class="card-body">' .
		$ns .
		"</div></div>\n" if $ns;
	
	my $nicetitle = $title;
	$nicetitle =~ s/::/&nbsp;»&nbsp;/g;
	$nicetitle =~ s/&nbsp;»&nbsp;/::/;
	
	my $page = $template;
	$page =~ s/#TITLE#/$title/g;
	$page =~ s/#NICETITLE#/$nicetitle/g;
	$page =~ s/#LEDE#/$lede/g;
	$page =~ s/#CONTENT#/$main/;
	$page =~ s/#CARDS#/$cards/;
	$page =~ s/#MENU#/$menu/;
	$page =~ s/#VERSION#/Type::Tiny->VERSION/e;
	$destfile->spew($page);
}

system(
	rsync        => '-r',
	"$destdir/"  => $upload,
);
