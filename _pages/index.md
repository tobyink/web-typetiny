<div class="mx-auto my-5">
	<div class="row gx-5">
		<div class="col-12 col-md-6 col-lg-8 col-xl-9">
			<h2 class="display-4">What is Type::Tiny?</h2>
			<p class="lead">Type::Tiny is a small Perl class for writing type constraints,
			inspired by Moose's type constraint API and MooseX::Types. It has only one
			non-core dependency (and even that is simply a module that was previously
			distributed as part of Type::Tiny but has since been spun off), and can be
			used with Moose , Mouse , or Moo (or none of the above).</p>
			<p class="lead">Type::Tiny is used by <strong>over 800 Perl distributions</strong>
			on the CPAN (Comprehensive Perl Archive Network) and can be considered
			a <strong>stable and mature framework</strong> for efficiently and
			reliably enforcing data types.</p>
		</div>
		<div class="col-12 col-md-6 col-lg-4 col-xl-3">
			<div class="card bg-primary text-white">
				<h2 class="card-header">Get Type-Tiny</h2>
				<div class="card-body">
					<p>Type-Tiny 2.002001 is available on CPAN.</p>
					<p><a class="btn btn-dark" href="https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Type-Tiny-2.002001.tar.gz"><i class="fa-solid fa-download"></i> Type-Tiny 2.002001</a></p>
				</div>
			</div>
		</div>
	</div>
	<p class="text-center pt-4"><img alt="GitHub Issues" src="https://img.shields.io/github/issues/tobyink/p5-type-tiny" title="GitHub Issues"> <img alt="GitHub Actions" src="https://github.com/tobyink/p5-type-tiny/workflows/CI/badge.svg" title="GitHub Actions"> <img alt="Coveralls status" src="https://coveralls.io/repos/github/tobyink/p5-type-tiny/badge.svg?branch=master" title="Coveralls status"> <img alt="Codecov status" src="https://codecov.io/gh/tobyink/p5-type-tiny/branch/master/graph/badge.svg" title="Codecov status"></p>
</div>

----

<div class="my-4">
	<h2 class="display-2 text-center">What people are saying</h2>
	<div class="row gx-5">
		<div class="col-12 col-md-6">
			<figure class="py-4">
				<blockquote class="blockquote">
					<p>[...] our company is finding more and more clients relying on
					Type::Tiny due to the safety it provides.</p>
				</blockquote>
				<figcaption class="blockquote-footer">
					Curtis "Ovid" Poe, All Around The World.
				</figcaption>
			</figure>
		</div>
		<div class="col-12 col-md-6">
			<figure class="py-4">
				<blockquote class="blockquote">
					<p>Thanks! Keep up the good work! Type::Tiny is literally one of my favorite parts of Perl.</p>
				</blockquote>
				<figcaption class="blockquote-footer">
					Avishai Goldman.
				</figcaption>
			</figure>
		</div>
	</div>
</div>

----

<div class="my-5">
<h2 class="display-1 text-center my-3">A quick example</h2>
<pre><code>use v5.12;
use strict;
use warnings;

package Horse {
  use Moo;
  use Types::Standard qw( Str Int Enum ArrayRef InstanceOf );
  use Type::Params qw( signature );
  use namespace::autoclean;
  
  has name => (
    is       => 'ro',
    isa      => Str,
    required => 1,
  );
  has gender => (
    is       => 'ro',
    isa      => Enum[qw( f m )],
  );
  has age => (
    is       => 'rw',
    isa      => Int->where( '$_ >= 0' ),
  );
  has children => (
    is       => 'ro',
    isa      => ArrayRef[ InstanceOf['Horse'] ],
    default  => sub { return [] },
  );
  
  sub add_child {
    state $check = signature(
      method     => Object,
      positional => [ InstanceOf['Horse'] ]
    );
    
    my ( $self, $child ) = $check->(@_);   # unpack @_
    push @{ $self->children }, $child;
    
    return $self;
  }
}</code></pre>
</div>

----

<div class="my-5">
	<h2 class="display-1 text-center pb-3">Features</h2>
	<div class="w-xl-50 w-lg-75 mx-auto">
		<ul>
			<li>Type check values in constructors and attribute setters in object-oriented programming.</li>
			<li>Check the types of function/method parameters.</li>
			<li>Tie a type constraint to a variable.</li>
			<li>Check the type of values on-the-fly.</li>
			<li>Fast type constraint checks, with an optional implementation in C.</li>
		</ul>
	</div>
</div>

----

<h2 class="display-1">Download</h2>
<div class="row">
	<div class="col-12 col-lg-6">
		<h3>Distributions</h3>
		<p>If you are using Linux, BSD, or a similar operating system, and
		you are using the system copy of Perl (usually <code>/usr/bin/perl</code>),
		then the best way to install Type-Tiny is using your operating system's
		package management tools.</p>
		<p>Type-Tiny is available for most Linux and BSD distributions.</p>
		<table class="table">
			<tbody>
				<tr>
					<th><i class="fa-brands fa-linux"></i> Arch Linux</th>
					<td><a target="_blank" href="https://archlinux.org/packages/extra/any/perl-type-tiny/">perl-type-tiny</a></td>
				</tr>
				<tr>
					<th><i class="fa-brands fa-linux"></i> Debian</th>
					<td><a target="_blank" href="https://packages.debian.org/sid/libtype-tiny-perl">libtype-tiny-perl</a></td>
				</tr>
				<tr>
					<th><i class="fa-brands fa-fedora"></i> Fedora OS</th>
					<td><a target="_blank" href="https://packages.fedoraproject.org/pkgs/perl-Type-Tiny/perl-Type-Tiny/">perl-Type-Tiny</a></td>
				</tr>
				<tr>
					<th><i class="fa-brands fa-linux"></i> Manjaro</th>
					<td><a target="_blank" href="https://software.manjaro.org/package/perl-type-tiny">perl-type-tiny</a></td>
				</tr>
				<tr>
					<th><i class="fa-brands fa-redhat"></i> Redhat</th>
					<td><a target="_blank" href="https://packages.fedoraproject.org/pkgs/perl-Type-Tiny/perl-Type-Tiny/">perl-Type-Tiny</a></td>
				</tr>
				<tr>
					<th><i class="fa-brands fa-suse"></i> SuSE</th>
					<td><a target="_blank" href="https://software.opensuse.org/package/perl-Type-Tiny">perl-Type-Tiny</a></td>
				</tr>
				<tr>
					<th><i class="fa-brands fa-ubuntu"></i> Ubuntu</th>
					<td><a target="_blank" href="https://packages.ubuntu.com/search?keywords=libtype-tiny-perl&searchon=names">libtype-tiny-perl</a></td>
				</tr>
				<tr>
					<th><i class="fa-brands fa-freebsd"></i> FreeBSD</th>
					<td><a target="_blank" href="https://www.freshports.org/devel/p5-Type-Tiny">p5-Type-Tiny</a></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="col-12 col-lg-6">
		<h3>CPAN</h3>
		<p>If you are using a non-system copy of Perl (for example, one installed in your home directory, or via perlbrew), then you should install Type-Tiny from CPAN.</p>
		<p><a class="btn btn-primary btn-lg" href="https://metacpan.org/dist/Type-Tiny"><i class="fa-solid fa-download"></i> Download from the CPAN</a></p>
		<p>Further <a href="/Installation.html">installation advice</a> is available.</p>
		<h3>Github</h3>
		<p>Rarely, you will want to install the latest version from <a href="https://github.com/tobyink/p5-type-tiny">Github</a>.</p>
	</div>
</div>


----

<div class="text-center w-lg-75 w-xl-50 mx-auto">
	<p style="font-size:2rem">Powered by <a class="text-decoration:none" href="http://www.perl.org/">Perl</a></p>
	
	<h2 class="h4">What is Perl?</h2>
	<p>Perl is a high-level, general-purpose, interpreted, dynamic programming language. Perl was developed by Larry Wall in 1987 as a general-purpose Unix scripting language to make report processing easier. Since then, it has undergone many changes and revisions. In 1998, it was also referred to as the "duct tape that holds the Internet together."</p>
</div>

