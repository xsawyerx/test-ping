#!perl -T

# this is a (little) cleaner version of a Net::Ping test(s)
# original name: 190-alarm.t

# Test to make sure alarm / SIGALM does not interfere
# with Net::Ping.  (This test was derived to ensure
# compatibility with the "spamassassin" utility.)
# Based on code written by radu@netsoft.ro (Radu Greab).

use strict;
use warnings;

use Test::More tests => 2;
use Test::Ping;
use Test::Timer;

use English '-no_match_vars';

SKIP: {
    my $debug_vars = "$OSNAME $EXECUTABLE_NAME $]";
    eval 'require Socket'          || skip 'No Socket',                    6;
    eval { alarm 0; 1; }           || skip "alarm borks on $debug_vars ?", 6;
    getservbyname( 'echo', 'tcp' ) || skip 'No echo port',                 6;

    my $test = sub { Test::Ping->_ping_object()->ping('1.1.1.1') };

    $Test::Ping::PROTO = 'tcp';
    time_between( $test, 4, 6, 'Timeout not enabled' );

    $Test::Ping::TIMEOUT = 2;
    time_atmost( $test, $Test::Ping::TIMEOUT + 1, 'Timeout enabled' );

}

