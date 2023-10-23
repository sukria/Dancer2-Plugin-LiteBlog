package Dancer2::Plugin::LiteBlog::Routes;
sub site_root {
    my ($class, $plugin) = @_;
    return sub { 
        "TODO : /" 
    };
}

# /blog/:cat/:slug
sub post_permalink {
    my ($class, $plugin) = @_;

    return sub {
        my $cat  = $plugin->dsl->param('cat');
        my $slug = $plugin->dsl->param('slug');
        return 'TODO: '.$plugin->dsl->request->path;
    };
}

1;
