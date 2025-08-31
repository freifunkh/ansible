#!/usr/bin/perl -w

use strict;
use warnings;
# use Data::Dumper;

my $birdc = "/usr/sbin/birdc";
my $peer2check;
my $output = "";
my $state  = "";
my $since  = "";
my $reason = "";

$peer2check = $ARGV[0];

if ( defined($peer2check) ) {

    # see the details for the peer provider
    my @peer = qx/$birdc show protocols all $peer2check/;

    # print Dumper \@peer;

    # remove headers from command line
    #shift @peer for 1..2;
    if ( defined( $peer[2] ) ) {

        #print "DEBUG in the peer if : $peer[2]\n";
        # json		$output = "{ \"proto\": \"$peer2check\", ";
        my $peerfile = "/tmp/$peer2check";
        open( my $fh, '>', $peerfile )
          or die "Cannot open $peerfile for writing!\n";

        # NOS_ipv4   BGP        ---        up     2020-09-22    Established
        # PCH1_2001_7f8_a_1__55 BGP        ---        down   11:21:54.010
        if ( $peer[2] =~
            m/^[\w\d\_\-]+\s+BGP\s+---\s+(\w+)\s+([\d+\-\:]+\ [\d+\-\:]+)(.*)/ )
        {
            $state = $1;
            $since = $2;
            if ( $3 ne "  " ) {
                $reason = $3;
            }
            else {
                $reason = "down";
            }

            if ( $state eq "up" ) {
                my $string = join( ',', @peer );

                #print "STRING: $string\n";
                # ie.: Routes:         991394 imported, 0 filtered, 1 exported, 481234 preferred
                $string =~
m/Routes:\s+(\d+) imported,\s+(\d+) filtered,\s+(\d+) exported,\s+(\d+) preferred/;

                # check if i've more than one route...
                #if ($1 >= 1) {
                #print "DEBUG in the routes if : ROUTES: $1\n";
                # json				$output .= "\"state\": \"$state\", \"since\": \"$since\", \"routes\": \"$1\", \"exported\": \"$2\", \"preferred\": \"$3\", \"reason\": \"$reason\"";
                print $fh
"\"routes\": \"$1\", \"filtered\": \"$2\", \"exported\": \"$3\", \"preferred\": \"$4\"";

                #} else {
                #print "WARNING, To few routes for this provider: $1\n";
                #}
            }
            else {
                # json				$output .= "\"state\": \"$state\", \"since\": \"$since\", \"routes\": \"0\", \"filtered\": \"0\", \"exported\": \"0\", \"preferred\": \"0\", \"reason\": \"$reason\"";
                print $fh
"\"routes\": \"0\", \"filtered\": \"0\", \"exported\": \"0\", \"preferred\": \"0\"";
            }

            # json			print "$output}, ";
        }
        else {
            print
"CRITICAL, Peer protocol session name state doesn't match: $peer[2]\n";
        }
        close $fh;
    }
    else {
        print
          "CRITICAL, Peer protocol session name doesn't exists: $peer2check\n";
    }
}
else {
    print "CRITICAL, Peer name empty\n";
}
