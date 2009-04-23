#!perl

# we're checking that all the variables that need to exist do exist

use strict;
use warnings;

use Test::More tests => 1;
use Test::Ping;

my %vars = (
    PROTO             => 'icmp',
    PORT              => 9000,
#    BIND              => 1,  # currently disabled
    TIMEOUT           => 30,
    SOURCE_VERIFY     => 1,
    SERVICE_CHECK     => 1,
    TCP_SERVICE_CHECK => 1,
);

no strict 'refs';
while ( my ( $var_name, $var_value ) = each %vars ) {
    ${"Test::Ping::$var_name"} = $var_value;
    Test::Ping::_has_var_ok( $var_name, $var_value, "Correct $var_name ($var_value)" );
}
