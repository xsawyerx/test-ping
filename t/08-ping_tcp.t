#!perl -T

# this is a (little) cleaner version of a Net::Ping test(s)
# original name: 200_ping_tcp.t

use strict;
use warnings;

use Test::More tests => 10;
use Test::Ping;

SKIP: {
    if ( $ENV{'PERL_CORE'} ) {
        if ( ! $ENV{'PERL_TEST_Net_Ping'} ) {
            skip 'Network dependent test', 10;
        }

        chdir 't' if -d 't';
        @INC = qw(../lib);
    }

    eval 'require Socket'          || skip 'No Socket',    10;
    getservbyname( 'echo', 'tcp' ) || skip 'No echo port', 10;

    # Remote network test using tcp protocol.
    #
    # NOTE:
    #   Network connectivity will be required for all tests to pass.
    #   Firewalls may also cause some tests to fail, so test it
    #   on a clear network.  If you know you do not have a direct
    #   connection to remote networks, but you still want the tests
    #   to pass, use the following:
    #
    # $ PERL_CORE=1 make test

    $Test::Ping::PROTO   = 'tcp';
    $Test::Ping::TIMEOUT = 9;

    ping_ok( 'localhost', 'Test on the default port' );

    # Change to use the more common web port.
    # This will pull from /etc/services on UNIX.
    # (Make sure getservbyname works in scalar context.)
    $Test::Ping::PORT = ( getservbyname( 'http', 'tcp' ) || 80 );

    ping_ok( 'localhost', 'Test localhost on the web port' );

    ping_not_ok( '172.29.249.249', 'Hopefully this is never a routeable host' );

    # Test a few remote servers
    # Hopefully they are up when the tests are run.

    ping_ok( 'www.geocities.com',   'www.geocities.com'   );
    ping_ok( 'ftp.geocities.com',   'ftp.geocities.com'   );
    ping_ok( 'www.freeservers.com', 'www.freeservers.com' );
    ping_ok( 'ftp.freeservers.com', 'ftp.freeservers.com' );
    ping_ok( 'yahoo.com',           'yahoo.com'           );
    ping_ok( 'www.yahoo.com',       'www.yahoo.com'       );
    ping_ok( 'www.about.com',       'www.about.com'       );
}

