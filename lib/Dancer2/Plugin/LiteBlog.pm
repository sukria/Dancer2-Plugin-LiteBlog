package Dancer2::Plugin::LiteBlog;
use strict;
use warnings;

use Dancer2::Plugin;
use Dancer2::Plugin::LiteBlog::Routes;
use Dancer2::Plugin::LiteBlog::Blog;

use File::Spec;
use Carp 'croak';

=head1 NAME

Dancer2::Plugin::LiteBlog - A minimalist, file-based blog engine for Dancer2. 


=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


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

my $_BLOG;
sub liteblog_blog {
    my ($plugin) = @_;
    return $_BLOG if defined $_BLOG;
    my $app_config = $plugin->dsl->config->{'app'};

    my $blogdir = $app_config->{blogroot};
    if (! defined $blogdir) {
        $plugin->dsl->info("No blog defined. Set <app.blogroot> in the settings as a valid directory to define it.");
        return;
    }

    $_BLOG = Dancer2::Plugin::LiteBlog::Blog->new(rootdir => $blogdir);; 
    return $_BLOG;
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

    # Prepare default template tokens with appropriate resources.
    $plugin->app->add_hook( Dancer2::Core::Hook->new(
        name => 'before_template',
        code => sub {
            my $tokens = shift;
            
            # Each app setting is fowarded to the tokens
            my $app_config = $plugin->dsl->config->{'app'};
            foreach my $k (keys %$app_config) {
                $tokens->{$k} = $app_config->{$k};
            }
            $plugin->dsl->info("tokens: ", $tokens);

            # If the blog engine is enabled, try to fetch featured posts
            my $posts = [];
            if (defined liteblog_blog($plugin)) {
                eval { $posts = liteblog_blog($plugin)->featured_posts };
            }
            $tokens->{posts} = $posts;
            $tokens->{has_posts} = scalar(@{$posts});

            # set a default title, if unset
            $tokens->{title} = "A Great Liteblog Site" if !defined $tokens->{title};
            return $tokens;
        }
    ));

    $plugin->app->add_route(
        method => 'get',
        regexp => '/',
        code   => Dancer2::Plugin::LiteBlog::Routes->index($plugin),
    );
    $plugin->app->add_route(
        method  => 'get',
        regexp  => '/blog/:cat/:slug',
        code    => Dancer2::Plugin::LiteBlog::Routes->post_permalink($plugin),
    );
}

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

1; # End of Dancer2::Plugin::LiteBlog
