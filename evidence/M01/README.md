# Milestone 01 Evidence Directory

This directory contains proof of your successful M01 infrastructure deployment.

## Required Files

After running `./scripts/collect_evidence.sh M01`, this directory should contain:

### Auto-Generated Files

1. **deployment_evidence.json**
   - Machine-readable deployment metadata
   - Terraform outputs and resource IDs
   - Sanitized (no secrets)
   - Required for CI validation

2. **SUMMARY.txt**
   - Human-readable deployment summary
   - Resource list
   - Terraform version info
   - Quick reference

### Manual Evidence (You Add These)

3. **Screenshots** (at least 1 required):
   - `screenshot_resource_group.png` - Azure Portal showing Resource Group
   - `screenshot_storage_account.png` - Storage Account configuration
   - `screenshot_security.png` - Security settings (HTTPS, TLS)
   - (Name files descriptively)

4. **Optional Supporting Evidence**:
   - Azure CLI output files
   - Additional portal screenshots
   - Verification command outputs

## How to Collect Evidence

### Step 1: Deploy Infrastructure
```bash
cd milestones/M01
terraform apply
```

### Step 2: Run Evidence Script
```bash
cd ../..
./scripts/collect_evidence.sh M01
```

### Step 3: Capture Screenshots
1. Log into Azure Portal (portal.azure.com)
2. Navigate to your Resource Group
3. Take screenshots of:
   - Resource Group overview
   - Storage Account details
   - Security/configuration tabs
4. Save to this directory with descriptive names

### Step 4: Verify Completeness
```bash
ls evidence/M01/
# Should show:
# - deployment_evidence.json
# - SUMMARY.txt
# - screenshot_*.png (at least 1)
```

## Security Checklist

Before committing evidence, verify:

- [ ] No storage account keys are visible in files
- [ ] No connection strings are present
- [ ] No passwords or secrets in screenshots
- [ ] `deployment_evidence.json` shows "REDACTED" for sensitive fields
- [ ] Screenshots don't show access keys or SAS tokens

**If you find secrets**: Delete the files, regenerate evidence, and verify sanitization.

## What Gets Committed

✅ **DO commit**:
- `deployment_evidence.json`
- `SUMMARY.txt`
- Screenshots (PNG, JPG)
- Azure CLI output (sanitized)

❌ **DO NOT commit**:
- Storage account keys
- Connection strings
- Terraform state files
- Credentials of any kind

## CI Validation

When you submit your PR, CI checks for:
- Presence of `deployment_evidence.json`
- Valid JSON structure
- Recent timestamp (evidence was collected recently)
- At least 1 screenshot file

Missing evidence will block your PR from merging.

## Troubleshooting

**Problem**: Evidence script fails
**Solution**: Ensure Terraform is deployed first (`terraform apply`)

**Problem**: JSON file is empty
**Solution**: Check that Terraform outputs are defined in `outputs.tf`

**Problem**: CI says evidence is missing
**Solution**: Verify files are committed: `git status`

## Example Directory Structure

After completion, your structure should look like:

```
evidence/M01/
├── README.md (this file)
├── deployment_evidence.json
├── SUMMARY.txt
├── screenshot_resource_group.png
├── screenshot_storage_account.png
└── screenshot_security_settings.png
```

## Need Help?

- Review: `scripts/README.md` for evidence collection details
- Check: `.gitignore` to see what's excluded
- Ask: Open a GitHub issue if you have questions

---

**Remember**: Evidence is your proof of work. Take it seriously and verify accuracy.
