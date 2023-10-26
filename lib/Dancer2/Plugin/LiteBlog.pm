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

my %_widgets;

sub _get_widget {
    my ($plugin, $widget, $params) = @_; 
    return $_widgets{$widget} if defined $_widgets{$widget};
    my $class = 'Dancer2::Plugin::LiteBlog::'.ucfirst($widget);
   
    eval {
        $_widgets{$widget} = $class->new(
            root => $plugin->dsl->config->{'appdir'}, 
            %{$params});
    };
    $plugin->dsl->error("Unable to initialized widget '$widget' : $@") if $@;
    return $_widgets{$widget};
}

sub liteblog_blog {
    my ($plugin) = @_;
    return _get_widget($plugin, 'blog');
}

sub liteblog_activities {
    my ($plugin) = @_;
    return _get_widget($plugin, 'activities');
}

=head1 IMPORTED ROUTES

=head2 GET / 

This is a default base route for the site. 
A Dancer2::Plugin::LiteBlog::Blog singleton is initialized and exposed via the
liteblog_blog() keyword.


=head2 GET /:category/:slug

=cut

sub BUILD {
    my $plugin = shift;

    $plugin->dsl->info("LiteBlog Init: forcing template_toolkit");
    $plugin->app->config->{template} = 'template_toolkit';

    # Prepare default template tokens with appropriate resources.
    $plugin->app->add_hook( Dancer2::Core::Hook->new(
        name => 'before_template',
        code => sub {
            my $tokens = shift;
            
            # Each app setting is fowarded to the tokens
            my $liteblog = $plugin->dsl->config->{'liteblog'};
            $plugin->dsl->info("LiteBlog Init: 'liteblog' loaded in the template tokens.");
            foreach my $k (keys %$liteblog) {
                $tokens->{$k} = $liteblog->{$k};
                $plugin->dsl->info("token '$k' => ",$liteblog->{$k});
            }

            # Load all widgets enabled and configured in the tokens
            my @widgets;
            my $id = 1;
            foreach my $w (@{ $liteblog->{widgets} }) {
                my $widget = $w->{name};
                my $elements = [];
                eval { $elements = _get_widget($plugin, $widget, $w->{params})->elements };
                $plugin->dsl->error("Problem with widget '$widget': $@") if $@;
                if (scalar(@$elements)) {
                    push @widgets, { 
                        id => $id++,
                        name => $widget, 
                        %{$w->{params}},
                        view => "${widget}.tt",
                        elements => $elements
                    };
                }
            }
            $tokens->{widgets} = \@widgets;
            $tokens->{no_widgets} = scalar(@widgets) == 0;

            # set a default title, if unset
            $tokens->{title} = $liteblog->{'title'} || "A Great Liteblog Site" 
                if !defined $tokens->{title};

            $plugin->dsl->info("LiteBlog: tokens: ", $tokens);
            return $tokens;
        }
    ));

    $plugin->dsl->info("LiteBlog Init: registering route GET /");
    $plugin->app->add_route(
        method => 'get',
        regexp => '/',
        code   => Dancer2::Plugin::LiteBlog::Routes->index($plugin),
    );
    
    $plugin->dsl->info("LiteBlog Init: registering route GET /blog/:cat/:slug");
    $plugin->app->add_route(
        method  => 'get',
        regexp  => '/blog/:cat/:slug',
        code    => Dancer2::Plugin::LiteBlog::Routes->post_permalink($plugin),
    );
}

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

