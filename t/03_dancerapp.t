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

    set log => 'info';
    #set logger => 'Console::Colored';
    set logger => 'Null';
    set liteblog => {
        title => "03_dancerapp.t",

        navigation => [
            { label => 'Text Elem'},
            { label => 'Home', link => '/'},
        ],
        feature => {
            highlight => 1,
        },
        logo  => '/images/foo.jpg',
        widgets => [
            { name => 'blog',
              params => {
                title => 'Read my Stories',
                mount => '/someblog',
                root  => File::Spec->catfile(dirname(__FILE__), 'articles'),}},
            { name => 'activities',
              params => {
                source => 'activities.yml', }},
        ],
    };

    liteblog_init;
    1;
} 

my $app  = SampleApp->to_app;
my $test = Plack::Test->create($app);
 
# Testing the / route with default tokens/views
my $res = $test->request( GET '/' );
is( $res->code, 200, '[GET /] Request successful' );
like( $res->content, qr/<title>03_dancerapp/, 
    '[GET /] Default title is populated' );

like( $res->content, qr/"activity-card clickable-div" id="activity-GitHub"/, "activity section found with GitHub mentioned");

like( $res->content, qr/"blog-card" id="blog-first-article"/, 
    '[GET /] Section blog is found');
like( $res->content, qr/<h2>Read my Stories/, 
    '[GET /] Blog section title found');

like( $res->content, qr{"avatar-icon">.*img src="/images/foo.jpg"}s, "The logo of the site is changed"); 
# Activity cards
like( $res->content, qr/blog-card.*<h3 class="post-title">A super Tech Blog Post/s, 
    '[GET /] First blog card found');

# Testing the blog post permalink route
$res = $test->request( GET '/someblog/tech/some-article-does-not-exist/' );
is( $res->code, 404, 'invalid slug returns a 404' );

$res = $test->request( GET '/someblog/tech/first-article' );
is( $res->code, 302, 'Redirect to good permalink with trailing /' );
$res = $test->request( GET '/someblog/tech/first-article/' );
is( $res->code, 200, 'Valid slug returns a 200' );
like( $res->content, qr{<h1>This is the first title.*<p>Here I have a paragraph}s, 
    '[GET /someblog/tech/first-article] Correct content' );


subtest 'Feature: highlight' => sub {
    $res = $test->request( GET '/someblog/perl/liteblog-a-minimalist-file-based-blog-engine-for-perl/' );
    like $res->content, qr/link.*highlight\.js.*default\.min\.css/, "Highlight JS CSS source detected";
    like $res->content, qr/script.*highlight\.js.*highlight\.min\.js/, "Highlight JS lib source detected";
    like $res->content, qr/hljs\.highlightBlock/, "Highlight JS call detected";
    done_testing;
};

subtest 'Navigation bar' => sub {
    $res = $test->request( GET '/someblog/perl/liteblog-a-minimalist-file-based-blog-engine-for-perl/' );
    like $res->content, qr{<nav>.*<a href="/">Home</a>.*</nav>}s, "Navigation bar looks good";
    done_testing;
};

subtest "Local images to the article dir are rendered" => sub {
    $res = $test->request( GET '/someblog/tech/first-article/' );
    like $res->content, qr{<img src="featured\.jpg"}, 
        "the first-article rendered HTML contains an image";

    $res = $test->request( GET '/someblog/tech/first-article/featured.jpg' );
    is $res->code, 200, "the image path is valid";
    is $res->header('Content-Type'), 'image/jpeg', "the response is an image";

    done_testing;
};

subtest "Rendered Liteblog Errors" => sub {
    $res = $test->request( GET '/someblog/tech/first-article/not-existing.pdf' );
    is $res->code, 404, "HTTP status is 404";
    like $res->content, qr{<h1 class="post-title">Page Not Found</h1>.*Asset}s, "We got a nice 404 page rendered";
};

$res = $test->request(GET '/');
like $res->content, 
    qr{<a href="/blog/tech/first-article"><img class="post-image" src="/blog/tech/first-article/featured\.jpg" alt="A super Tech Blog Post"></a>}, 
    "Image URL under article path has proper permalink";

done_testing;
