package Test::Ping;

use warnings;
use strict;

my  $CLASS    = __PACKAGE__;
my  $HASHPATH = '_net-ping';
our $PROTO    = q{};
our @EXPORT   = qw( ping_ok );

BEGIN {
    use base 'Test::Builder::Module';
    use Net::Ping;

    __PACKAGE__->builder
               ->{'_net-ping'}
               ->{'object'} = Net::Ping->new();
}

use Data::Dumper;

sub _update_variables {
    my $tb = shift;
    $tb->{$HASHPATH}{'PROTO'} = $PROTO;
}

sub ping_ok {
    my ( $host, $name ) = @_;
    my $tb = $CLASS->builder;
    my $pinger = $tb->{$HASHPATH}->{'object'};
    _update_variables($tb);

    my $alive = $pinger->ping($host);
    $tb->ok( $alive, $name );
}

sub _has_var_ok {
    my ( $var_name, $var_value, $name ) = @_;
    my $tb = $CLASS->builder;
    _update_variables($tb);
    $tb->is_eq( $tb->{$HASHPATH}->{$var_name}, $var_value, $name );
}

END {
    __PACKAGE__->builder
               ->{$HASHPATH}
               ->{'object'}
               ->close();
}

1;

__END__

=head1 NAME

Test::Ping - Testing pings using Net::Ping

=head1 VERSION

Version 0.02

=head1 SYNOPSIS

This module helps test pings using Net::Ping

    use Test::More tests => 1;
    use Test::Ping;

    ping_ok( $host, "able to ping $host" );
    ...

=head1 EXPORT

ping_ok

=head1 FUNCTIONS

=head2 ping_ok

Checks if a host replies to ping correctly. Uses Net::Ping.

=head1 INTERNAL FUNCTIONS

=head2 _update_variables($tb)

Updates the internal variables, used by Net::Ping.

Gets the test builder object, returns nothing.

=head2 _has_var_ok( 'PROT', 'icmp', 'has correct protocol' )

Gets a variable name to test, what to test against and the name of the test. Runs an actual test using Test::Builder.

This is used to debug the actual module, if you wanna make sure it works.

=head1 AUTHOR

Sawyer X, C<< <xsawyerx at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-test-ping at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test-Ping>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Test::Ping


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Test-Ping>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Test-Ping>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Test-Ping>

=item * Search CPAN

L<http://search.cpan.org/dist/Test-Ping/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Sawyer X, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

