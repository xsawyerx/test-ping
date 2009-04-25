package Test::Ping::Ties::PROTO;

use strict;
use warnings;

use Net::Ping;
use Tie::Scalar;

sub TIESCALAR { return bless {}, shift;     }
sub FETCH     { return $Test::Ping::PROTO;  }

sub STORE {
    Test::Ping->_get_object() = Net::Ping->new($_[1]);
}

1;
