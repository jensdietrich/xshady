#!/usr/bin/perl

use strict;
use warnings;

my $n = 100;

my $localScratchCacheDir = '/local/scratch/whitewa/shadedetector/.cache';
my $cacheDir = (-d $localScratchCacheDir ? $localScratchCacheDir : '.');

foreach my $d (<CVE-*>) {
	my $gav = `tools/guess_gav.pl < $d/pom.xml`;
	chomp $gav;
	my $exitStatus = `cat $d/mvn_clean_test.exitstatus`;
	chomp $exitStatus;
	my $sig = ($exitStatus eq '0' ? 'success' : 'failure');

	#print "$d: $gav\n";
	my ($g, $a, $v) = split /:/, $gav;

	# For now just assume exit status 1 means failures, not errors (it's actually the case for now).
	my $cmd = "/usr/bin/time java -jar target/shadedetector.jar -g $g -a $a -v $v -vul ../xshady/$d -sig $sig -l log$n-$d.log -vos $ENV{HOME}/code/shadedetector/vuln_staging -vov $ENV{HOME}/code/shadedetector/vuln_final --stats stats$n-$d.log -o1 csv.details?dir=results/details$n-$d -o2 csv.summary?file=results/summary$n-$d.csv -cache $cacheDir";

	print "$cmd\n";

	++$n;
}
