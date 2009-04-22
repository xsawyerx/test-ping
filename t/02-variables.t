#!perl

# we're checking that all the variables that need to exist do exist

use strict;
use warnings;

use Test::More tests => 1;
use Test::Ping;

my %vars = (
    PROTO => 'icmp',
);

no strict 'refs';
while ( my ( $var_name, $var_value ) = each %vars ) {
    ${"Test::Ping::$var_name"} = $var_value;
    Test::Ping::_has_var_ok( $var_name, $var_value, "Correct $var_name ($var_value)" );
}
