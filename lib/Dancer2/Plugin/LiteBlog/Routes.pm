package Dancer2::Plugin::LiteBlog::Routes;

sub index {
    my ($class, $plugin) = @_;
    return sub {
        $plugin->dsl->info("in the index route");
        return $plugin->dsl->template(
            'liteblog/index', {}, { layout => 'liteblog' }
        );
    };
}

# /blog/:cat/:slug
sub post_permalink {
    my ($class, $plugin) = @_;

    return sub {
        my $cat  = $plugin->dsl->param('cat');
        my $slug = $plugin->dsl->param('slug');
        $plugin->dsl->info("in the permalink route");
        return 'TODO: '.$plugin->dsl->request->path;
    };
}

1;
