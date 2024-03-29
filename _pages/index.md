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
			<p class="text-center pt-4"><img alt="GitHub Issues" src="https://img.shields.io/github/issues/tobyink/p5-type-tiny" title="GitHub Issues"> <img alt="GitHub Actions" src="https://github.com/tobyink/p5-type-tiny/workflows/CI/badge.svg" title="GitHub Actions"> <img alt="Coveralls status" src="https://coveralls.io/repos/github/tobyink/p5-type-tiny/badge.svg?branch=master" title="Coveralls status"> <img alt="Codecov status" src="https://codecov.io/gh/tobyink/p5-type-tiny/branch/master/graph/badge.svg" title="Codecov status"></p>
		</div>
		<div class="col-12 col-md-6 col-lg-4 col-xl-3">
			<div class="card bg-info text-white mb-3">
				<h2 class="card-header h4">Get Type-Tiny</h2>
				<div class="card-body">
					<p>Get Type-Tiny v2.4.0 from CPAN.</p>
					<p><a class="btn btn-dark w-100" href="https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Type-Tiny-2.004000.tar.gz"><i class="fa-solid fa-download"></i> Type-Tiny-2.004000</a></p>
				</div>
			</div>
			<!-- div class="card bg-danger text-white mb-3">
				<h2 class="card-header h4">Trial Release</h2>
				<div class="card-body">
					<p>Get Type-Tiny v2.3.0 from CPAN.</p>
					<p><a class="btn btn-dark w-100" href="https://cpan.metacpan.org/authors/id/T/TO/TOBYINK/Type-Tiny-2.003_000.tar.gz"><i class="fa-solid fa-download"></i> Type-Tiny-2.003_000</a></p>
				</div>
			</div -->
			<p class="text-center"><small class="text-muted">Earlier versions of Type-Tiny are <a class="text-muted" href="https://metacpan.org/dist/Type-Tiny">available on the CPAN</a>, but a lot of effort is kept to maintain backwards compatibility with Type-Tiny 1.000000, so installing an older version should almost never be necessary.</small></p>
		</div>
	</div>
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
		<h3>Extras</h3>
		<p>Some of the features discussed on this website are not included in the main Type-Tiny distribution, but in external distributions. In particular, <a target="_blank" href="https://exportertiny.github.io/">Exporter-Tiny</a>, <a target="_blank" href="https://metacpan.org/dist/Type-API">Type-API</a>, <a target="_blank" href="https://metacpan.org/dist/Types-Self">Types-Self</a>, and <a target="_blank" href="https://metacpan.org/dist/Types-Path-Tiny">Types-Path-Tiny</a>.
	</div>
</div>


----

<div class="text-center w-lg-75 w-xl-50 mx-auto">
	<svg xmlns="http://www.w3.org/2000/svg" version="1.1" style="max-width:180px;margin-bottom:1rem" viewBox="0 0 400 365">
		<title>Perl 5 Raptor</title>
		<description>Copyright (C) 2012, Sebastian Riedel.</description>
		<g fill="none">
			<path d="M273,205 C265,213 266,214 262,223 C258,231 257,231 258,238 C258,242 260,241 264,245 C266,246 267,247 268,248 C270,251 269,251 271,253 C273,257 274,255 276,259 C278,264 278,265 277,271 C277,275 274,277 274,281 C273,291 272,299 272,300 C272,308 272,308 271,316 C271,324 270,324 268,331 C267,334 266,333 265,336 C264,339 265,338 264,341 C263,343 262,344 261,345 C261,345 260,345 259,345 C257,346 257,345 255,346 C253,347 252,346 251,348 C249,350 249,355 249,355 C249,355 248,352 247,350 C247,349 246,348 247,345 C247,342 248,342 249,339 C250,337 252,335 252,335 C248,337 248,338 243,340 C240,341 240,341 237,340 C235,339 235,338 235,338 C235,338 232,337 230,337 C227,338 223,343 223,343 C223,343 223,338 225,335 C226,331 226,331 229,329 C232,327 233,329 236,327 C241,324 245,319 245,319 C245,319 242,318 240,317 C237,315 237,315 235,312 C234,310 234,309 234,307 C235,305 237,303 237,303 C237,303 239,301 239,299 C240,297 240,296 239,294 C238,293 237,293 234,293 C232,293 232,292 230,293 C227,295 224,298 224,298 C224,298 224,294 226,292 C229,287 229,287 234,285 C238,283 239,283 243,283 C247,284 248,285 251,288 C253,289 254,299 254,299 C254,299 255,288 257,283 C258,279 257,274 257,274 C257,274 253,276 249,275 C243,274 242,274 236,270 C231,265 231,265 228,258 C226,254 227,252 225,248 C224,244 221,244 219,241 C216,236 213,231 213,231 C213,231 213,237 213,243 C213,248 213,247 213,253 C212,258 211,259 211,264 C211,270 212,269 214,274 C216,280 218,277 219,284 C219,287 217,293 217,293 C217,293 216,298 215,304 C214,312 215,313 214,321 C212,328 210,335 210,335 C210,335 209,341 205,345 C200,350 200,351 192,353 C189,354 189,353 187,353 C185,354 185,354 184,354 C183,355 182,354 180,355 C178,356 178,356 176,358 C174,359 171,363 171,363 C171,363 171,360 172,356 C173,352 178,349 178,349 C178,349 176,349 174,349 C172,350 172,350 170,350 C167,351 167,350 164,350 C161,351 158,355 158,355 C158,355 158,351 160,348 C162,345 163,345 166,343 C169,342 170,344 172,342 C179,338 179,337 185,332 C189,328 186,329 185,326 C184,324 184,324 184,322 C184,321 187,319 185,319 C181,320 179,320 178,323 C176,326 179,332 179,332 C179,332 173,330 172,327 C171,323 170,320 171,317 C173,313 175,309 179,307 C184,305 188,311 191,309 C195,306 194,306 195,301 C196,291 198,291 196,281 C193,272 191,272 186,263 C183,256 183,256 181,249 C179,242 183,240 180,235 C178,232 175,231 171,232 C168,233 167,235 166,238 C166,243 168,243 169,248 C171,254 170,254 171,260 C171,264 172,264 172,267 C171,270 171,270 170,272 C168,277 170,277 168,281 C166,285 163,287 163,287 C163,287 164,280 163,272 C163,270 162,271 161,268 C160,264 161,263 160,259 C159,250 158,241 158,241 C158,241 156,254 155,268 C155,271 156,271 156,274 C156,276 155,276 154,279 C154,284 154,284 154,290 C155,295 156,300 156,300 C156,300 153,298 151,295 C149,291 148,291 146,286 C145,283 145,283 145,279 C145,274 146,274 146,269 C147,258 147,247 147,247 L139,262 C139,262 139,265 138,267 C136,270 134,269 133,271 C131,273 132,274 133,277 C135,280 139,283 139,283 C139,283 133,282 129,279 C126,276 126,275 125,270 C124,268 124,267 126,264 C133,250 134,251 143,237 C149,228 152,219 155,218 C157,216 179,219 179,216 C178,213 148,192 146,191 C143,190 142,197 139,203 C137,207 139,208 136,210 C132,212 130,213 125,211 C110,204 112,199 97,192 C93,191 90,192 88,194 C83,199 81,207 83,207 C84,208 85,206 87,207 C89,207 91,206 93,206 C98,205 101,208 101,208 C101,208 97,208 94,210 C91,211 90,212 89,214 C88,216 86,215 85,216 C85,216 84,217 85,218 C86,219 87,217 89,217 C90,217 93,216 96,215 C100,213 100,213 104,210 C106,208 109,206 109,206 C109,206 109,210 107,213 C104,218 103,219 100,221 C95,225 92,224 92,225 C91,227 91,226 90,227 C90,228 90,229 91,229 C92,228 95,228 96,228 C97,229 99,228 101,227 C106,224 109,219 109,219 C109,219 108,227 104,230 C100,233 99,233 98,233 C97,234 97,234 96,235 C94,236 94,236 91,236 C89,235 84,232 79,229 C73,225 74,224 71,220 C66,214 63,212 64,206 C65,200 68,192 77,183 C83,178 87,175 95,177 C111,180 123,194 125,194 C126,193 133,173 133,162 C133,151 132,145 128,132 C124,116 120,101 118,100 C116,99 109,99 99,97 C85,96 83,95 69,94 C53,93 42,95 37,94 C33,93 33,92 32,91 C31,90 30,87 31,87 C32,87 33,86 33,86 L31,74 L37,85 L38,85 L35,70 L41,84 L43,84 L41,68 L47,83 L50,82 L48,71 L53,81 L56,81 L55,70 L59,80 L62,80 L59,67 L65,79 L67,78 L66,70 L71,76 L73,75 L71,66 L77,73 L78,73 L77,65 L80,72 L82,71 L82,67 L84,71 L85,71 L85,63 L88,70 L90,70 L90,65 L93,69 L95,69 L97,64 L99,68 C99,68 101,68 106,67 C112,65 118,62 118,62 L97,58 L94,63 L93,57 L91,56 L88,61 L87,56 L85,55 L82,61 L81,54 L79,54 L77,60 L75,53 L73,53 L72,62 L70,52 L69,52 L67,61 L65,52 L64,52 L63,64 L61,52 L60,52 L59,61 L58,52 L56,52 L54,64 L53,52 L52,52 L50,58 L49,51 L47,51 L45,61 L45,50 L43,50 L42,59 L41,50 L40,49 L38,63 L37,49 L36,49 L33,61 L32,48 C32,48 32,49 28,45 C23,42 27,37 29,33 C32,28 34,29 40,28 C63,26 62,28 85,27 C94,26 95,23 103,25 C110,26 111,27 117,30 C125,33 126,32 133,35 C141,38 142,38 149,43 C155,47 156,47 160,54 C165,63 165,63 167,74 C171,93 171,109 171,114 C171,119 172,118 176,120 C182,123 182,122 189,123 C199,124 200,123 210,125 C218,127 219,126 226,129 C233,132 239,138 239,138 C239,138 246,140 253,144 C257,146 257,147 261,149 C266,150 272,150 272,150 C272,150 286,150 301,148 C316,146 316,147 332,144 C342,141 351,137 351,137 C351,137 360,132 358,127 C356,122 349,122 345,117 C342,114 341,111 341,108 C340,105 341,101 345,97 C348,92 352,89 361,89 C374,87 381,87 389,92 C397,97 396,102 396,102 C396,102 390,96 382,95 C372,94 368,93 361,97 C355,100 354,103 356,109 C358,114 365,114 368,115 C371,117 377,119 379,127 C381,135 375,145 375,145 C375,145 369,155 342,168 C314,180 318,177 296,189 C284,196 283,196 273,205 L273,205 M101,37 C103,37 105,36 105,34 C105,32 103,31 101,31 C98,31 95,32 95,34 C95,36 98,37 101,37 L101,37" fill="rgb(0,0,0)"></path>
		</g>
	</svg>

	<p style="font-size:2rem">Powered by <a class="text-decoration:none" href="http://www.perl.org/">Perl</a></p>
	
	<h2 class="h4">What is Perl?</h2>
	<p>Perl is a high-level, general-purpose, interpreted, dynamic programming language. Perl was developed by Larry Wall in 1987 as a general-purpose Unix scripting language to make report processing easier. Since then, it has undergone many changes and revisions. In 1998, it was also referred to as the "duct tape that holds the Internet together."</p>
</div>

