#!/usr/bin/perl

# Create MPD playlists for all MP3 files in a given directory

# Before running this script, execute:
# cd /nas/MP3
# find . -type d > /tmp/nas-mp3-directories.txt

# After running this script, execute:
# cd $playlistpath
# find . -empty -iname '*m3u' -exec rm '{}' ';'

use strict;
use warnings;

my $dirlist = '/tmp/nas-mp3-directories.txt';
my $playlistpath = '/var/lib/mpd/playlists/';
my $mp3naspath = '/nas/MP3/';

open(F, "<$dirlist") or die "$dirlist not found\n";
while (my $pathname = <F>) {
    next if (length($pathname) < 4);
    if ($pathname =~ m/^\.\/(.*)/) { $pathname = $1;}
    my $orig_pathname = $pathname;

    $pathname =~ s/\//_/g;
    $pathname =~ s/&/_and_/g;
    $pathname =~ s/[;() '!\[\],\n]//g;

    my $m3uname = $playlistpath . $pathname . ".m3u";
    print "Creating $m3uname \n         for MP3 files from $orig_pathname\n";
    my $cmd = "find \"$mp3naspath$orig_pathname\" -iname '*.mp3' | sort > $m3uname";
    system($cmd);
}
close(F);

exit 0;

