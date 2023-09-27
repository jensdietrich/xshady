#ProjectFile: {
	// CVE ID
	id: string
	// Maven artifact: "group:artifact"
	artifact: string
	// At least one version must be provided
	vulnerableVersions: [string, ...string]
	fixVersion: string
	// The JDK version to build and run the PoV tests with
	jdkVersion?: "7" | "8" | "11" | "17"
	testSignalWhenVulnerable: "success" | "failure"
	// URL references, at least one must be provided
	references: [string, ...string]
}

#ProjectFile
