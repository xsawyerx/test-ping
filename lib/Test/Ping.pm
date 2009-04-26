package Test::Ping;
use Test::Ping::Ties::PROTO;
use Test::Ping::Ties::TIMEOUT;

use strict;
use warnings;

my  $CLASS         = __PACKAGE__;
my  $OBJPATH       = __PACKAGE__->builder->{'_net-ping_object'};
my  $method_ignore = '__NONE';
our @EXPORT        = qw( ping_ok );
our $VERSION       = '0.05';

# Net::Ping variables
our $PROTO;
our $PORT;
our $BIND;
our $TIMEOUT;
our $SOURCE_VERIFY;
our $SERVICE_CHECK;
our $TCP_SERVICE_CHECK;

BEGIN {
    use base 'Test::Builder::Module';
    use Net::Ping;

    __PACKAGE__->builder
               ->{'_net-ping_object'} = Net::Ping->new($PROTO);

    tie $PROTO, 'Test::Ping::Ties::PROTO';
}

sub ping_ok {
    my ( $host, $name ) = @_;
    my $tb     = $CLASS->builder;
    my $pinger = $OBJPATH;

    my $alive = $pinger->ping( $host, $TIMEOUT );
    $tb->ok( $alive, $name );

    return 1;
}

sub _has_var_ok {
    my ( $var_name, $var_value, $name ) = @_;
    my $tb = $CLASS->builder;
    $tb->is_eq( $OBJPATH->{$var_name}, $var_value, $name );
    return 1;
}

sub _ping_object {
    my $obj = $_[1] || $_[0] || q{};

    if ( ref $obj eq 'Net::Ping' ) {
        $OBJPATH = $obj;
    }

    return $OBJPATH;
}

END { $OBJPATH->close(); }

1;

__END__

=head1 NAME

Test::Ping - Testing pings using Net::Ping

=head1 VERSION

Version 0.05

=head1 SYNOPSIS

This module helps test pings using Net::Ping

    use Test::More tests => 1;
    use Test::Ping;

    ping_ok( $host, "able to ping $host" );
    ...

=head1 SUBROUTINES/METHODS

=head2 ping_ok( $host, $test )

Checks if a host replies to ping correctly.

=head1 EXPORT

ping_ok

=head1 SUPPORTED VARIABLES

Only variables which have tests would be noted as supported. Tests is actually what I'm working on right now.

=head2 PROTO

Important to note: setting this will reset the object and everything it's using back to defaults. Why? Because that's how it works, and I don't intend to bypass it - if at all - until a much later stage.

=head1 INTEND-TO-SUPPORT VARIABLES

These are variables I intend to support, so stay tuned or just send a patch.

=head2 TIMEOUT

=head2 SOURCE_VERIFY

=head2 SERVICE_CHECK

=head2 TCP_SERVICE_CHECK

=head1 DISABLED TILL FURTHER NOTICE VARIABLES

=head2 PORT

=head2 BIND

=head1 INTERNAL METHODS

=head2 _has_var_ok( $var_name, $var_value, $description )

Gets a variable name to test, what to test against and the name of the test. Runs an actual test using Test::Builder.

This is used to debug the actual module, if you wanna make sure it works.

    use Test::More tests => 1;
    use Test::Ping;

    $Test::Ping::PROTO = 'icmp';
    _has_var_ok( 'PROTO', 'icmp', 'has correct protocol' )

At a later stage, hopefull as soon as possible, this will actually run this:

    is( Test::Ping->_ping_object()->{'proto'}, 'icmp', 'has correct protocol' )

However, you'll still be able to use the first syntax.

For _ping_object() method, keep reading.

=head2 _ping_object

When debugging behavior, fetching an internal object from a producedural module can be a bit difficult (especially when it has base inheritence with another one).

This method allows you (or me) to fetch the actual Net::Ping object from Test::Ping. It eases testing and assurance.

This is used by the Tie functions to set the variables for the object for you.

=head1 AUTHOR

Sawyer X, C<< <xsawyerx at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-test-ping at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test-Ping>.

There is also a GitHub issue tracker at L<http://github.com/xsawyerx/test-ping/issues> which I'll probably check just as much.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Test::Ping

If you have Git, this is the clone path:

git@github.com:xsawyerx/test-ping.git

You can also look for information at:

=over 4

=item * GitHub Website:

L<http://github.com/xsawyerx/test-ping/tree/master>

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

Thanks to everyone who works and contributed to Net::Ping. This module depends solely on it.

=head1 COPYRIGHT & LICENSE

Copyright 2009 Sawyer X, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

