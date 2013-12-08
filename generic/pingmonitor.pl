#!/usr/bin/perl

use strict;
use warnings;

use Net::Ping;

my $dobeep = shift;
if (! defined ($dobeep)) {
	$dobeep = 0;
}

my $pingtarget = 'www.google.com';
my $seconds_threshold = 300;

if ($> == 0) {
	my $p = Net::Ping->new('icmp', 1);

	unless (defined $p) { die "can't create Net::Ping object $!";}

	print "pingmonitor starting...\n";

	while (1) {

		my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);

		printf "%4d-%02d-%02d %02d:%02d:%02d",$year+1900,$mon+1,$mday,$hour,$min,$sec;
		flush STDOUT;

		if ($p->ping($pingtarget)) {
			print "\r" ;
		}
		else { # target can't be pinged
			print " - ";
			my $seconds = 0;

			while (1) { # loop until target can be pinged again
				flush STDOUT;
				sleep 1;
				$seconds++;
				if (($hour > 8) && ($hour < 23)) {
					system("beep -f	400 -l 250 -n -f 300 -l 800") if (($seconds == 5) && ($dobeep));
				}
				my ($osec,$omin,$ohour,$omday,$omon,$oyear,$owday,$oyday,$oisdst) = ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst);
				if ($p->ping($pingtarget)) {
					($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
					printf "%4d-%02d-%02d %02d:%02d:%02d",$year+1900,$mon+1,$mday,$hour,$min,$sec;
					if ($hour < $ohour) {
						$hour += 24;
					}
					$seconds = - 3600 * $ohour - 60 * $omin - $osec + 3600 * $hour + 60 * $min + $sec;
					if ($seconds >= $seconds_threshold) {
						print " ($seconds sec)\n";
					}
					else {
						print " ($seconds sec)\r                     :\r";
					}
					if (($hour > 7) && ($hour < 23)) {
						system("beep -r 2 -d 50 -f 1900") if (($seconds > 5) && ($dobeep));
					}
					last;
				}
				else {
					if ($seconds >= $seconds_threshold) {
                                                print " ($seconds sec) - excessive offline time, rebooting...\n";
                                                system("/sbin/reboot");
                                        }
				}

			} # while (inner)
		}

		flush STDOUT;
		sleep 1;

	} # while (outer)

}
else {

	print "Need to be root!\n";
	exit 1;
}
