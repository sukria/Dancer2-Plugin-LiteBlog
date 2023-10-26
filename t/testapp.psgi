#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

{
    package app;
    use Dancer2;
    set appdir => 't';
    set views => 't/views';
    set public_dir => 't/public';
    set logger => 'Console::Colored';
    set template => 'template_toolkit';

    set liteblog => {
        title => "My Testing Liteblog",
        widgets => [
            { name => 'activities',
              params => { source => 'activities.yml' }},
            { name => 'blog',
              params => {
                title => "Stories of my Test App",
                root => 't/articles' }},
        ],
    };
    require 'Dancer2/Plugin/LiteBlog.pm';
    Dancer2::Plugin::LiteBlog->import;
}

app->to_app;
