package Test::Ping::Ties::PROTO;

use strict;
use warnings;
use Tie::Scalar;

sub TIESCALAR { return bless {}, shift;     }
sub STORE     { $Test::Ping::PROTO = $_[1]; }
sub FETCH     { return $Test::Ping::PROTO;  }

1;
