#!/bin/perl

print <<'THE_END';
\begin{table}[H]
	\footnotesize
	\begin{tabular}{|lllllll|}
		 \hline
		cve              & grype & owasp & snyk & steady & any & all \\ \hline
THE_END

my @sums = (0, 0, 0, 0, 0, 0);
while (<>) {
	next if $. == 1;
	chomp;
	my ($cve, $lib, @tools) = split /\t/;		# We don't actually use $lib
	my ($steady, $snyk, $owasp, $grype) = @tools;
	@tools = ($grype, $owasp, $snyk, $steady);	# Reorder @tools
	my $any = grep { $_ } @tools ? 1 : 0;
	my $all = !(grep { $_ == 0 } @tools) ? 1 : 0;
	push @tools, $any, $all;
	#print "\t\t", join(" & ", map { $_ == 1 ? '$\checkmark $' : '$\times $' } $cve, $grype, $owasp, $snyk, $steady, $any, $all), " \\\\\n";
	print "\t\t", join(" & ", $cve, map { $_ == 1 ? '$\checkmark $' : '$\times $' } @tools), " \\\\\n";
	for (my $i = 0; $i < @tools; ++$i) {
		$sums[$i] += $tools[$i];
	}
}

print "\t\t\\hline\n";
print "\t\t", join(" & ", "sum", @sums), " \\\\ \\hline\n";

print <<'THE_END';
	\end{tabular}
    \caption{CVEs detected by various SCA tools in the original artifact associated with the CVE (as of \scatimestamp)}
    \label{tab:sca:originals}
\end{table}
THE_END
