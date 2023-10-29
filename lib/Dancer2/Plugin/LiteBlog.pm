package Dancer2::Plugin::LiteBlog;
=head1 NAME

Dancer2::Plugin::LiteBlog - A minimalist, file-based blog engine for Dancer2. 

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

use strict;
use warnings;
use File::Spec;
use Carp 'croak';

use Dancer2::Plugin;
use Dancer2::Plugin::LiteBlog::Activities;
use Dancer2::Plugin::LiteBlog::Routes;
use Dancer2::Plugin::LiteBlog::Blog;

sub load_widgets {
    my ($plugin, $liteblog) = @_;

    # Load all widgets and initialize them 
    my @widgets;
    my $id = 1;
    foreach my $w (@{ $liteblog->{widgets} }) {
        my $elements = [];
        my $widget;
        
        my $class = 'Dancer2::Plugin::LiteBlog::'.ucfirst($w->{name});
        eval { $widget = $class->new( 
                    root => $plugin->dsl->config->{'appdir'}, 
                    %{$w->{params}}
                );
        };
        if ($@) {
        $plugin->dsl->error("Unable to initialized widget '".
            $w->{name}."' : $@");
            next;
        }
        $elements = $widget->elements;

        if (scalar(@$elements)) {
            push @widgets, { 
                id => $id++,
                name => $w->{name}, 
                %{$w->{params}},
                view => $w->{name}.'.tt',
                instance => $widget,
                elements => $elements,
            };
        }
    }
    return \@widgets;
}

sub BUILD {
    my $plugin = shift;

    $plugin->dsl->info("LiteBlog Init: forcing template_toolkit with '[%', '%]'");
    $plugin->app->config->{template} = 'template_toolkit';
    $plugin->app->config->{engines}->{template}->{template_toolkit} = {
        start_tag => '[%',
        end_tag   => '%]',
    };

    # Prepare default template tokens with appropriate resources.
    $plugin->app->add_hook( Dancer2::Core::Hook->new(
        name => 'before_template',
        code => sub {
            my $tokens = shift;
            my $liteblog = $plugin->dsl->config->{'liteblog'};
            
            # Each app setting is fowarded to the tokens
            $plugin->dsl->info("LiteBlog Init: 'liteblog' loaded in the template tokens.");
            foreach my $k (keys %$liteblog) {
                $tokens->{$k} = $liteblog->{$k};
                $plugin->dsl->info("setting token '$k'");
            }

            # Populate the loaded widgets in the tokens 
            my $widgets = load_widgets($plugin, $liteblog);
            $tokens->{widgets} = $widgets;
            $tokens->{no_widgets} = scalar(@$widgets) == 0;

            # set a default title, if unset
            $tokens->{title} = $liteblog->{'title'} || "A Great Liteblog Site" 
                if !defined $tokens->{title};

            return $tokens;
        }
    ));

    $plugin->dsl->info("LiteBlog Init: registering route GET /");
    $plugin->app->add_route(
        method => 'get',
        regexp => '/',
        code   => Dancer2::Plugin::LiteBlog::Routes->index($plugin),
    );
}

sub liteblog_init {
    my ($plugin) = @_;
 
    warn "liteblog_init";
    my $liteblog = $plugin->dsl->config->{'liteblog'};
    my $widgets = load_widgets($plugin, $liteblog);

    $plugin->dsl->info("widgets: ", $widgets);

    # implement the declared routes of all registered widgets 
    foreach my $widget (@{ $widgets }) {
        my $w = $widget->{instance};
        next if ! $w->has_routes;
        $plugin->dsl->info("Widget '".$widget->{name}."' registered, declaring its routes…");
        $w->declare_routes($plugin, $widget);
    }
}

plugin_keywords 'liteblog_init';

1; # End of Dancer2::Plugin::LiteBlog
=head1 SYNOPSIS

Effortlessly transform your Dancer2 app to db-free blog engine. 
Articles are stored in local markdown files. and .yml files into a sleek and
responsive blog without the need for a database.

    # in your Dancer2 app

    use Dancer2::Plugin::LiteBlog;

    # default routes are created (/, /blog, /blog/:category/:slug, ...)

=head1 Plugin Keywords 

This plugin exports the following keywords in your app's DSL.

=head2 liteblog_blog()

Returns the L<Dancer2::Plugin::LiteBlog::Blog> singleton that is instanciated by
the plugin.  This is the object that represents the blog itself: it holds local
path to the article files and other meta data.

It will be enabled as soon as the setting C<app.blogroot> is defined and points
to a valid directory.

This directory is the root of the blog. Refer to
L<Dancer2::Plugin::LiteBlog::Blog> for expecting files and directory hierarchy
in this directory.

If the app does not provide a C<blogroot> setting, this keyword will return
undef, this means the site will not feature blog posts.

=cut


=head1 AUTHOR

Alexis Sukrieh, C<< <sukria at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-dancer2-plugin-liteblog at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Dancer2-Plugin-LiteBlog>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Dancer2::Plugin::LiteBlog


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Dancer2-Plugin-LiteBlog>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/Dancer2-Plugin-LiteBlog>

=item * Search CPAN

L<https://metacpan.org/release/Dancer2-Plugin-LiteBlog>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2023 by Alexis Sukrieh.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)


=cut

