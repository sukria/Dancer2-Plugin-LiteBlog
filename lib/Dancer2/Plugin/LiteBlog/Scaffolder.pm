package Dancer2::Plugin::LiteBlog::Scaffolder;
use Moo;
use Dancer2::Plugin::LiteBlog::Scaffolder::Data;
use Carp 'croak';
use File::Spec;
use File::Path qw(make_path);

=head1 LiteBlog Scaffolder - bootstrap your views for your LiteBlog site

This helper is here to get you strated in a snap with a sleek and responsive
design for your site.

=head1 USAGE

Right after having generated your Dancer2 app, inside the app directory, 
call C<liteblog-scaffold> to generate all default views and static files 
that are designed to work nicely with L<Dancer2::Plugin::LiteBlog>.

=cut

sub load {
    my $data = {};
    my $file;

	while (my $line = <Dancer2::Plugin::LiteBlog::Scaffolder::Data::DATA>) {
        if ($line =~ /--- (.*)\n/) {
            $file = $1;
        $data->{$file} = "";
            next;
        }
        if (defined $file) {
            $data->{$file} .= $line;
        }
    }
	return $data;
}

sub scaffold {
    my ($basedir) = @_;
	my $data = load();
	foreach my $file_k (keys %$data) {
        my @subs = split('/', $file_k);
        my $filename = pop @subs;

        # Create the directory structure
        make_path(File::Spec->catfile($basedir, @subs));

        # Write the file to the appropriate path
		my $target = File::Spec->catfile($basedir, @subs, $filename);
		if (-e $target) {
			print "$target already exists, skipping\n";
		}
		else {
			open my $fh, '>', $target or croak "Unable to create $target";
			print $fh $data->{$file_k};
			close $fh;
			print "Created: $target\n";
		}
	}
}

1;
