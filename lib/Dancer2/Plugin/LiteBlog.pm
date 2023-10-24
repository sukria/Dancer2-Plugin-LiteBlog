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

my $_BLOG;
sub liteblog_blog {
    my ($plugin) = @_;
    return $_BLOG if defined $_BLOG;
    
    my $app_config = $plugin->dsl->config->{'liteblog'};
    my $blogconfig = $app_config->{blog}; 
    my $blogdir    = $blogconfig->{root}; 
    if (! defined $blogdir) {
        $plugin->dsl->info("No blog defined. Set <liteblog.blog.root> in the settings ".
            "as a valid directory to define it.");
        return;
    }

    $_BLOG = Dancer2::Plugin::LiteBlog::Blog->new(rootdir => $blogdir);; 
    return $_BLOG;
}

my $_ACTIVITIES;
sub liteblog_activities {
    my ($plugin) = @_;
    return $_ACTIVITIES if defined $_ACTIVITIES;

    my $app_config    = $plugin->dsl->config->{'liteblog'};
    my $widgetconfig  = $app_config->{activities}; 
    my $activity_file = $widgetconfig->{content};
    if (! defined $activity_file) {
        $plugin->dsl->info("Widget 'Activities' is not enabled. ".
            "Set <liteblog.activities.content> as a valid YAML file (local to your appdir) ".
            "to enable it."); 
        return;
    }

    $_ACTIVITIES = Dancer2::Plugin::LiteBlog::Activities->new(
        rootdir => $plugin->dsl->config->{'appdir'},
        file    => $activity_file,
    );
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
            my $app_config = $plugin->dsl->config->{'liteblog'};
            $plugin->dsl->info("LiteBlog Init: 'liteblog' config entries are populated ".
                "to the template tokens", $app_config);

            foreach my $k (keys %$app_config) {
                $tokens->{$k} = $app_config->{$k};
            }

            # If the blog engine is enabled, try to fetch featured posts
            my $posts = [];
            if (defined $app_config->{blog}) {
                eval { $posts = liteblog_blog($plugin)->featured_posts };
                $plugin->dsl->error("Problem with the Blog widget: $@") if $@;
            }
            $tokens->{posts} = $posts;
            $tokens->{has_posts} = scalar(@{$posts});

            # Activity widget
            my $activities = [];
            if (defined $app_config->{'activities'}) {
                eval { 
                    $activities = liteblog_activities($plugin);
                    $activities = $activities->content || [];
                };
                $plugin->dsl->error("Problem with the Activities widget: $@") if $@;
            }
            $tokens->{activities} = $activities;
            $tokens->{has_activities} = scalar(@{$activities});

            $tokens->{no_widgets} = !($tokens->{has_posts} || $tokens->{has_activities});
            # set a default title, if unset
            $tokens->{title} = $app_config->{'title'} || "A Great Liteblog Site" 
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

