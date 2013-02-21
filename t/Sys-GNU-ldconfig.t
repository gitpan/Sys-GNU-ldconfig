#!/usr/bin/perl

use Test::More tests => 9;
BEGIN { 
    use_ok('Sys::GNU::ldconfig') 
};

use Config;
use Cwd;
use File::Spec;
my $cwd = cwd;

my $so = $Config{dlext};

#### functional interface
ld_root( File::Spec->catdir( $cwd, 't' ) );
my $file = ld_lookup( "db" );
is( $file, File::Spec->catfile( '', "lib", "libdb.$so.4" ), "found db" );

#### OO interface
my $ld = Sys::GNU::ldconfig->new;
isa_ok( $ld, 'Sys::GNU::ldconfig' );
$ld->root( File::Spec->catdir( $cwd, 't' ) );

$file = $ld->lookup( "db" );
is( $file, File::Spec->catfile( '', "lib", "libdb.$so.4" ), "found db via OO" );

$file = $ld->lookup( "libdb" );
is( $file, File::Spec->catfile( '', "lib", "libdb.$so.4" ), "found db via OO" );

$file = $ld->lookup( "db.$so.3" );
is( $file, File::Spec->catfile( '', "old-lib", "libdb.$so.3" ), "found older db via OO" );

$file = $ld->lookup( "something" );
is( $file, File::Spec->catfile( '', qw( opt something-1.23 lib ), "libsomething.$so" ), 
                                    "found something in opt" );

$file = $ld->lookup( "other" );
is( $file, File::Spec->catfile( '', qw( opt lib ), "libother.$so.13" ),
                                    "found something in opt" );

$file = $ld->lookup( "libother.$so" );
is( $file, File::Spec->catfile( '', qw( opt lib ), "libother.$so.13" ),
                                    "found something in opt" );

