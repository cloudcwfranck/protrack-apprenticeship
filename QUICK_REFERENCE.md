# ProTrack Quick Reference

**Repository**: https://github.com/QuestLogicSolutions/protrack-azure-student-template
**Branch**: `claude/setup-student-template-ngc8S`
**Status**: ✅ Production Ready

---

## Create Pull Request (Manual)

1. Go to: https://github.com/QuestLogicSolutions/protrack-azure-student-template/pulls
2. Click: **"New pull request"**
3. Set:
   - **Base**: `main`
   - **Compare**: `claude/setup-student-template-ngc8S`
4. **Title**: `Initial Setup: Production-Ready ProTrack Student Template`
5. **Description**: Copy entire contents from `PR_DESCRIPTION.md`
6. Click: **"Create pull request"**

---

## After PR Merges

### Enable as Template Repository

```
1. Go to: https://github.com/QuestLogicSolutions/protrack-azure-student-template/settings
2. Scroll to "Template repository" section
3. Check ✅ "Template repository"
4. Click "Save"
```

Students can now click **"Use this template"** to start!

---

## Test Student Workflow

```bash
# Clone as student
git clone https://github.com/QuestLogicSolutions/protrack-azure-student-template.git test-student
cd test-student

# Create branch
git checkout -b m01-work

# Complete M01 (students do this)
cd milestones/M01
# Edit main.tf, uncomment storage account
# Create terraform.tfvars from example
# terraform init && terraform plan && terraform apply

# Collect evidence
cd ../..
./scripts/collect_evidence.sh M01

# Add screenshots (manual)
# Take Azure Portal screenshots
# Save to evidence/M01/

# Submit PR
git add .
git commit -m "Complete Milestone 01: Azure fundamentals"
git push origin m01-work

# Open PR via GitHub UI
# Verify CI runs and passes ✅
```

---

## File Locations

| File | Purpose |
|------|---------|
| `README.md` | Student quickstart guide |
| `DEPLOYMENT_SUMMARY.md` | Complete deployment summary |
| `PR_DESCRIPTION.md` | Copy for PR creation |
| `docs/INTEGRATION_GUIDE.md` | ProTrack Core integration specs |
| `docs/MILESTONE_LOCKING.md` | Locking system explanation |
| `milestones/M01/main.tf` | Student's starter Terraform |
| `.github/workflows/evaluate.yml` | CI validation workflow |
| `scripts/collect_evidence.sh` | Evidence automation |

---

## Integration with ProTrack Core

### When protrack-core is ready:

1. **Create reusable workflow**: `protrack-core/.github/workflows/evaluate.yml`
2. **Update student template**: Replace placeholder scorecard job
3. **Set up secrets**: `PROTRACK_EVALUATION_TOKEN`, `PROTRACK_UNLOCK_TOKEN`
4. **Test with pilot**: Complete M01 → M02 unlock

**Full guide**: `docs/INTEGRATION_GUIDE.md`

---

## Repository Statistics

- **Files**: 25
- **Lines**: 4,449
- **Commits**: 3
- **Author**: cloudcwfranck <yakengne@gmail.com>
- **License**: MIT

---

## Support

- **Issues**: https://github.com/QuestLogicSolutions/protrack-azure-student-template/issues
- **Email**: yakengne@gmail.com

---

## What's Next?

1. ✅ **Create PR** (using PR_DESCRIPTION.md)
2. ✅ **Merge to main**
3. ✅ **Enable template** (Settings → Template repository)
4. 🔨 **Build protrack-core** (evaluation + unlock automation)
5. 🔨 **Create M02/M03 content** (store privately, inject on unlock)
6. 🧪 **Test with pilot students**
7. 🚀 **Launch to cohort**

---

**The repository is ready. Let's build great cloud engineers! 🚀**
