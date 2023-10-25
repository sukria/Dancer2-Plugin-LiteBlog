package Dancer2::Plugin::LiteBlog::Widget;
use Moo;
use Carp 'croak';

has root => (
    is => 'ro',
    required => 1,
    isa => sub {
        my $val = shift;
        croak "Not a valid directory ($val)" if ! -d $val;
    },
);

sub elements {
    croak "Must be implemented by child class";
}

1;
