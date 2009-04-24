#!perl

# checking for a possible bug in Net::Ping

use Test::More tests => 4;
use Net::Ping;

my $p        = Net::Ping->new();
my $host     = '127.0.0.1';
my $alive    = $p->ping($host);
my $key      = 'econnrefused';
my $new_port = 7;

# simple test, showing econnrefused as undefined
diag( "$key: ", $p->{$key} ? $p->{$key} : '(undefined)' );
ok( $alive, "Pinging $host" );

# changing the port to 7, showing econnrefused is now 1
is( $p->port_number, 7, 'Current port number is 7' );
diag("Changing port to $new_port");
$p->port_number(7);
diag( "$key: " . $p->{$key} );
is( $p->port_number, 7, 'New port number is still 7' );

TODO: {
    local $TODO = 'econnrefused makes this fail';

    # simple test now fails
    $alive = $p->ping($host);
    ok( $alive, "Pinging $host" );
}

