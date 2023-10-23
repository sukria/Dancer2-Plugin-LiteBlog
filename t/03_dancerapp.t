use Test::More;
use Plack::Test;
use HTTP::Request::Common; # install separately
 
{
    package SampleApp;
    use Dancer2;
    use Dancer2::Plugin::LiteBlog;
    #set logger => 'Console::Colored';
    #set log => 'core';

    1;
} 

my $app  = SampleApp->to_app;
my $test = Plack::Test->create($app);
 
my $res = $test->request( GET '/' );
is( $res->code, 200, '[GET /] Request successful' );
like( $res->content, qr/TODO : \//, '[GET /] Correct content' );

$res = $test->request( GET '/blog/tech/some-article' );
is( $res->code, 200, '[GET /] Request successful' );
like( $res->content, qr{TODO: /blog/tech/some-article}, '[GET /blog/tech/article] Correct content' );
 
done_testing;
