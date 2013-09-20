#!/usr/bin/env perl

use strict;
use warnings;
use Cwd qw (abs_path);
use Path::Class qw( file );
use Mojo::DOM;
use Mojo::Collection;
use File::Fetch;
use File::Copy qw(move);

my $source_args = $#ARGV + 1;

if ($source_args < 1 ) {
    die "You gotta put a filename and maybe that file must only exist inside this directory?.\n";
}

main($ARGV[0]);

sub main {
    print "Will it work?!\n";
    print file(abs_path($ARGV[0]))->dir;
   
    my $file = $ARGV[0];
    open my $info, '>>$file' or die "Couldn't Open $file: $!";
    print $info;

    # while the file is still open, read through each line and print.
    while ( $info ) {
        print $_;
        last if eof;
    }

    cleanUp();
    print "Done.\n";
}

sub cleanUp {
    print "Cleaning up...";
    unlink "temp.txt";
}
sub downloadFile {
    # my $file = $_[0];
    # print "Downloading $file...\n";
    # my $ff = File::Fetch->new(uri => $file);

    # my $where = $ff->fetch() or die $ff->error;

    # unlink -e "temp.txt";
    # move $ff->output_file, "temp.txt" or die "Could not move file...\n";
}

sub extractPageCount {
    open FILE, "temp.txt" or die $!;
    my $html = do { local $/; <FILE>};
    close (FILE);

    my $dom = Mojo::DOM->new($html);
    my $page_count = $dom->at("div#pagination_readout")->text;

    $page_count =~ s/^\w/$1/;
    $page_count;
}

sub processDownloadedFile {
}
