#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use_ok( 'Test::Ping');

my @modules = qw(
    Test::Ping::Ties::BIND
    Test::Ping::Ties::PORT
    Test::Ping::Ties::PROTO
    Test::Ping::Ties::HIRES
    Test::Ping::Ties::TIMEOUT
    Test::Ping::Ties::SOURCE_VERIFY
    Test::Ping::Ties::SERVICE_CHECK
);

my $ping = Net::Ping->new;

for (@modules) {
    use_ok( $_ );

    my $obj = $_->TIESCALAR;
    isa_ok( $obj, $_, "object " );

    if ($_ =~ /BIND/){
        my $warn;
        local $SIG{__WARN__} = sub { $warn = shift; };
        my $ret = $obj->STORE( 'localhost' );
        is ($ret, 1, "$_ STORE works");
        $obj->FETCH;
        like ($warn, qr/Usage:/, "$_ FETCH works");
    }
    if ($_ =~ /PORT/){
        my $ret = $obj->FETCH;
        is ($ret, 7, "$_ FETCH works");
        $obj->STORE( 8 );
        $ret = $obj->FETCH;
        is ($ret, 8, "$_ STORE works");
    }
     if ($_ =~ /PROTO/){
        my $ret = $obj->FETCH;
        is ($ret, 'tcp', "$_ FETCH works");
        $obj->STORE( 'udp' );
        $ret = $obj->FETCH;
        is ($ret, 'udp', "$_ STORE works");
    }
    if ($_ =~ /HIRES/){
        my $ret = $obj->FETCH;
        is ($ret, 1, "$_ FETCH works");
        $obj->STORE( 3 );
        $ret = $obj->FETCH;
        is ($ret, 3, "$_ STORE works");
    }
    if ($_ =~ /TIMEOUT/){
        my $ret = $obj->FETCH;
        is ($ret, 5, "$_ FETCH works");
        $obj->STORE( 10 );
        $ret = $obj->FETCH;
        is ($ret, 10, "$_ STORE works");
    }
     if ($_ =~ /SOURCE_VERIFY/){
        my $ret = $obj->FETCH;
        is ($ret, 1, "$_ FETCH works");
        $obj->STORE( 0 );
        $ret = $obj->FETCH;
        is ($ret, 0, "$_ STORE works");
    }
      if ($_ =~ /SERVICE_CHECK/){
        my $ret = $obj->FETCH;
        is ($ret, undef, "$_ FETCH works");
        $obj->STORE( 1 );
        $ret = $obj->FETCH;
        is ($ret, 1, "$_ STORE works");
    }
}

done_testing();

