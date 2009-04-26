#!perl -T

# this is a (little) cleaner version of a Net::Ping test(s)
# original name: 190-alarm.t

# Test to make sure alarm / SIGALM does not interfere
# with Net::Ping.  (This test was derived to ensure
# compatibility with the "spamassassin" utility.)
# Based on code written by radu@netsoft.ro (Radu Greab).

use strict;
use warnings;

use Test::More tests => 5;
use Test::Ping;

use English '-no_match_vars';

SKIP: {
    my $debug_vars = "$OSNAME $EXECUTABLE_NAME $]";
    eval 'require Socket'          || skip 'No Socket',                    6;
    eval { alarm 0; 1; }           || skip "alarm borks on $debug_vars ?", 6;
    getservbyname( 'echo', 'tcp' ) || skip 'No echo port',                 6;

    eval {
        my $timeout = 11;
        ok( 1, 'In eval' ); # In eval

        local $SIG{ALRM} = sub { die "alarm works" };
        ok( 1, 'SIGALRM can be set on this platform' );

        alarm $timeout;
        ok( 1, 'alarm can be set on this platform' );

        my $start = time;
        while (1) {
            # It does not matter if alive or not

            $Test::Ping::PROTO   = 'tcp';
            $Test::Ping::TIMEOUT = 2;

            Test::Ping->_ping_object()->ping('127.0.0.1');
            Test::Ping->_ping_object()->ping('172.29.249.249');

            if ( time > $start + $timeout + 1 ) {
                die 'alarm failed';
            }
        }
    };
}

ok( 1, 'Got out of infinite loop okay' );

like( $@, qr/alarm works/, 'Good excuse for dying' );

alarm 0; # Reset alarm
