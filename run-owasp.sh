#!/bin/sh

# run owasp sca on all folders
root=$(pwd)
owasp_report=scan-results/dependency-check/dependency-check-report.json;
for d in CVE-*/ ; do
  echo "traversing ${d}";
  cd $d;
  if [ -f "${owasp_report}" ]; then
    echo "${owasp_report} exists, skipping analysis";
  else
    echo "running owasp dependency check analysis on ${e}" ;
    mvn org.owasp:dependency-check-maven:8.2.1:check -Dformat=json -DprettyPrint=true -Dodc.outputDirectory=$owasp_report
  #  dependency-check -scan . -f JSON -o scan-results/dependency-check -prettyPrint;
  fi
  cd $root;
done
