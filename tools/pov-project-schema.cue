#ProjectFile: {
	// CVE ID
	id: string
	// Maven artifact: "group:artifact"
	artifact: string
	// At least one version must be provided
	vulnerableVersions: [string, ...string]
	fixVersion: string
	testSignalWhenVulnerable: "success" | "failure"
	// URL references, at least one must be provided
	references: [string, ...string]
}

#ProjectFile
