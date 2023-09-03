This folder contains tools for creating and maintaining proof-of-vulnerability projects:

* `create-pov-project.js`: helper script to create project JSON file based on GHSA data
* `pov-project-schema.cue`: Cue schema to validate project JSON files
* `create-pom.sh`: helper script to create `pom.xml` from project JSON file

## PoV Metadata Example
```js
{
  // CVE used as id
  "id": "CVE-2018-1002201",
  // Maven artifact GA
  "artifact": "org.zeroturnaround:zt-zip",
  // Vulnerable versions of the artifact
  "vulnerableVersions": [
    "1.10",
    "1.11",
    "1.12",
    "1.4",
    "1.5",
    "1.6",
    "1.7",
    "1.8",
    "1.9"
  ],
  // Single version where vulnerability is fixed
  "fixVersion": "1.13",
  // Whether JUnit succeeds or fails in the presence of the vulnerability
  "testSignal": "success"
}

```

## Instructions
```sh
# Download vulnerability data from OSV into tools/ directory
wget https://osv-vulnerabilities.storage.googleapis.com/Maven/all.zip
unzip all.zip

# Create a POV project metadata file
mkdir CVE-0000-1234
cd CVE-0000-1234
node ../tools/create-pov-project.js CVE-0000-1234 > pov-project.json

# Validate project file
cue vet pov-project.json ../tools/pov-project-schema.cue

# Create POM from metadata file
../tools/create-pom.sh

```
