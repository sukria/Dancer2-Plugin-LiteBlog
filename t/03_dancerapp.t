use Test::More;
use Plack::Test;
use HTTP::Request::Common; # install separately
use File::Basename 'dirname';
use File::Spec;
 
{
    package SampleApp;
    use Dancer2;
    use Dancer2::Plugin::LiteBlog;
    set views => File::Spec->catfile( dirname(__FILE__), 'views');
    set appdir => File::Spec->catfile(dirname(__FILE__)),

    set logger => 'Console::Colored';
    set log => 'core';
    set liteblog => {
        blog => {
            title => 'Read my Stories',
            root  => File::Spec->catfile(dirname(__FILE__), 'articles'),
        },
        activities => {
            source => 'activities.yml',
        },
    };

    1;
} 

my $app  = SampleApp->to_app;
my $test = Plack::Test->create($app);
 
# Testing the / route with default tokens/views
my $res = $test->request( GET '/' );
is( $res->code, 200, '[GET /] Request successful' );
like( $res->content, qr/<title>A Great Liteblog Site/, 
    '[GET /] Default title is populated' );

like( $res->content, qr/"activity-card clickable-div" id="activity-GitHub"/, "activity section found with GitHub mentioned");

like( $res->content, qr/"blog-card" id="blog-first-article"/, 
    '[GET /] Section blog is found');
like( $res->content, qr/<h2>Read my Stories/, 
    '[GET /] Blog section title found');

# Activity cards
like( $res->content, qr/blog-card.*<h3>A super lightweight Dancer-based blog engine/s, 
    '[GET /] First blog card found');

# Testing the blog post permalink route
$res = $test->request( GET '/blog/tech/some-article' );
is( $res->code, 200, '[GET /] Request successful' );
like( $res->content, qr{TODO: /blog/tech/some-article}, '[GET /blog/tech/article] Correct content' );




done_testing;
