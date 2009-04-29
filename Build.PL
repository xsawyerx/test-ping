use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Test::Ping',
    license             => 'perl',
    dist_author         => 'Sawyer X <xsawyerx@cpan.org>',
    dist_version_from   => 'lib/Test/Ping.pm',
    build_requires => {
        'Test::More'  => 0,
        'Test::Timer' => 0.05,
    },
    requires => {
        'Carp'          => 0,
        'Net::Ping'     => 2.33,
        'Tie::Scalar'   => 0,
        'Test::Builder' => 0.86,
    },
    add_to_cleanup      => [ 'Test-Ping-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
