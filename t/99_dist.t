use Test::More;
use strict;
use warnings;

SKIP: {
    skip "because LITEBLOG_DIST_TEST is not set" 
        if ! $ENV{LITEBLOG_DIST_TEST};

    my $module = 'LiteBlogDist';
    require "${module}.pm";
    eval {
        $module->import();
    };
    is ($@, "", "no error while loading the module");

    my $files = LiteBlogDist::slurp_files('t');
    like $files->{'views/index.tt'}->{content}, qr/\[% IF has_posts %\]/,
        "view index is slurped";


};

done_testing;
