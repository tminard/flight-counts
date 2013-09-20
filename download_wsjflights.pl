#!/usr/bin/env perl

use strict;
use warnings;
use Cwd qw (abs_path);
use Path::Class qw( file );
use Mojo::DOM;
use Mojo::Collection;
use File::Fetch;
use File::Copy qw(move);
use JSON::XS;
use Try::Tiny;
use Data::Dumper;
use WWW::Curl::Easy;

my $source_args = $#ARGV + 1;

if ($source_args < 1 ) {
    die "You gotta put a filename and maybe that file must only exist inside this directory?.\n";
}

main($ARGV[0]);

sub main {
    print "Loading initial file...\n";
   
    initOutputFile();

    my $file = $_[0];
    open (FLIGHTNUMBERHNDL, $file) or die "Couldn't Open $file: $!\n";
    print "Loaded file. Reading flight numbers...\n";
    while ( <FLIGHTNUMBERHNDL> ) {
        chomp;
        my $flight_num = $_;
        print "\tGot flight number: $flight_num\n. Fetching flight count from online...\n";
        my $source_url = "http://projects.wsj.com/jettracker/flights.php?op=&tag=$flight_num&dc=&ac=&dds=&dde=&ads=&ade=&any_city=&p=0&sort=d";
        my $numberOfFlightsFound = downloadAndGetFlightCount($source_url);
        print "\tFlight count: $numberOfFlightsFound\n";
    }

    close (FLIGHTNUMBERHNDL);

    closeOutputFile();
    cleanUp();
    print "Done. Phil, you owe me one.\n";
}

sub initOutputFile {
    # delete old output file. Create new one. Add initial CSV header (Tail Number, Number of Flights)
}

sub closeOutputFile {
    # close file handle 
}

sub cleanUp {
    print "Cleaning up...";
    unlink "temp.txt";
}

sub downloadAndGetFlightCount {
    my $file = $_[0];
    # print "Downloading $file...\n";
    my $decoded = "";
    try {
        my $curl = WWW::Curl::Easy->new;
        $curl->setopt(CURLOPT_HEADER, 0);
        $curl->setopt(CURLOPT_URL, $file);

        my $response_body;
        $curl->setopt(CURLOPT_WRITEDATA,\$response_body);

        my $retcode = $curl->perform;
        my $response_code = $curl->getinfo(CURLINFO_HTTP_CODE);

        if ($response_code == '403') {
            die "BAD-FLIGHT";
        }

        $decoded = JSON::XS::decode_json($response_body);

        unlink -e "temp.txt";
        return $decoded->{meta}{totalcount};
    } catch {
        print "\t\tTail is invalid ($_)! But moving on...\n";
        return "Flight information invalid or not found";
    }
}

sub processDownloadedFile {
}
