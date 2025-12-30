# Contributing to ProTrack Student Repository

This repository is your personal workspace for completing ProTrack milestones.

## For Students

### How to Work on Milestones

1. **Create a Branch for Each Milestone**
   ```bash
   git checkout -b m01-work
   ```

2. **Complete the Milestone Requirements**
   - Write Terraform code
   - Fill out documentation
   - Collect evidence

3. **Commit Your Work**
   ```bash
   git add .
   git commit -m "Complete Milestone 01: Azure fundamentals"
   ```

4. **Push and Open PR**
   ```bash
   git push origin m01-work
   # Open PR via GitHub UI
   ```

5. **Address CI Feedback**
   - Read error messages carefully
   - Fix issues locally
   - Push again (CI re-runs automatically)

### Commit Message Guidelines

**Good commit messages**:
- `Complete M01 Terraform configuration`
- `Add M01 runbook with architecture decisions`
- `Fix storage account naming convention`
- `Add M01 deployment evidence`

**Bad commit messages**:
- `changes`
- `fix stuff`
- `asdf`
- `WIP`

**Format**: Use imperative mood (e.g., "Add feature" not "Added feature")

### Branch Naming Convention

**Required pattern**: `m0X-*` where X is the milestone number

**Examples**:
- `m01-work`
- `m01-initial-deployment`
- `m02-networking`
- `m03-final`

**Why**: CI detects which milestone you're working on from the branch name.

### What You Can Modify

✅ **You SHOULD edit**:
- `milestones/M0X/*.tf` - Your Terraform code
- `docs/M0X/runbook.md` - Your documentation
- `terraform.tfvars` - Your local variables (but don't commit this)

❌ **You MUST NOT edit**:
- `.github/workflows/` - CI logic (will break validation)
- `scripts/` - Evidence collection scripts
- `LOCKED` files - Milestone gates
- `.gitignore` - Security rules

⚠️ **Edit with caution**:
- `README.md` - OK to add personal notes at the bottom
- `CONTRIBUTING.md` - This file (but why?)

### Security Rules

**NEVER commit**:
- Terraform state files (`.tfstate`)
- Variable files with secrets (`terraform.tfvars`)
- Azure credentials
- Storage account keys
- Connection strings
- Passwords or tokens

**Before every commit**:
```bash
# Check what you're committing
git diff --staged

# Verify no secrets
git diff --staged | grep -i -E "(password|secret|key|token)"
```

**If you accidentally commit secrets**:
1. DO NOT just delete the file in a new commit (secret is still in history)
2. Immediately rotate/regenerate the secret in Azure
3. Remove from git history:
   ```bash
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch path/to/file" \
     --prune-empty --tag-name-filter cat -- --all
   ```
4. Force push: `git push origin --force --all`
5. Notify ProTrack administrators

### Getting Help

**Before asking for help**:
1. Read the error message completely
2. Check CI logs in GitHub Actions
3. Review `README.md` and `docs/MILESTONE_LOCKING.md`
4. Search existing GitHub issues

**Where to ask**:
- GitHub Issues (for bugs or unclear requirements)
- ProTrack Discussions (for general questions)
- PR comments (for review-specific questions)

**How to ask**:
- Provide context (what milestone, what you tried)
- Include error messages (full text, not paraphrased)
- Show your code (use code blocks)
- Explain what you expected vs. what happened

---

## For ProTrack Administrators

### Repository Maintenance

This is a template repository. Students fork/clone it to start their journey.

**When updating the template**:
1. Test changes in a separate student fork first
2. Ensure CI workflows still function
3. Update documentation to reflect changes
4. Bump version numbers in scripts

### CI Workflow Updates

**Location**: `.github/workflows/evaluate.yml`

**Before modifying**:
- Workflows are shared across all student repos
- Breaking changes affect all active students
- Test thoroughly in a staging environment

**After modifying**:
- Document changes in workflow comments
- Update `README.md` if student-facing behavior changes
- Announce breaking changes to students

### Adding New Milestones

**To add M04, M05, etc.**:

1. Create directory structure:
   ```bash
   mkdir -p milestones/M04 docs/M04 evidence/M04
   ```

2. Create LOCKED file:
   ```bash
   # Copy from M02/M03 and update milestone numbers
   ```

3. Update CI workflow to recognize new milestone

4. Update documentation:
   - `README.md`
   - `docs/MILESTONE_LOCKING.md`
   - Evidence scripts

5. Test full workflow before release

### Unlocking Milestones

**Manual unlock (emergency use only)**:

```bash
# Student completed M01, but auto-unlock failed
rm milestones/M02/LOCKED
rm docs/M02/LOCKED
git add .
git commit -m "Manual unlock: M02 for student-id (M01 completion verified)"
git push origin main
```

**Criteria for manual unlock**:
- Student's M01 PR is merged
- CI validation passed
- Auto-unlock script failed (system issue, not student issue)
- Unlock is approved by ProTrack admin

### Handling Plagiarism

If you suspect plagiarism:

1. Compare suspicious submission against known solutions
2. Check git history for unusual patterns (large commits, copy-paste timestamps)
3. Review student's PR history (do they understand their own code?)
4. Use code similarity tools (e.g., MOSS, JPlag)

**If confirmed**:
- Close the PR with explanation
- Mark milestone as incomplete
- Follow ProTrack academic integrity policy

### Support & Issues

**Student-facing issues**:
- Respond within 24-48 hours
- Provide guidance, not solutions
- Point to documentation when applicable

**System issues** (CI failures, bugs):
- Prioritize based on number of affected students
- Fix in template first, then notify students to re-sync
- Document workarounds if fix will take time

---

## Code of Conduct

### Expected Behavior

- **Respect**: Treat all students and administrators professionally
- **Honesty**: Do your own work, cite sources when used
- **Collaboration**: Help others learn, but don't do their work for them
- **Integrity**: Report bugs and issues, don't exploit them

### Unacceptable Behavior

- **Plagiarism**: Copying code from other students
- **Cheating**: Bypassing milestone locks or CI checks
- **Harassment**: Disrespectful communication
- **Sabotage**: Intentionally breaking shared resources

### Consequences

Violations result in:
1. Warning (first minor offense)
2. Milestone marked incomplete (repeated offenses)
3. Removal from ProTrack (serious violations)

---

## License

This repository is licensed under [LICENSE TYPE].

Student submissions remain the intellectual property of the student but grant ProTrack rights to evaluate and display as portfolio pieces.

---

## Questions?

- **Students**: Open a GitHub issue or ask in discussions
- **Administrators**: Contact ProTrack core team

---

**Thank you for being part of ProTrack. Let's build great engineers together.**
