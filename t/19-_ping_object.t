#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use_ok( 'Test::Ping');
use_ok( 'Net::Ping');

my $ping = Net::Ping->new;

my $warn;
local $SIG{__WARN__} = sub { $warn = shift; };
$ENV{TEST_PING_REF_OBJ} = 1;

my $ret = Test::Ping->_ping_object($ping);

is (ref $ret, 'Net::Ping', "obj is a Net::Ping");
like ($warn, qr/ref is a Net::Ping/, "reached the if ref is Net::Ping");

$ENV{TEST_PING_REF_OBJ} = 1;

done_testing();

