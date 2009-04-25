package Test::Ping::Ties::PROTO;

use strict;
use warnings;

use Net::Ping;
use Tie::Scalar;

our $VERSION = '0.02';

sub TIESCALAR { return bless {}, shift;                              }
sub FETCH     { return $Test::Ping::PROTO;                           }
sub STORE     { Test::Ping->_ping_object( Net::Ping->new( $_[1] ) ); }

1;

__END__

