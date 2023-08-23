const fs = require('fs');
const path = require('path');

function usage() {
    console.error('Usage: %s CVE [GROUP:ARTIFACT]', path.basename(process.argv[1]));
}

function createMap(dir) {
    const cveMap = new Map();
    const skipped = [];

    function parse(json) {
        if (!json.aliases) {
            // console.error('Skipping %s, no aliases (no link to CVE)', json.id);
            skipped.push(json.id);
            return;
        }
        const cves = json.aliases.filter(s => s.startsWith("CVE"));
        console.assert(cves.length === 1);
        const cve = cves[0];
        if (!cveMap.has(cve)) {
            cveMap.set(cve, []);
        }
        cveMap.get(cve).push(json.id);
    }

    for (const file of fs.readdirSync(dir)) {
        if (file.startsWith("GHSA") && file.endsWith("json")) {
            const data = fs.readFileSync(path.join(dir, file), 'utf8');
            const json = JSON.parse(data);
            parse(json);
        }
    }

    console.error('Skipped %d GHSA files (no link to CVE)', skipped.length);

    const result = [];

    for (const e of cveMap.entries()) {
        if (e[1].length > 1) {
            console.error('More than one mapping: %s -> %s', e[0], e[1]);
        } else {
            result.push([e[0], e[1][0]]);
        }
    }

    return result;
}

if (process.argv.length < 3) {
    usage();
    process.exit(1);
}

const cve = process.argv[2];
if (!(cve.match(/CVE-\d\d\d\d-\d+/))) {
    console.error('Argument "%s" does not match CVE format', cve);
    usage();
    process.exit(1);
}

const cveMap = new Map(createMap(__dirname));
const ghsa = cveMap.get(cve);
const data = fs.readFileSync(path.join(__dirname, ghsa + '.json'), 'utf8');
const json = JSON.parse(data);

let affected;

if (json.affected.length > 1) {
    if (process.argv.length < 4) {
        console.error('More than one affected package, specify target artifact as arg');
        process.exit(1);
    }
    affected = json.affected.find(x => x.package.name == process.argv[3]);
    if (!affected) {
        console.error('Vulnerable versions: ', json.affected);
        console.error('Package name "%s" not found', process.argv[3]);
        process.exit(1);
    }
} else {
    const { Console } = console;
    const c = new Console({ stdout: process.stdout, stderr: process.stderr, inspectOptions: { depth: null } });
    affected = json.affected[0];
}

const xshady = {
    id: cve,
    artifact: affected.package.name,
    vulnableVersions: affected.versions,
    fixVersion: null,
    testSignal: "success|failure"
}

console.log(JSON.stringify(xshady, null, 2));
