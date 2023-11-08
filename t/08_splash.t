use Test::More;
 
use Dancer2::Plugin::LiteBlog::Splash;

my $splash = Dancer2::Plugin::LiteBlog::Splash->new(
    root => 't',
    title => 'Some Splash',
    baseline => 'foo',
    cta => { label => 'Subscribe!', link => '/clickhere'},
);

is_deeply [ {
        title => 'Some Splash', 
        baseline => 'foo',
        cta_link => '/clickhere',
        cta_label => 'Subscribe!',
        image => undef,
        }
    ], $splash->elements, "elements is correctly formated";

done_testing;
