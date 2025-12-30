#!/bin/bash
#
# ProTrack Evidence Collection Script
#
# Purpose: Captures proof of successful Azure infrastructure deployment
# Usage: ./scripts/collect_evidence.sh <MILESTONE>
# Example: ./scripts/collect_evidence.sh M01
#
# What this script does:
# 1. Validates your Terraform deployment exists
# 2. Extracts resource IDs and metadata
# 3. Captures Terraform outputs
# 4. Saves deployment state (NO SECRETS)
# 5. Generates evidence report
#
# What this script does NOT do:
# - Commit secrets or credentials (filtered automatically)
# - Take screenshots (you'll do this manually)
# - Modify any infrastructure
#
# Output: evidence/<MILESTONE>/deployment_evidence.json

set -euo pipefail

# ============================================================================
# CONFIGURATION
# ============================================================================

MILESTONE="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
EVIDENCE_DIR="${REPO_ROOT}/evidence/${MILESTONE}"
TF_DIR="${REPO_ROOT}/milestones/${MILESTONE}"
OUTPUT_FILE="${EVIDENCE_DIR}/deployment_evidence.json"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

print_banner() {
    echo "========================================================================"
    echo "$1"
    echo "========================================================================"
}

print_info() {
    echo "[INFO] $1"
}

print_success() {
    echo "[SUCCESS] ✓ $1"
}

print_error() {
    echo "[ERROR] ✗ $1" >&2
}

print_warning() {
    echo "[WARNING] ⚠ $1"
}

# ============================================================================
# VALIDATION
# ============================================================================

validate_inputs() {
    print_banner "Validating Inputs"

    # Check milestone argument
    if [[ -z "${MILESTONE}" ]]; then
        print_error "Milestone argument required"
        echo ""
        echo "Usage: $0 <MILESTONE>"
        echo "Example: $0 M01"
        exit 1
    fi

    # Validate milestone format
    if [[ ! "${MILESTONE}" =~ ^M0[1-3]$ ]]; then
        print_error "Invalid milestone: ${MILESTONE}"
        echo "Valid milestones: M01, M02, M03"
        exit 1
    fi

    print_success "Milestone: ${MILESTONE}"

    # Check if Terraform directory exists
    if [[ ! -d "${TF_DIR}" ]]; then
        print_error "Terraform directory not found: ${TF_DIR}"
        exit 1
    fi

    print_success "Terraform directory found: ${TF_DIR}"

    # Check if Terraform is initialized
    if [[ ! -d "${TF_DIR}/.terraform" ]]; then
        print_error "Terraform not initialized. Run 'terraform init' first."
        exit 1
    fi

    print_success "Terraform is initialized"
}

# ============================================================================
# EVIDENCE COLLECTION
# ============================================================================

collect_terraform_outputs() {
    print_banner "Collecting Terraform Outputs"

    cd "${TF_DIR}"

    # Check if state exists
    if ! terraform state list &>/dev/null; then
        print_error "No Terraform state found. Have you run 'terraform apply'?"
        exit 1
    fi

    print_success "Terraform state exists"

    # Extract outputs (JSON format)
    if terraform output -json > /tmp/tf_outputs.json 2>/dev/null; then
        print_success "Outputs captured"
    else
        print_warning "No outputs defined or accessible"
        echo '{}' > /tmp/tf_outputs.json
    fi

    cd - > /dev/null
}

collect_resource_metadata() {
    print_banner "Collecting Resource Metadata"

    cd "${TF_DIR}"

    # Get list of resources
    terraform state list > /tmp/tf_resources.txt

    local resource_count
    resource_count=$(wc -l < /tmp/tf_resources.txt)
    print_success "${resource_count} resources deployed"

    # Extract resource details (sanitized)
    terraform show -json > /tmp/tf_state.json 2>/dev/null || true

    cd - > /dev/null
}

sanitize_secrets() {
    print_banner "Sanitizing Secrets"

    # Remove sensitive fields from JSON
    # This prevents accidental secret leakage
    local input_file="$1"
    local output_file="$2"

    jq 'walk(
        if type == "object" then
            with_entries(
                if .key | test("secret|password|key|token|credential"; "i") then
                    .value = "***REDACTED***"
                else
                    .
                end
            )
        else
            .
        end
    )' "${input_file}" > "${output_file}"

    print_success "Secrets sanitized"
}

generate_evidence_report() {
    print_banner "Generating Evidence Report"

    # Create evidence directory
    mkdir -p "${EVIDENCE_DIR}"

    # Read Terraform outputs
    local tf_outputs
    tf_outputs=$(cat /tmp/tf_outputs.json)

    # Read resource list
    local resources
    resources=$(cat /tmp/tf_resources.txt | jq -R -s -c 'split("\n") | map(select(length > 0))')

    # Sanitize state file
    if [[ -f /tmp/tf_state.json ]]; then
        sanitize_secrets /tmp/tf_state.json /tmp/tf_state_sanitized.json
        local state_data
        state_data=$(cat /tmp/tf_state_sanitized.json)
    else
        local state_data='{}'
    fi

    # Build evidence JSON
    cat > "${OUTPUT_FILE}" <<EOF
{
  "metadata": {
    "milestone": "${MILESTONE}",
    "timestamp": "${TIMESTAMP}",
    "terraform_version": "$(terraform version -json | jq -r '.terraform_version')",
    "collector_version": "1.0.0"
  },
  "deployment": {
    "outputs": ${tf_outputs},
    "resources": ${resources},
    "resource_count": $(echo "${resources}" | jq 'length')
  },
  "validation": {
    "terraform_initialized": true,
    "terraform_state_exists": true,
    "secrets_sanitized": true
  }
}
EOF

    print_success "Evidence report saved: ${OUTPUT_FILE}"

    # Generate human-readable summary
    cat > "${EVIDENCE_DIR}/SUMMARY.txt" <<EOF
ProTrack Evidence Summary
=========================

Milestone: ${MILESTONE}
Collected: ${TIMESTAMP}
Terraform Version: $(terraform version -json | jq -r '.terraform_version')

Resources Deployed:
$(cat /tmp/tf_resources.txt)

Outputs:
$(terraform output -no-color 2>/dev/null || echo "No outputs available")

Evidence Files:
- ${OUTPUT_FILE}
- ${EVIDENCE_DIR}/SUMMARY.txt

Next Steps:
1. Review evidence files for accuracy
2. Capture screenshots of Azure portal showing deployed resources
3. Add screenshots to evidence/${MILESTONE}/ directory
4. Commit evidence to Git (secrets are already filtered)
5. Submit PR for evaluation

IMPORTANT: Manually verify that no secrets are present in evidence files.
EOF

    print_success "Summary saved: ${EVIDENCE_DIR}/SUMMARY.txt"
}

# ============================================================================
# CLEANUP
# ============================================================================

cleanup() {
    print_info "Cleaning up temporary files..."
    rm -f /tmp/tf_outputs.json /tmp/tf_resources.txt /tmp/tf_state.json /tmp/tf_state_sanitized.json
}

trap cleanup EXIT

# ============================================================================
# MAIN EXECUTION
# ============================================================================

main() {
    print_banner "ProTrack Evidence Collection - ${MILESTONE}"

    validate_inputs
    collect_terraform_outputs
    collect_resource_metadata
    generate_evidence_report

    print_banner "Evidence Collection Complete"
    echo ""
    print_success "Evidence saved to: ${EVIDENCE_DIR}"
    echo ""
    print_info "Next steps:"
    echo "  1. Review ${OUTPUT_FILE}"
    echo "  2. Capture Azure portal screenshots"
    echo "  3. Add screenshots to ${EVIDENCE_DIR}/"
    echo "  4. Commit and push evidence"
    echo ""
    print_warning "SECURITY CHECK: Verify no secrets are in evidence files"
    echo ""
}

main "$@"
