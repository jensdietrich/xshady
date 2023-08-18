#!/bin/bash -e
SCRIPT=$(readlink -f "${BASH_SOURCE[0]:-$0}")
DIR=$(dirname $SCRIPT)

PROJECT_FILE=pov-project.json

GA=$(jq -r .artifact $PROJECT_FILE)
VERSION=$(jq -r '.vulnableVersions|.[0]' $PROJECT_FILE)

readarray -d ':' -t split < <(printf "%s" "$GA")
export CVE=$(jq -r .id $PROJECT_FILE)
export GROUP=${split[0]}
export ARTIFACT=${split[1]}
export VERSION

echo "CVE: $CVE"
echo "GAV: ($GROUP,$ARTIFACT,$VERSION)"
echo "Writing pom.xml"
envsubst < $DIR/skel/pom.xml.template > pom.xml.tmp
mv -i pom.xml.tmp pom.xml

