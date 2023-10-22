package Dancer2::Plugin::LiteBlog;

use 5.006;
use strict;
use warnings;

=head1 NAME

Dancer2::Plugin::LiteBlog - A minimalist, file-based blog engine for Dancer2. 


=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Effortlessly transform your Dancer2 app to db-free blog engine. 
Articles are stored in local markdown files. and .yml files into a sleek and responsive blog without the need for a database.

    # in your Dancer2 app

    use Dancer2::Plugin::LiteBlog;

    # default routes are created (/, /blog, /blog/:category/:slug, ...)

=head1 IMPORTED ROUTES

TODO

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
