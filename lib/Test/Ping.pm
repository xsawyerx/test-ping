package Test::Ping;

use warnings;
use strict;

my  $CLASS         = __PACKAGE__;
my  $HASHPATH      = '_net-ping';
my  $OBJPATH       = __PACKAGE__->builder->{'_net-ping_object'};
my  $method_ignore = '__NONE';
our @EXPORT        = qw( ping_ok );
our $VERSION       = '0.04';

# Net::Ping variables
# took the defaults, just in case
our $PROTO             = 'tcp';
our $PORT              = 7;     # echo port, default
#our $BIND              = q{};   # won't be used for now
our $TIMEOUT           = 5;
our $SOURCE_VERIFY     = 1;
our $SERVICE_CHECK     = 0;
our $TCP_SERVICE_CHECK = 0;     # deprecated, but still, why not

BEGIN {
    use base 'Test::Builder::Module';
    use Net::Ping;

    __PACKAGE__->builder
               ->{'_net-ping_object'} = Net::Ping->new($PROTO);
}

sub _update_variables {
    my $tb    = shift;
    my $EMPTY = q{};

    my %methods = (
# BIND currently disabled
#        BIND     => { value => $BIND,    method => 'bind'    },
        PROTO     => { value => $PROTO,   method => $method_ignore },
        PORT      => { value => $PORT,    method => 'port_number'  },
        TIMEOUT   => { value => $TIMEOUT, method => $method_ignore },

        SOURCE_VERIFY     => {
            value  => $SOURCE_VERIFY,
            method => 'source_verify',
        },

        SERVICE_CHECK     => {
            value  => $SERVICE_CHECK,
            method => 'service_check',
        },

        TCP_SERVICE_CHECK => {
            value  => $TCP_SERVICE_CHECK,
            method => 'tcp_service_check',
        },

    );

    foreach my $var ( keys %methods ) {
        # check if var has changed
        my $old_var = $tb->{$HASHPATH}->{$var} || $EMPTY;
        my $new_var = $methods{$var}->{'value'} || $EMPTY;

        if ( $new_var ne $old_var ) {
            print STDERR "testing $var\n";
            print STDERR "PREVIOUS: $old_var, NEW: $new_var\n";
            # var has changed
            my $run_method = $methods{$var}->{'method'};

            # update the object
            if ( $run_method ne $method_ignore ) {
                $OBJPATH->$run_method($new_var);
            }

            # update the variables hash
            $tb->{$HASHPATH}->{$var} = $new_var;
        }
    }

}

sub ping_ok {
    my ( $host, $name ) = @_;
    my $tb = $CLASS->builder;
    my $pinger = $OBJPATH;
    _update_variables($tb);

    my $alive = $pinger->ping( $host, $TIMEOUT );
    $tb->ok( $alive, $name );
}

sub _has_var_ok {
    my ( $var_name, $var_value, $name ) = @_;
    my $tb = $CLASS->builder;
    _update_variables($tb);
    $tb->is_eq( $tb->{$HASHPATH}->{$var_name}, $var_value, $name );
}

END { $OBJPATH->close(); }

1;

__END__

=head1 NAME

Test::Ping - Testing pings using Net::Ping

=head1 VERSION

Version 0.04

=head1 SYNOPSIS

This module helps test pings using Net::Ping

    use Test::More tests => 1;
    use Test::Ping;

    ping_ok( $host, "able to ping $host" );
    ...

=head1 FUNCTIONS

=head2 ping_ok( $host, $test )

Checks if a host replies to ping correctly. Uses Net::Ping.

=head1 EXPORT

ping_ok

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

