package main

# Block deployment if any CRITICAL CVE with an available fix is present.
# Writing this as an explicit policy (rather than relying only on Trivy's
# exit-code) means the rule is version-controlled, peer-reviewed, and auditable.
deny[msg] {
    result := input.Results[_]
    vuln := result.Vulnerabilities[_]
    vuln.Severity == "CRITICAL"
    vuln.FixedVersion != ""
    msg := sprintf(
        "CRITICAL CVE blocked deployment: %s in package %s (fix available: %s)",
        [vuln.VulnerabilityID, vuln.PkgName, vuln.FixedVersion],
    )
}
