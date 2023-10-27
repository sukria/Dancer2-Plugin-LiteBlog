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

1;
