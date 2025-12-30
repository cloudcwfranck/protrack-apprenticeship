# ProTrack Evidence Collection Scripts

This directory contains automation scripts for capturing deployment evidence required by ProTrack evaluation.

## Purpose

Evidence proves that:
1. Your infrastructure was successfully deployed
2. Resources match your documentation
3. Security controls are in place
4. Your work is reproducible

Evidence is **required** for milestone completion—without it, your PR cannot be merged.

---

## Available Scripts

### `collect_evidence.sh`

**Purpose**: Captures Terraform deployment metadata and outputs

**Usage**:
```bash
./scripts/collect_evidence.sh <MILESTONE>
```

**Example**:
```bash
# After successfully deploying M01
cd milestones/M01
terraform apply

# Collect evidence
cd ../..
./scripts/collect_evidence.sh M01
```

**What It Does**:
- ✅ Extracts Terraform outputs
- ✅ Lists deployed resources
- ✅ Captures deployment metadata
- ✅ Filters out secrets and credentials
- ✅ Generates JSON evidence report
- ✅ Creates human-readable summary

**What It Does NOT Do**:
- ❌ Modify your infrastructure
- ❌ Commit files to Git
- ❌ Take Azure portal screenshots (you do this manually)
- ❌ Upload anything to external services

**Output Files**:
```
evidence/M01/
├── deployment_evidence.json   # Machine-readable evidence
└── SUMMARY.txt                # Human-readable summary
```

---

## When to Run Evidence Collection

**Timing**: After `terraform apply` succeeds, **before** opening your PR

**Workflow**:
```bash
# 1. Deploy infrastructure
cd milestones/M01
terraform apply

# 2. Verify deployment
terraform output
az resource list --resource-group <YOUR_RG_NAME>

# 3. Collect evidence
cd ../..
./scripts/collect_evidence.sh M01

# 4. Capture manual screenshots (see below)

# 5. Commit everything
git add evidence/M01/
git commit -m "Add M01 deployment evidence"
```

---

## Manual Evidence Required

The script automates most evidence collection, but you must manually add:

### 1. Azure Portal Screenshots

**Required Screenshots**:
- Resource Group overview showing all deployed resources
- Storage Account overview showing configuration
- Storage Account security settings (HTTPS-only, TLS version)

**How to Capture**:
1. Log into Azure Portal (portal.azure.com)
2. Navigate to your Resource Group
3. Take screenshots showing:
   - Resource list
   - Individual resource configurations
   - Security settings
4. Save as: `evidence/M01/screenshot_*.png`

**Naming Convention**:
- `screenshot_resource_group.png`
- `screenshot_storage_account.png`
- `screenshot_security_settings.png`

### 2. Verification Commands

Run these commands and save output:

```bash
# List resources
az resource list --resource-group <YOUR_RG_NAME> --output table > evidence/M01/azure_resources.txt

# Show Resource Group details
az group show --name <YOUR_RG_NAME> > evidence/M01/resource_group_details.json

# Show Storage Account details (sanitize keys!)
az storage account show --name <YOUR_SA_NAME> --resource-group <YOUR_RG_NAME> > evidence/M01/storage_account_details.json
```

**WARNING**: Never commit storage account keys. The script filters them, but double-check manually.

---

## Security & Privacy

### What Is Filtered

The evidence script automatically redacts:
- Storage account keys
- Connection strings
- Passwords and secrets
- API tokens
- Any field matching: `secret`, `password`, `key`, `token`, `credential`

### What You Must Check

Before committing evidence, manually verify:

```bash
# Search for potential secrets
grep -r "REDACTED" evidence/M01/

# Check for access keys
grep -ri "key" evidence/M01/ | grep -v "REDACTED"

# Look for connection strings
grep -ri "connection" evidence/M01/ | grep -v "REDACTED"
```

**If you find secrets**: Delete the file, regenerate it, and verify filtering worked.

---

## CI Validation

When you submit a PR, CI checks:

✅ **Evidence Files Exist**:
- `evidence/M0X/deployment_evidence.json`
- `evidence/M0X/SUMMARY.txt`

✅ **Evidence Is Valid**:
- JSON is parseable
- Timestamp is recent
- Resource count matches expectations

✅ **No Secrets Present**:
- Scans for common secret patterns
- Fails PR if secrets detected

❌ **Common Failures**:
- Missing evidence files → Run `collect_evidence.sh`
- Invalid JSON → Check for corruption
- Secrets detected → Re-run script, verify filtering

---

## Troubleshooting

### Script Fails: "Terraform not initialized"

**Solution**:
```bash
cd milestones/M01
terraform init
cd ../..
./scripts/collect_evidence.sh M01
```

### Script Fails: "No Terraform state found"

**Cause**: You haven't deployed yet

**Solution**:
```bash
cd milestones/M01
terraform apply
cd ../..
./scripts/collect_evidence.sh M01
```

### JSON Parsing Errors

**Cause**: `jq` not installed

**Solution**:
```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS
brew install jq
```

### Evidence Files Are Empty

**Cause**: Terraform outputs not defined

**Solution**: Check `outputs.tf` and ensure outputs exist

---

## Example Evidence Structure

After running the script, you should have:

```
evidence/M01/
├── deployment_evidence.json       # Auto-generated
├── SUMMARY.txt                    # Auto-generated
├── screenshot_resource_group.png  # Manual
├── screenshot_storage_account.png # Manual
├── screenshot_security.png        # Manual
├── azure_resources.txt            # Manual (optional)
└── resource_group_details.json    # Manual (optional)
```

**Minimum Required**:
- `deployment_evidence.json` ✅
- `SUMMARY.txt` ✅
- At least 1 screenshot showing deployed resources ✅

---

## FAQ

**Q: Can I skip evidence collection?**
A: No. CI will block your PR if evidence is missing.

**Q: What if I destroy my infrastructure before collecting evidence?**
A: You'll need to redeploy, collect evidence, then destroy again.

**Q: Can I manually create the JSON file?**
A: Not recommended. The script ensures proper formatting and secret filtering.

**Q: How do I update evidence after making changes?**
A: Re-run `collect_evidence.sh` and commit the updated files.

**Q: What if my evidence contains secrets?**
A: Delete all evidence files, rotate the exposed secrets, redeploy, and re-collect evidence.

---

## Support

If evidence collection fails:

1. Check the error message carefully
2. Verify Terraform is initialized and deployed
3. Ensure `jq` is installed
4. Review this README
5. Open a GitHub issue with the error message

---

**Remember**: Evidence is your proof of work. Take it seriously.
