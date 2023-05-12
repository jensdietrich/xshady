#!/bin/sh


report_file=scan-results/steady/steady-report.json;
root=$(pwd)
for d in CVE-*/ ; do
  echo "traversing ${d}";
  if [ -f "${d}/${report_file}" ]; then
      echo "${d}/${report_file} exists, skipping analysis";
  else
    cd $d
    echo "running steady analysis on ${d}"
    mvn org.eclipse.steady:plugin-maven:3.2.5:app
    mvn org.eclipse.steady:plugin-maven:3.2.5:report -Dvulas.report.reportDir=$(pwd)/scan-results/steady
    mv scan-results/steady/vulas-report.json scan-results/steady/steady-report.json
    rm scan-results/steady/vulas*
    cd $root
  fi
done
