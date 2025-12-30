# Milestone 01 Runbook: Azure Fundamentals

**Student ID**: `YOUR_STUDENT_ID_HERE`
**Milestone**: M01
**Date**: `YYYY-MM-DD`

---

## Executive Summary

> **Purpose**: Provide a 3-4 sentence overview of what this infrastructure does and why it exists.
>
> **Example**: "This deployment establishes the foundational Azure infrastructure for ProTrack Milestone 01. It creates a secure storage layer using Azure Storage Account with production-grade security defaults. The architecture demonstrates understanding of resource organization, naming conventions, and Azure security best practices."

`TODO: Write your executive summary here`

---

## Architecture Overview

### High-Level Design

> **Guidance**: Include a diagram or ASCII art showing your resource relationships. Even a simple diagram demonstrates architectural thinking.
>
> **Example**:
> ```
> Azure Subscription
>   └── Resource Group (protrack-dev-jsmith-rg)
>       └── Storage Account (protrackdevjsmithsa)
>           ├── HTTPS-only enforced
>           ├── TLS 1.2 minimum
>           └── LRS replication
> ```

`TODO: Add your architecture diagram here`

### Resources Deployed

| Resource Type | Name | Purpose | Security Notes |
|---------------|------|---------|----------------|
| Resource Group | `<your-rg-name>` | Logical container for M01 resources | N/A |
| Storage Account | `<your-sa-name>` | Persistent blob storage | HTTPS-only, TLS 1.2+, no public access |

`TODO: Fill in the actual resource names from your deployment`

---

## Design Decisions

> **Guidance**: Explain WHY you made specific choices. Hiring managers want to see your thought process, not just what you built.

### 1. Region Selection

**Decision**: `eastus2`

**Rationale**:
`TODO: Explain why eastus2 was chosen (hint: cost, ProTrack requirements, latency considerations)`

**Alternatives Considered**:
`TODO: What other regions did you consider? Why did you reject them?`

---

### 2. Storage Account Configuration

**Decision**: Standard LRS (Locally Redundant Storage)

**Rationale**:
`TODO: Why LRS instead of GRS or ZRS? Consider cost vs. reliability tradeoffs for a dev environment.`

**Alternatives Considered**:
`TODO: Briefly explain GRS, ZRS, or RA-GRS and why they weren't appropriate here.`

---

### 3. Security Controls

**Decisions Made**:
- HTTPS-only traffic
- Minimum TLS 1.2
- No public blob access (default)

**Rationale**:
`TODO: Explain why these security settings matter. What attacks do they prevent? How do they align with Azure best practices?`

**Future Enhancements**:
`TODO: What additional security would you add in production? (e.g., private endpoints, Azure AD auth, encryption at rest with customer-managed keys)`

---

### 4. Naming Convention

**Pattern**: `{project}-{environment}-{student_id}-{resource_type}`

**Example**: `protrack-dev-jsmith-rg`

**Rationale**:
`TODO: Why is consistent naming important? How does this pattern help with organization, cost tracking, and automation?`

---

### 5. Tagging Strategy

**Tags Applied**:
```hcl
{
  ManagedBy   = "Terraform"
  Platform    = "ProTrack"
  Milestone   = "M01"
  Environment = "dev"
  StudentID   = "YOUR_ID"
}
```

**Rationale**:
`TODO: How do these tags help with cost management? How could they be used for automation or governance?`

---

## Deployment Guide

> **Guidance**: Write this as if you're handing off to another engineer. They should be able to deploy your infrastructure without asking you questions.

### Prerequisites

- Azure subscription with Contributor access
- Terraform >= 1.6 installed
- Azure CLI authenticated (`az login`)
- Git repository cloned locally

### Step-by-Step Deployment

#### 1. Configure Variables
```bash
cd milestones/M01
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your student ID and project name
```

#### 2. Initialize Terraform
```bash
terraform init
```

**Expected Output**:
`TODO: Paste a snippet of successful init output`

#### 3. Plan Deployment
```bash
terraform plan -out=tfplan
```

**Expected Output**:
`TODO: How many resources should be created? What changes does the plan show?`

#### 4. Apply Configuration
```bash
terraform apply tfplan
```

**Expected Output**:
`TODO: Paste confirmation of successful apply (resource IDs, outputs)`

#### 5. Verify Deployment
```bash
# Check outputs
terraform output

# Verify in Azure portal
az resource list --resource-group <YOUR_RG_NAME> --output table
```

### Deployment Time

**Total Duration**: `TODO: How long did the deployment take? (~2 minutes is typical)`

---

## Validation & Testing

> **Guidance**: How did you prove your infrastructure works correctly?

### Functional Tests

#### Test 1: Storage Account Accessibility
```bash
# Test HTTPS endpoint
curl -I https://<YOUR_STORAGE_ACCOUNT>.blob.core.windows.net/

# Expected: HTTP 400 (authenticated requests required)
```

**Result**: `TODO: Pass/Fail and why`

#### Test 2: Resource Group Existence
```bash
az group show --name <YOUR_RG_NAME> --query "{Name:name, Location:location, State:properties.provisioningState}"
```

**Result**: `TODO: Paste output showing Succeeded state`

### Security Validation

#### HTTPS Enforcement
`TODO: How did you verify HTTPS-only is enforced? Try accessing via HTTP and show it fails.`

#### TLS Version Check
`TODO: How did you confirm TLS 1.2 minimum is active?`

---

## Troubleshooting

> **Guidance**: Document issues you encountered and how you solved them. This is valuable learning.

### Issue 1: `<Problem Description>`

**Symptoms**:
`TODO: What error did you see?`

**Root Cause**:
`TODO: Why did it happen?`

**Resolution**:
`TODO: How did you fix it?`

**Prevention**:
`TODO: How can this be avoided in the future?`

---

### Issue 2: `<Another Problem>`

`TODO: Repeat the above structure for any other issues you encountered`

---

## Cost Analysis

> **Guidance**: Demonstrate awareness of cloud costs—critical for real engineering.

### Estimated Monthly Cost

| Resource | SKU/Tier | Estimated Cost |
|----------|----------|----------------|
| Storage Account | Standard LRS | ~$0.02/GB + transactions |
| Resource Group | N/A | Free |
| **Total** | | **~$1-2/month** |

**Assumptions**:
`TODO: What storage volume did you assume? How many transactions?`

**Cost Optimization**:
`TODO: How could you reduce costs further? (e.g., lifecycle policies, cheaper tiers, cleanup automation)`

---

## Security Considerations

> **Guidance**: Show you think about security beyond just "check the box."

### Current Security Posture

**Strengths**:
- `TODO: What security controls are in place?`
- `TODO: What attack vectors are mitigated?`

**Weaknesses**:
- `TODO: What threats are NOT addressed yet?`
- `TODO: What would you improve with more time/budget?`

### Threat Model

**Attack Scenarios**:
1. `TODO: What if an attacker gets your storage account key?`
2. `TODO: What if someone tries to brute-force your blob URLs?`

**Mitigations**:
1. `TODO: How does your current design defend against these?`
2. `TODO: What additional controls would you add?`

---

## Monitoring & Observability

> **Guidance**: How would you know if this infrastructure is working in production?

### Key Metrics to Monitor

`TODO: What metrics would you track? (e.g., storage usage, request latency, failed auth attempts)`

### Alerting Strategy

`TODO: What alerts would you configure? When should someone wake up at 3 AM?`

### Logging

`TODO: What logs should be collected? How long should they be retained?`

---

## Disaster Recovery

> **Guidance**: What happens if everything breaks?

### Backup Strategy

`TODO: How is data backed up? What's the Recovery Point Objective (RPO)?`

### Recovery Procedure

`TODO: Step-by-step: How would you restore from a complete loss?`

### RTO/RPO

- **Recovery Time Objective (RTO)**: `TODO: How long to restore service?`
- **Recovery Point Objective (RPO)**: `TODO: Maximum acceptable data loss?`

---

## Decommissioning

> **Guidance**: Clean up is part of the job. Don't leave orphaned resources.

### Teardown Procedure

```bash
cd milestones/M01
terraform destroy
```

**Verification**:
```bash
az group show --name <YOUR_RG_NAME>
# Should return: ResourceGroupNotFound
```

**Cost Impact**: All resources deleted = $0/month

---

## Lessons Learned

> **Guidance**: Reflection is what turns experience into expertise.

### What Went Well

`TODO: What worked smoothly? What decisions paid off?`

### What Was Challenging

`TODO: What took longer than expected? What confused you?`

### What I Would Do Differently

`TODO: If you started over, what would you change?`

### Skills Developed

`TODO: What did you learn that you didn't know before?`

---

## Appendix

### Terraform Outputs

```
TODO: Paste full `terraform output` results here
```

### Azure Resource IDs

```
TODO: List full resource IDs for traceability
```

### References

- [Azure Storage Security Best Practices](https://learn.microsoft.com/en-us/azure/storage/common/storage-security-guide)
- [Terraform azurerm Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- `TODO: Add any other references you used`

---

## Reviewer Notes

> **For ProTrack Evaluators**:

- All required sections completed: ☐
- Architecture diagram included: ☐
- Design rationale explained: ☐
- Security considerations addressed: ☐
- Evidence of testing: ☐

**Evaluator Comments**:
`(This section is filled out during grading)`

---

**END OF RUNBOOK**

---

## Grading Rubric (For Reference)

| Section | Points | What We're Looking For |
|---------|--------|------------------------|
| Architecture Overview | 10 | Clear diagram, accurate resource list |
| Design Decisions | 25 | Thoughtful rationale, alternatives considered |
| Deployment Guide | 15 | Reproducible steps, actual outputs included |
| Security Considerations | 20 | Threat modeling, mitigations explained |
| Troubleshooting | 10 | Real issues documented, solutions explained |
| Cost Analysis | 10 | Realistic estimates, optimization thinking |
| Lessons Learned | 10 | Honest reflection, growth mindset |
| **Total** | **100** | |

**Passing Score**: 70/100

## My Notes
This is my M01 submission!
