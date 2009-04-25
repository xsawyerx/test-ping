#!perl -T

# this is a (little) cleaner version of the icmp tests in Net::Ping
# original name: 120_udp_inst.t, 130_tcp_inst.t

use strict;
use warnings;

use Test::More tests => 2;
use Test::Ping;

SKIP: {
    eval 'require Socket'          || skip 'No Socket',    1;
    getservbyname( 'echo', 'udp' ) || skip 'No echo port', 1;

    my $proto = 'udp';
    $Test::Ping::PROTO = $proto;
    Test::Ping::_has_var_ok( 'PROTO', $proto, "Can be initialized for $proto" );

    $proto = 'tcp';
    $Test::Ping::PROTO = $proto;
    Test::Ping::_has_var_ok( 'PROTO', $proto, "Can be initialized for $proto" );
}

