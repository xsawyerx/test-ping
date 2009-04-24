#!perl -T

# this is a (little) cleaner version of the icmp tests in Net::Ping

use strict;
use warnings;

use Test::More tests => 1;
use Test::Ping;

use English '-no_match_vars';

sub IsAdminUser {
  return unless $OSNAME eq 'MSWin32';
  return unless eval { require Win32 };
  return unless defined &Win32::IsAdminUser;
  return Win32::IsAdminUser();
}

sub tests_write {
    return `write sys\$output f\$privilege("SYSPRV")` =~ m/FALSE/;
}

SKIP: {
    if (
        ( $EUID and $OSNAME ne 'VMS'     and $OSNAME ne 'cygwin' ) or
        (           $OSNAME eq 'MSWin32' and ! is_admin_user()   ) or
        (           $OSNAME eq 'VMS'     and   test_write()      ) ) {
        skip 'icmp ping requires root privileges.', 1;
    } elsif ( $OSNAME eq 'MacOS' ) {
        skip 'icmp protocol not supported', 1;
    } else {
        $Test::Ping::PROTO = 'icmp';
        my $target         = '127.0.0.1';
        ping_ok( $target, "ICMP on $target" );
    }
}

