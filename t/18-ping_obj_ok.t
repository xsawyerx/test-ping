#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use_ok( 'Test::Ping');

create_ping_object_ok('tcp', "create ok");

{
    my $warn;
    local $SIG{__WARN__} = sub { $warn = shift; };
    $ENV{TEST_PING_CREATE_FAIL} = 1;

    create_ping_object_ok('cp', "create ok");
    $ENV{TEST_PING_CREATE_FAIL} = 0;

    like ( $warn, qr/eval error/, "create fails properly");
}
done_testing();

