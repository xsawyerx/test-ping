package Test::Ping::Ties::PORT;
# ABSTRACT: Port Tie variable to Test::Ping

use strict;
use warnings;

use Net::Ping;
use Test::Ping;
use Tie::Scalar;

sub TIESCALAR { return bless {}, shift;                           }
sub FETCH     { return Test::Ping->_ping_object()->{'port_num'};  }
sub STORE     { Test::Ping->_ping_object()->{'port_num'} = $_[1]; }

1;

__END__

=head1 DESCRIPTION

In order to allow complete procedural interface to Net::Ping, even though it's
an object, I use a Tie::Scalar interface. Every variable is also defined
separately to make it cleaner and easier.

At some point they might be joined together in a single file, but I doubt it.

Please refrain from using this directly.

=head1 EXPORT

None.
