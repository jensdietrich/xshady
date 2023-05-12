#!/bin/sh

# config required to increase max allowed age of vulnerability DB
if [ ! -f .grype.yml ]; then
  echo "Grype config file not found. Exiting."
  exit 1
fi


# ensure we have a vulnerability DB 
set -e
grype db status
set +x

# turn off all online activity
export GRYPE_CHECK_FOR_APP_UPDATE=0
export GRYPE_DB_AUTO_UPDATE=0

report_file=scan-results/grype/grype-report.json;

for d in CVE-*/ ; do
  echo "traversing ${d}";
  if [ -f "${d}/${report_file}" ]; then
      echo "${d}/${report_file} exists, skipping analysis";
  else
    mkdir -p ${d}/scan-results/grype
    echo "running grype analysis on ${d}"
    grype --output json --file ${d}/${report_file} ${d};
  fi
done
