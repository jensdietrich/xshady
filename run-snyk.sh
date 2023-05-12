#!/bin/sh

# run snyk sca on all folders
root=$(pwd)
snyk_report=scan-results/snyk/snyk-report.json;
for d in CVE-*/ ; do
  echo "traversing ${d}";
  cd $d;
  if [ -f "${snyk_report}" ]; then
    echo "${snyk_report} exists, skipping analysis";
  else
    echo "running snyk analysis on ${e}" ;
    snyk test --json --json-file-output=${snyk_report};
  fi
  cd $root;
done
