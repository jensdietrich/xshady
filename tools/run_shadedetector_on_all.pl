#!/usr/bin/perl

use strict;
use warnings;

my $n = 100;

my $localScratchCacheDir = '/local/scratch/whitewa/shadedetector/.cache';
my $cacheDir = (-d $localScratchCacheDir ? $localScratchCacheDir : "$ENV{HOME}/code/shadedetector/.cache");
my $jarPath = "../target/shadedetector.jar";
my $xshadyPath = "$ENV{HOME}/code/xshady";
my $sumStatsCmd = "../tools/sum_stats.pl stats*.log > summed_stats.log";

my $mode = "make";

if (@ARGV && $ARGV[0] eq '--mode') {
	$mode = $ARGV[1];
}

die "Unknown mode" if $mode !~ /^(?:make|shell-script)$/;
print STDERR "Generating run script in $mode mode.\n";

print "# Generated at " . localtime . " by $0\n";

my @targets;
my @rules;

if ($mode eq 'shell-script') {
	print "echo '#'`date` >> started\necho EXTRA_FLAGS=\"\${EXTRA_FLAGS}\" >> started\n";
}

foreach my $d (<CVE-*>) {
	my $statsFName = "stats$n-$d.log";
	my $pomFName = `realpath $d/pom.xml`;
	chomp $pomFName;

	# -g, -a, -v, -sig and any JAVA_HOME=... setting are now all determined from pov-project.json
	my $cmd = "/usr/bin/time java -jar $jarPath -vul $xshadyPath/$d -l log$n-$d.log -vov vuln_final --stats $statsFName -o1 csv.details?dir=details$n-$d -o2 csv.summary?file=summary$n-$d.csv -cache $cacheDir \${EXTRA_FLAGS}";

	if ($mode eq 'make') {
		push @targets, $statsFName;
		push @rules, "$statsFName: $pomFName started\n\t$cmd\n\n";

	} else {
		print "$cmd\n";
	}

	++$n;
}

if ($mode eq 'make') {
	print ".PHONY: all started finished\n\n";
	unshift @targets, "started";
	unshift @rules, "started:\n\techo '#'`date` >> \$\@\n\techo EXTRA_FLAGS=\"\${EXTRA_FLAGS}\" >> \$\@\n\n";
	push @rules, "finished: " . join(" ", @targets) . "\n\tdate >> \$\@\n\t$sumStatsCmd\n\n";
	push @targets, "finished";

	print join(" \\\n\t", "all:", @targets), "\n\n";
	print @rules;
} else {
	print "date >> finished\n$sumStatsCmd\n";
}
