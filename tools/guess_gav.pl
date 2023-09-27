#!/usr/bin/perl

my ($g, $a, $v);

while (<>) {
	if ((/<dependency>/ .. m|</dependency>|) && !defined($v)) {
		m|<groupId>(.*?)</groupId>| and $g = $1;
		m|<artifactId>(.*?)</artifactId>| and $a = $1;
		m|<version>(.*?)</version>| and $v = $1;
	}
}

print "$g:$a:$v\n";
