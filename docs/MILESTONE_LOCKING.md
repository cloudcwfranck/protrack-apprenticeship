# Milestone Locking System

ProTrack uses **milestone locking** to ensure sequential learning and prevent students from skipping foundational concepts.

This document explains how locking works, why it exists, and how to unlock new milestones.

---

## What Is Milestone Locking?

Milestone locking is a CI-enforced mechanism that prevents you from starting M02 or M03 until you've successfully completed the previous milestone.

### Current Lock Status

When you first clone this repository:

- **M01**: ✅ **UNLOCKED** (ready to start)
- **M02**: 🔒 **LOCKED** (complete M01 first)
- **M03**: 🔒 **LOCKED** (complete M02 first)

You cannot modify, deploy, or submit work for locked milestones—CI will reject your PR.

---

## Why Milestone Locking Exists

### 1. Ensures Foundational Knowledge

Cloud engineering is cumulative. You cannot understand Azure networking (M02) without first understanding resource organization and storage (M01).

Locking prevents you from:
- Skipping fundamentals
- Building on weak foundations
- Wasting time on advanced topics you're not ready for

### 2. Mirrors Real Engineering Workflows

In real engineering teams:
- Junior engineers don't jump straight to production infrastructure
- Progression is earned through demonstrated competency
- Guardrails prevent dangerous mistakes

ProTrack simulates this reality.

### 3. Maintains Evaluation Integrity

If students could skip ahead:
- They could copy advanced solutions without understanding basics
- Evaluation would be inconsistent
- The certification would lose value to employers

Locking ensures every graduate has the same foundational knowledge.

---

## How Locking Works Technically

### LOCKED Files

Locked milestones contain a special marker file:

```
milestones/M02/LOCKED
milestones/M03/LOCKED
```

**What happens if LOCKED files exist:**
- ❌ CI fails on any PR that modifies locked milestone files
- ❌ You cannot run Terraform in locked directories
- ❌ Evidence collection scripts reject locked milestones

**What happens when you try to bypass:**
```bash
# Attempting to work on M02 before completing M01
cd milestones/M02
terraform init

# Result: Error message from CI
# "M02 is LOCKED. Complete M01 first."
```

### CI Enforcement

The `.github/workflows/evaluate.yml` workflow contains a job called `check-milestone-lock`:

```yaml
- name: Check if milestone is unlocked
  run: |
    if [[ -f "milestones/$MILESTONE/LOCKED" ]]; then
      echo "ERROR: $MILESTONE is still LOCKED"
      exit 1
    fi
```

**This runs on every PR and blocks merging if:**
- LOCKED files exist in the milestone you're working on
- You try to modify files in a locked milestone

**You cannot bypass this.** Editing `.github/workflows/` to disable the check will cause different CI failures.

---

## How to Unlock Milestones

### Automatic Unlocking Process

Milestones unlock automatically when you complete the previous one. Here's the full workflow:

#### Step 1: Complete Current Milestone

For M01 specifically:

1. ✅ Write Terraform code in `milestones/M01/`
2. ✅ Fill out `docs/M01/runbook.md`
3. ✅ Collect evidence via `./scripts/collect_evidence.sh M01`
4. ✅ Deploy successfully with `terraform apply`
5. ✅ Commit all changes

#### Step 2: Submit Pull Request

```bash
git checkout -b m01-work
git add .
git commit -m "Complete Milestone 01"
git push origin m01-work
# Open PR to main
```

#### Step 3: Pass CI Validation

CI runs automatically and checks:

- ✅ Terraform syntax is valid
- ✅ Terraform formatting is correct
- ✅ Required files exist
- ✅ No secrets are committed
- ✅ Evidence is present
- ✅ Runbook is filled out

**If CI fails:**
- Read the error messages in the GitHub Actions logs
- Fix the issues locally
- Push again (CI re-runs automatically)

**If CI passes:**
- Your PR shows a green checkmark ✅
- You can request review

#### Step 4: Get Approval and Merge

Once CI passes:

1. Request review from a ProTrack evaluator (or self-review if allowed)
2. Address any feedback
3. Get approval
4. **Merge PR to main**

#### Step 5: Next Milestone Unlocks

**IMMEDIATELY after merging:**

The unlock script runs automatically (via GitHub Actions or manual script):

```bash
# This happens automatically - you don't run this
rm milestones/M02/LOCKED
git commit -m "Unlock M02 after M01 completion"
git push origin main
```

**You can now:**
- Pull the latest `main` branch
- See that `milestones/M02/LOCKED` is gone
- Start working on M02

---

## Unlocking Timeline

Here's the typical timeline for unlocking a milestone:

```
Day 1-7:   Work on M01 locally
Day 7:     Submit PR
Day 7:     CI validates (automatic, ~2-5 minutes)
Day 7-10:  Review and address feedback
Day 10:    Merge PR
Day 10:    M02 unlocks (automatic, immediate)
Day 10+:   Start M02
```

**There is no artificial delay.** As soon as your PR merges, the next milestone is available.

---

## What You Can't Do

### ❌ Manual Unlocking

**Don't try:**
```bash
# This will NOT work
rm milestones/M02/LOCKED
git commit -m "Unlock M02"
git push
```

**Why it fails:**
- CI checks the git history to verify the PREVIOUS milestone was completed
- Simply deleting LOCKED files without passing M01 evaluation will cause CI to fail

### ❌ Editing CI Workflows

**Don't try:**
```yaml
# Modifying .github/workflows/evaluate.yml to skip lock checks
# This breaks CI entirely and your PRs won't be mergeable
```

**Why it fails:**
- Workflow modifications are themselves validated
- ProTrack admins are notified of workflow changes
- Your PR will be rejected

### ❌ Working in Multiple Milestones Simultaneously

**Don't try:**
```bash
# Opening a PR with changes to both M01 and M02
git add milestones/M01/ milestones/M02/
git commit -m "Complete M01 and M02 together"
```

**Why it fails:**
- CI detects changes to locked milestones
- PR is blocked
- You must complete milestones sequentially

---

## Checking Lock Status

### Via Git

```bash
# Check if M02 is locked
ls -la milestones/M02/LOCKED

# If file exists: LOCKED
# If file doesn't exist: UNLOCKED
```

### Via GitHub

Navigate to your repository on GitHub:
- Go to `milestones/M02/`
- If you see a `LOCKED` file → milestone is locked
- If directory contains `main.tf` and no LOCKED → milestone is unlocked

### Via CI

Every PR shows lock status in the CI logs:

```
✅ M01 is always unlocked
🔒 M02 is LOCKED - complete M01 first
```

---

## FAQ

### Q: Can I start M02 while waiting for M01 review?

**A: No.** M02 only unlocks AFTER your M01 PR merges. You cannot start work early.

**Why:** Your M01 review might require significant changes that affect how you approach M02.

---

### Q: What if I find a bug in M01 after M02 unlocks?

**A: You can fix it.** Once unlocked, previous milestones remain editable.

**Process:**
```bash
git checkout -b fix-m01-bug
# Make changes to milestones/M01/
git commit -m "Fix M01 storage account naming"
git push
# Open PR - CI validates the fix
```

---

### Q: Can ProTrack admins unlock milestones manually?

**A: Yes, but only in exceptional circumstances.**

Examples:
- Repository corruption
- CI system outage preventing automatic unlock
- Instructor override for advanced students

**This is rare.** 99% of students progress through normal unlocking.

---

### Q: What if I accidentally delete a LOCKED file?

**A: Restore it immediately.**

```bash
git checkout main -- milestones/M02/LOCKED
git commit -m "Restore M02 lock file"
```

**Why:** If you push a commit that deletes LOCKED files, CI will fail validation. Restore them before opening a PR.

---

### Q: How do I know which milestone I should be working on?

**A: Check lock status and your git history.**

```bash
# See what's unlocked
ls milestones/*/LOCKED 2>/dev/null || echo "No locks found"

# Check your progress
git log --oneline | grep -i milestone
```

**Rule of thumb:**
- If you've never submitted a PR → Start M01
- If M01 is merged but M02 is locked → Wait for unlock (shouldn't take long)
- If M02/LOCKED doesn't exist → Start M02

---

### Q: Can I preview locked milestone requirements?

**A: Yes, but you can't work on them.**

You can read the LOCKED file to see when it unlocks:

```bash
cat milestones/M02/LOCKED
```

This might contain a message like:
```
This milestone is locked.
Complete M01 and merge your PR to unlock.
```

**You cannot see the full requirements until unlock.** This is intentional—it prevents you from pre-planning without foundational knowledge.

---

### Q: What happens if I try to run Terraform in a locked milestone?

**A: Local Terraform commands will work, but CI will reject your PR.**

```bash
cd milestones/M02
terraform init   # Works locally
terraform plan   # Works locally
terraform apply  # Works locally BUT...
```

When you try to submit:
```bash
git push origin m02-work
# PR opened
# CI runs: ❌ FAILS - M02 is LOCKED
# PR cannot be merged
```

**Don't waste time deploying locked milestones.** Wait for unlock.

---

## Troubleshooting

### Problem: "M02 should be unlocked but LOCKED file still exists"

**Diagnosis:**
```bash
git pull origin main
ls milestones/M02/LOCKED
```

**Solution:**
- Ensure you merged your M01 PR to `main`
- Pull latest changes: `git pull origin main`
- Check if unlock script ran (check recent commits)
- If still locked after 10 minutes, contact ProTrack support

---

### Problem: "CI says M01 is locked but it should always be unlocked"

**Diagnosis:**
This should never happen. M01 is always unlocked.

**Solution:**
- Check that you're in the right repository
- Verify you're on the right branch
- Open a GitHub issue with CI logs

---

### Problem: "I deleted LOCKED files and now CI is broken"

**Diagnosis:**
```bash
git log --oneline -5
# Shows commit deleting LOCKED files
```

**Solution:**
```bash
# Revert the deletion
git revert <commit-hash>
git push

# OR restore from main
git checkout main -- milestones/M02/LOCKED milestones/M03/LOCKED
git commit -m "Restore LOCKED files"
git push
```

---

## Summary

| Milestone | Initial State | Unlock Trigger | Unlock Method |
|-----------|---------------|----------------|---------------|
| M01 | ✅ UNLOCKED | N/A | Always available |
| M02 | 🔒 LOCKED | M01 PR merged | Automatic removal of LOCKED file |
| M03 | 🔒 LOCKED | M02 PR merged | Automatic removal of LOCKED file |

**Key Takeaway:**
- Work sequentially
- Don't try to bypass locks
- Trust the process
- Each milestone unlocks immediately after the previous one passes

---

**Questions?** Open a GitHub issue or ask in ProTrack discussions.

**Remember:** Locking exists to help you learn correctly, not to slow you down. Embrace the structure.
