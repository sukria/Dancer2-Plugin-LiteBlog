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

    set _liteblog => {
        activities => {
            content => 'activities.yml',
        },
        blog => {
            title => "My Stories",
            root => 't/articles',
        },
    };
    require 'Dancer2/Plugin/LiteBlog.pm';
    Dancer2::Plugin::LiteBlog->import;
}

app->to_app;
