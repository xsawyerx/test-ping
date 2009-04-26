#!perl -T

# this is a (little) cleaner version of the icmp tests in Net::Ping
# original name: 120_udp_inst.t, 130_tcp_inst.t

use strict;
use warnings;

use Test::More tests => 4;
use Test::Ping;

sub test_proto {
    my $proto = shift;
    $Test::Ping::PROTO = $proto;
    Test::Ping::_has_var_ok( 'proto', $proto, "Can be initialized for $proto" );
}

SKIP: {
    eval 'require Socket'          || skip 'No Socket',    2;
    getservbyname( 'echo', 'udp' ) || skip 'No echo port', 2;

    test_proto('udp');
    test_proto('tcp');
}

SKIP: {
    eval 'require Socket'          || skip 'No Socket',    2;
    getservbyname( 'echo', 'tcp' ) || skip 'No echo port', 2;

    test_proto('stream');
    test_proto('syn');
}
