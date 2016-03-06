#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use_ok( 'Test::Ping');

my @subclasses = qw(
    BIND
    PORT
    PROTO
    HIRES
    TIMEOUT
    SOURCE_VERIFY
    SERVICE_CHECK
);

my $ping = Net::Ping->new;

for my $subclass (@subclasses) {
    my $module_name = "Test::Ping::Ties::$subclass";
    use_ok( $module_name );

    my $obj = $module_name->TIESCALAR;
    isa_ok( $obj, $module_name, 'TIESCALAR object' );

    if ($subclass eq 'BIND'){
        my $warn;
        local $SIG{__WARN__} = sub { $warn = shift; };
        my $ret = $obj->STORE( 'localhost' );
        is ($ret, 1, "$module_name STORE works");
        $obj->FETCH;
        like ($warn, qr/Usage:/, "$module_name FETCH works");
    }
    if ($subclass eq 'PORT'){
        my $ret = $obj->FETCH;
        is ($ret, 7, "$module_name FETCH works");
        $obj->STORE( 8 );
        $ret = $obj->FETCH;
        is ($ret, 8, "$module_name STORE works");
    }
    if ($subclass eq 'PROTO'){
        my $ret = $obj->FETCH;
        is ($ret, 'tcp', "$module_name FETCH works");
        $obj->STORE( 'udp' );
        $ret = $obj->FETCH;
        is ($ret, 'udp', "$module_name STORE works");
    }
    if ($subclass eq 'HIRES'){
        my $ret = $obj->FETCH;
        is ($ret, 1, "$module_name FETCH works");
        $obj->STORE( 3 );
        $ret = $obj->FETCH;
        is ($ret, 3, "$module_name STORE works");
    }
    if ($subclass eq 'TIMEOUT'){
        my $ret = $obj->FETCH;
        is ($ret, 5, "$module_name FETCH works");
        $obj->STORE( 10 );
        $ret = $obj->FETCH;
        is ($ret, 10, "$module_name STORE works");
    }
    if ($subclass eq 'SOURCE_VERIFY'){
        my $ret = $obj->FETCH;
        is ($ret, 1, "$module_name FETCH works");
        $obj->STORE( 0 );
        $ret = $obj->FETCH;
        is ($ret, 0, "$module_name STORE works");
    }
    if ($subclass eq 'SERVICE_CHECK'){
        my $ret = $obj->FETCH;
        is ($ret, undef, "$module_name FETCH works");
        $obj->STORE( 1 );
        $ret = $obj->FETCH;
        is ($ret, 1, "$module_name STORE works");
    }
}

done_testing();

