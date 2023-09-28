#!/usr/bin/perl

use strict;
use warnings;

my $n = 100;

my $localScratchCacheDir = '/local/scratch/whitewa/shadedetector/.cache';
my $cacheDir = (-d $localScratchCacheDir ? $localScratchCacheDir : "$ENV{HOME}/code/shadedetector/.cache");
my $jarPath = "../target/shadedetector.jar";
my $xshadyPath = "$ENV{HOME}/code/xshady";

foreach my $d (<CVE-*>) {
	# -g, -a, -v, -sig and any JAVA_HOME=... setting are now all determined from pov-project.json
	my $cmd = "/usr/bin/time java -jar $jarPath -vul $xshadyPath/$d -l log$n-$d.log -vov vuln_final --stats stats$n-$d.log -o1 csv.details?dir=details$n-$d -o2 csv.summary?file=summary$n-$d.csv -cache $cacheDir";

	print "$cmd\n";

	++$n;
}
