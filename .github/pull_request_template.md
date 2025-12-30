# ProTrack Milestone Submission

## Milestone Information

**Milestone**: M0X (replace X with 1, 2, or 3)
**Student ID**: `your-student-id-here`
**Date Submitted**: YYYY-MM-DD

---

## Checklist

Before submitting this PR, verify you've completed ALL of the following:

### Terraform
- [ ] All Terraform files are present (`main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`)
- [ ] `terraform fmt` has been run (code is formatted)
- [ ] `terraform validate` passes locally
- [ ] `terraform plan` runs without errors
- [ ] `terraform apply` successfully deployed infrastructure
- [ ] Resources are visible in Azure Portal
- [ ] No hardcoded secrets or credentials in code

### Documentation
- [ ] Runbook (`docs/M0X/runbook.md`) is complete
- [ ] All TODO sections are filled out
- [ ] Architecture diagram is included
- [ ] Design decisions are explained with rationale
- [ ] Security considerations are documented
- [ ] Troubleshooting section includes real issues encountered

### Evidence
- [ ] Evidence collection script has been run (`./scripts/collect_evidence.sh M0X`)
- [ ] `evidence/M0X/deployment_evidence.json` is present
- [ ] `evidence/M0X/SUMMARY.txt` is present
- [ ] Azure Portal screenshots are included
- [ ] No secrets are present in evidence files (verified manually)

### Git & Process
- [ ] Branch follows naming convention (`m0X-work` or similar)
- [ ] Commit messages are clear and descriptive
- [ ] No prohibited files committed (`.tfstate`, `terraform.tfvars`, secrets)
- [ ] `.gitignore` rules are respected
- [ ] CI checks are passing (green checkmarks)

---

## Deployment Summary

**Resources Deployed** (list them):
- Resource Group: `name-here`
- Storage Account: `name-here`
- (Add others as applicable)

**Terraform Outputs** (paste output of `terraform output`):
```
(paste here)
```

**Deployment Time**: ~X minutes

---

## Key Design Decisions

Summarize your most important architectural decisions:

1. **Decision**: (e.g., "Used LRS instead of GRS")
   - **Rationale**: (e.g., "Cost optimization for dev environment")

2. **Decision**: (e.g., "Enforced HTTPS-only traffic")
   - **Rationale**: (e.g., "Security best practice, prevents MitM attacks")

3. **Decision**: (Add more as needed)
   - **Rationale**:

---

## Challenges & Solutions

What problems did you encounter and how did you solve them?

1. **Challenge**: (e.g., "Storage account name was not globally unique")
   - **Solution**: (e.g., "Added hash of student ID to name")

2. **Challenge**: (Add more if applicable)
   - **Solution**:

---

## Evidence Location

- Deployment Evidence: `evidence/M0X/deployment_evidence.json`
- Screenshots: `evidence/M0X/screenshot_*.png`
- Summary: `evidence/M0X/SUMMARY.txt`

---

## Security Verification

I have verified that:
- [ ] No Azure credentials are committed
- [ ] No storage account keys are in the repository
- [ ] No `.tfstate` files are committed
- [ ] All secrets are stored in Azure Key Vault or environment variables
- [ ] Evidence files have been sanitized (checked manually)

---

## Testing Performed

Describe how you tested your infrastructure:

- [ ] Ran `terraform plan` and reviewed changes
- [ ] Deployed with `terraform apply`
- [ ] Verified resources in Azure Portal
- [ ] Tested storage account accessibility (HTTPS enforcement)
- [ ] Validated security settings (TLS 1.2+, no public access)
- [ ] (Add other tests as applicable)

---

## Cost Analysis

**Estimated Monthly Cost**: $X.XX

**Cost Breakdown**:
- Storage Account (Standard LRS): ~$X.XX
- (Add others if applicable)

**Assumptions**: (e.g., "Assumes 10GB storage, minimal transactions")

---

## Questions for Reviewers

If you have any questions or need clarification during review, list them here:

1. (Optional)
2. (Optional)

---

## Next Steps After Merge

After this PR is merged, I understand that:
- [ ] The next milestone will automatically unlock
- [ ] I should pull the latest `main` branch to see unlocked content
- [ ] I can start working on the next milestone immediately
- [ ] I can still make fixes to this milestone if needed

---

## Additional Notes

(Any other information reviewers should know)

---

## Reviewer Use Only

**Scorecard Summary**:
- Terraform Quality: ___/40
- Documentation: ___/30
- Evidence: ___/20
- Process: ___/10
- **Total**: ___/100

**Passing Score**: 70/100

**Reviewer Notes**:
(To be filled out during review)
