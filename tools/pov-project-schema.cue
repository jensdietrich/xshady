#ProjectFile: {
	// CVE ID
	id: string
	// Maven artifact: "group:artifact"
	artifact: string
	// At least one version must be provided
	vulnableVersions: [string, ...string]
	fixVersion: string
	testSignal: "success" | "failure"
	// URL references, at least one must be provided
	references: [string, ...string]
}

#ProjectFile
