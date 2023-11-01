#!/usr/bin/perl

use strict;
use warnings;

my %out;

while (<STDIN>) {
    $_ =~ m/^(.*)\{.*\} (.*)$/;
    my ( $key, $value ) = ( $1, $2 );
    $out{$key} += $value;
}

foreach my $key ( keys %out ) {
   print "$key";
   print ": ".$out{$key};
   print "\n";
}
