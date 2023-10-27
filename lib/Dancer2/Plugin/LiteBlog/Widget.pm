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

sub has_routes { 0 }

sub declare_routes { 
    croak "Must be implemented by chikld class";
}

1;
