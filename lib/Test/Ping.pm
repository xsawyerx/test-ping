package Test::Ping;

use strict;
use warnings;

use Test::Ping::Ties::BIND;
use Test::Ping::Ties::PORT;
use Test::Ping::Ties::PROTO;
use Test::Ping::Ties::HIRES;
use Test::Ping::Ties::TIMEOUT;
use Test::Ping::Ties::SOURCE_VERIFY;
use Test::Ping::Ties::SERVICE_CHECK;

my  $CLASS         = __PACKAGE__;
my  $OBJPATH       = __PACKAGE__->builder->{'_net-ping_object'};
my  $method_ignore = '__NONE';
our $VERSION       = '0.18';
our @EXPORT        = qw(
    ping_ok
    ping_not_ok
    create_ping_object_ok
    create_ping_object_not_ok
);

# Net::Ping variables
our $PORT;
our $BIND;
our $PROTO;
our $HIRES;
our $TIMEOUT;
our $SOURCE_VERIFY;
our $SERVICE_CHECK;

BEGIN {
    use base 'Test::Builder::Module';
    use Net::Ping;

    __PACKAGE__->builder->{'_net-ping_object'} = Net::Ping->new($PROTO);

    tie $PORT,          'Test::Ping::Ties::PORT';
    tie $BIND,          'Test::Ping::Ties::BIND';
    tie $PROTO,         'Test::Ping::Ties::PROTO';
    tie $HIRES,         'Test::Ping::Ties::HIRES';
    tie $TIMEOUT,       'Test::Ping::Ties::TIMEOUT';
    tie $SOURCE_VERIFY, 'Test::Ping::Ties::SOURCE_VERIFY';
    tie $SERVICE_CHECK, 'Test::Ping::Ties::SERVICE_CHECK';
}

sub ping_ok {
    my ( $host, $name ) = @_;
    my $tb     = $CLASS->builder;
    my $pinger = $OBJPATH;

    my ( $ret, $duration ) = $pinger->ping( $host, $TIMEOUT );
    $tb->ok( $ret, $name );

    return ( $ret, $duration );
}

sub ping_not_ok {
    my ( $host, $name ) = @_;
    my $tb     = $CLASS->builder;
    my $pinger = $OBJPATH;

    my $alive = $pinger->ping( $host, $TIMEOUT );

    #    is (ref $obj, 'adsf', "$_ is in the right class");
    $tb->ok( !$alive, $name );

    return 1;
}

sub create_ping_object_ok {
    my @args = @_;
    my $name = pop @args || q{};
    my $tb   = $CLASS->builder;

    eval { $OBJPATH = Net::Ping->new(@args); };

    if (! $@) {
        $tb->is_eq( ref $OBJPATH, 'Net::Ping', $name );
    }
    else {
        if ($ENV{TEST_PING_CREATE_FAIL}) {
            warn "eval error" if $ENV{TEST_PING_CREATE_FAIL};
        }
        else {
            $tb->ok( 0, $name );
        }
    }
}

sub create_ping_object_not_ok {
    my @args = @_;
    my $name = pop @args || q{};
    my $tb   = $CLASS->builder;
    eval { Net::Ping->new(@args); };

    $tb->ok( $@, $name );
}

sub _has_var_ok {
    my ( $var_name, $var_value, $name ) = @_;
    my $tb = $CLASS->builder;
    $tb->is_eq( $OBJPATH->{$var_name}, $var_value, $name ); ## no critic
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

Version 0.18

=head1 SYNOPSIS

This module helps test pings using Net::Ping

    use Test::More tests => 2;
    use Test::Ping;

    my $good_host = '127.0.0.1';
    my $bad_host  = '1.1.1.1;

    ping_ok(     $good_host, "able to ping $good_host" );
    ping_not_ok( $bad_host,  "can't ping $bad_host"    );
    ...

=head1 DESCRIPTION

Using this module you do not have to work with an object, but can instead use
actual procedural testing functions, which is cleaner and more straight forward
for testing purposes. This module keeps track of the object for you, starting
and closing it and provides a nifty way of testing for pings.

=head1 SUBROUTINES/METHODS

=head2 ping_ok( $host, $test )

Checks if a host replies to ping correctly.

This returns the return value and duration, just like L<Net::Ping>'s C<ping()>
method.

=head2 ping_not_ok( $host, $test )

Does the exact opposite of C<ping_ok()>.

=head2 create_ping_object_ok( @args, $test )

This tries to create a ping object and reports a fail or success. The args that
should be sent are whatever args used with L<Net::Ping>.

=head2 create_ping_object_not_ok( @args, $test )

Tried to create a ping object and attempts to fail. The exactly opposite of the
C<create_ping_object_not_ok()>

=head1 EXPORT

C<ping_ok>

C<ping_not_ok>

C<create_ping_object_ok>

C<create_ping_object_not_ok>

=head1 SUPPORTED VARIABLES

Variables in L<Test::Ping> are tied scalars. Some variables change the values
in the object hash while others run methods. This follows the behavior of
L<Net::Ping>. Below you will find each support variable and what it changes.

=head2 BIND

Runs the C<bind> method.

=head2 PROTO

Changes the C<proto> hash value.

=head2 TIMEOUT

Changes the C<timeout> hash value.

=head2 PORT

Changes the C<port_num> hash value.

=head2 HIRES

Changes the package variable C<$hires>. By default, it is enabled.

=head2 SOURCE_VERIFY

Changes the package variable C<$source_verify>.

=head2 SERVICE_CHECK

Changes the C<econnrefused> hash value.

=head1 INTERNAL METHODS

=head2 _has_var_ok( $var_name, $var_value, $description )

Gets a variable name to test, what to test against and the name of the test.
Runs an actual test using L<Test::Builder>.

This is used to debug the actual module, if you wanna make sure it works.

    use Test::More tests => 1;
    use Test::Ping;

    # Test::Ping calls the protocol variable 'PROTO',
    # but Net::Ping calls it internally (in the hash) 'proto'
    # (this is documented above under PROTO)
    # this is checking against Net::Ping specifically

    $Test::Ping::PROTO = 'icmp';
    Test::Ping::_has_var_ok(
        'proto',
        'icmp',
        'Net::Ping has correct protocol variable',
    );

=head2 _ping_object

When debugging behavior, fetching an internal object from a procedural module
can be a bit difficult (especially when it has base inheritance with another
one).

This method allows you (or me) to fetch the actual L<Net::Ping> object from
C<Test::Ping>. It eases testing and assurance.

This is used by the Tie functions to set the variables for the object for you.

    use Test::Ping;
    use Data::Dumper;

    print 'Object internals: ' . Dumper( Test::Ping->_ping_object() );

Or you could also change the Net::Ping object to one of your own:

    use Test::Ping;
    use Net::Ping;

    Test::Ping->_ping_object( Net::Ping->new(@opts) );

And doing it with tests:

    use Test::More tests => 2;
    use Test::Ping;

    create_ping_object_ok( 'tcp', 2, 'Creating our own Net::Ping object' );
    ping_ok( $target, "Yay! We can reach $target" );

However, you should be warned. I test for a L<Net::Ping> object so trying to
pass other objects will fail. If anyone needs this changed or any reason,
contact me and I'll consider it.

=head1 DEPENDENCIES

This module uses L<Net::Ping>, L<Tie::Scalar> and L<Carp>.

L<Test::Timer> is used in the test suite.

=head1 AUTHOR

Sawyer X, C<< <xsawyerx at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-test-ping at rt.cpan.org>,
or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test-Ping>.

There is also a GitHub issue tracker at
L<http://github.com/xsawyerx/test-ping/issues> which I'll probably check just as
much.

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

Thanks to everyone who works and contributed to C<Net::Ping>. This module
depends solely on it.

=head1 COPYRIGHT & LICENSE

Copyright 2009-2010 Sawyer X, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the terms of either:

=over 4

=item * the GNU General Public License as published by the Free
Software Foundation; either version 2, or (at your option) any
later version, or

=item * the Artistic License version 2.0.

=back

