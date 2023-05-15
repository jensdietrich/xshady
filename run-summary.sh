#!/bin/bash

shopt -s globstar
rm output.csv
echo -e "cve\tlib\tsteady\tsnyk\towasp\tgrype" > output.csv
for p in **/scan-results/; do
  cve=$(echo $p | cut -d'/' -f1)
  echo $cve
  steady=$p/steady/steady-report.json
  owasp=$p/dependency-check/dependency-check-report.json
  snyk=$p/snyk/snyk-report.json
  grype=$p/grype/grype-report.json

  countsteady=$(jq -r '.vulasReport.vulnerabilities[].bug.id' $steady | grep  $cve | sort | uniq | wc -l)
  countsnyk=$(jq -r '.vulnerabilities[].identifiers.CVE[]' $snyk | grep $cve | sort | uniq | wc -l)
  countowasp=$(jq -r '.dependencies[] | if has("vulnerabilities") then .vulnerabilities[].name else "missing" end' $owasp | grep $cve | sort | uniq | wc -l)
  countgrype1=$(jq -r '.matches[].vulnerability.id' $grype | grep $cve | sort | uniq |  wc -l)
  countgrype2=$(jq -r '.matches[].relatedVulnerabilities[].id' $grype  | grep $cve | sort | uniq | wc -l)
  countgrype=$(expr $countgrype2 + $countgrype1)
  if [[ $countgrype -gt 1 ]]; then
    countgrype=1 
  fi
  echo -e "$cve \t $p \t $countsteady \t $countsnyk \t $countowasp \t $countgrype" >> output.csv
done
