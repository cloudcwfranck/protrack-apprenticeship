# How Students Use ProTrack

## For Students: Getting Started

### Step 1: Create Your Repository from Template

1. **Go to the template repository**:
   - https://github.com/QuestLogicSolutions/protrack-azure-student-template

2. **Click "Use this template"** (green button)
   - Select "Create a new repository"
   - Owner: Your GitHub username
   - Repository name: `protrack-apprenticeship` (or your choice)
   - Visibility: Public (so hiring managers can see it)
   - Click "Create repository"

3. **Clone your new repository**:
   ```bash
   git clone https://github.com/YOUR-USERNAME/protrack-apprenticeship.git
   cd protrack-apprenticeship
   ```

### Step 2: Read the Documentation (< 10 Minutes)

**Start here**: `README.md`

This tells you:
- ✅ What ProTrack is and why it matters
- ✅ What Milestone 01 proves to employers
- ✅ Exactly what to do (6-step process)
- ✅ How CI validates your work
- ✅ What you can and cannot modify

**Next read**: `docs/MILESTONE_LOCKING.md`
- Understand why M02 and M03 are locked
- Learn how unlocking works
- See the full workflow

**Important**: You should understand the entire process before writing any code.

### Step 3: Start Milestone 01

1. **Create your working branch**:
   ```bash
   git checkout -b m01-work
   ```

2. **Configure your variables**:
   ```bash
   cd milestones/M01
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your information
   ```

3. **Complete the Terraform code**:
   
   Open `main.tf` and find the TODO section:
   ```terraform
   # TODO: Create an Azure Storage Account resource
   # UNCOMMENT AND COMPLETE THE CODE BELOW
   ```

   Uncomment and complete the storage account resource as instructed.

4. **Review the runbook template**:
   ```bash
   cd ../../docs/M01
   open runbook.md  # or use your text editor
   ```

   Fill out every section marked with `TODO:`. This is graded!

### Step 4: Deploy Your Infrastructure

1. **Authenticate with Azure**:
   ```bash
   az login
   ```

2. **Initialize Terraform**:
   ```bash
   cd milestones/M01
   terraform init
   ```

3. **Plan your deployment**:
   ```bash
   terraform plan
   ```
   
   Review the output carefully. Does it match what you expect?

4. **Deploy**:
   ```bash
   terraform apply
   ```
   
   Type `yes` when prompted.

5. **Verify in Azure Portal**:
   - Go to https://portal.azure.com
   - Find your Resource Group
   - Verify all resources are deployed
   - Take screenshots (you'll need these for evidence)

### Step 5: Collect Evidence

1. **Run the evidence script**:
   ```bash
   cd ../..  # Back to repository root
   ./scripts/collect_evidence.sh M01
   ```

   This creates:
   - `evidence/M01/deployment_evidence.json`
   - `evidence/M01/SUMMARY.txt`

2. **Add manual screenshots**:
   
   Take screenshots showing:
   - Resource Group overview
   - Storage Account configuration
   - Security settings (HTTPS, TLS version)
   
   Save to `evidence/M01/` with descriptive names:
   ```bash
   evidence/M01/screenshot_resource_group.png
   evidence/M01/screenshot_storage_account.png
   evidence/M01/screenshot_security.png
   ```

3. **Verify no secrets**:
   ```bash
   # Check for accidentally exposed secrets
   grep -r "key" evidence/M01/deployment_evidence.json
   # Should show "REDACTED" for sensitive fields
   ```

### Step 6: Submit Your Work

1. **Commit everything**:
   ```bash
   git add .
   git commit -m "Complete Milestone 01: Azure fundamentals

   - Deployed Resource Group and Storage Account
   - Completed runbook with architecture decisions
   - Collected deployment evidence with screenshots
   - All security checks passed"
   ```

2. **Push your branch**:
   ```bash
   git push origin m01-work
   ```

3. **Open a Pull Request**:
   - Go to your repository on GitHub
   - Click "Pull requests" → "New pull request"
   - Base: `main`, Compare: `m01-work`
   - Fill out the PR template (it auto-populates)
   - Click "Create pull request"

### Step 7: Respond to CI Feedback

**CI runs automatically** when you open the PR. It checks:

✅ Terraform formatting and validation
✅ Required files exist
✅ No secrets committed
✅ Evidence is complete
✅ Milestone locking (you're not trying to skip ahead)

**If CI fails**:
1. Click "Details" next to the failed check
2. Read the error message
3. Fix the issue locally
4. Commit and push again
5. CI re-runs automatically

**Common failures**:
- "Terraform not formatted" → Run `terraform fmt -recursive`
- "Missing evidence" → Run `./scripts/collect_evidence.sh M01`
- "Runbook has TODOs" → Complete all TODO sections
- "Secrets detected" → Remove secrets, regenerate evidence

### Step 8: Merge and Unlock M02

**Once CI passes**:
1. Request review (if required by your program)
2. Address any feedback
3. Get approval
4. **Merge your PR**

**What happens after merge**:
- ✅ M02 automatically unlocks
- ✅ You receive a notification
- ✅ `milestones/M02/LOCKED` file disappears
- ✅ M02 content becomes visible

**Start M02**:
```bash
git checkout main
git pull origin main
# Verify M02 is unlocked
ls milestones/M02/  # Should see .tf files, not LOCKED
git checkout -b m02-work
# Repeat the process for M02!
```

---

## Common Student Questions

### Q: Can I work on M02 while waiting for M01 review?

**A: No.** M02 only unlocks AFTER your M01 PR merges. Use the waiting time to:
- Improve your M01 documentation
- Add more screenshots
- Clean up your commit history
- Review Azure best practices

### Q: What if I mess up my deployment?

**A: Just redeploy!**

```bash
cd milestones/M01
terraform destroy  # Remove everything
# Fix your code
terraform apply    # Deploy again
cd ../..
./scripts/collect_evidence.sh M01  # Re-collect evidence
```

Evidence must match your final deployment.

### Q: Can I skip the runbook?

**A: No.** The runbook is **30% of your grade**. It proves you understand:
- Why you made architectural decisions
- How to think about security
- How to explain your work to other engineers

Employers care MORE about your documentation than your Terraform code.

### Q: What if CI keeps failing?

**Troubleshooting steps**:

1. **Read the full error message** (don't skim)
2. **Check the specific failed job** in GitHub Actions
3. **Look at the logs** (expand the failed step)
4. **Fix locally first** (don't trial-and-error on CI)
5. **Ask for help** (open an issue with error details)

### Q: How long does M01 take?

**Typical timeline**:
- Understanding requirements: 1-2 hours
- Writing Terraform: 2-4 hours
- Deploying and testing: 1-2 hours
- Documentation: 3-5 hours
- Evidence collection: 30 minutes
- Responding to CI: 1-2 hours

**Total: 8-15 hours** depending on experience level.

### Q: Can I use the Azure Portal instead of Terraform?

**A: No.** ProTrack requires Infrastructure as Code (IaC):
- ✅ Repeatable
- ✅ Versionable
- ✅ Reviewable
- ✅ Matches real engineering practices

Manual portal clicks don't count.

### Q: What if I don't have an Azure subscription?

**Options**:
1. **Azure for Students**: $100 free credit (no credit card)
   - https://azure.microsoft.com/en-us/free/students/
2. **Azure Free Tier**: $200 credit for 30 days
   - https://azure.microsoft.com/en-us/free/
3. **GitHub Student Developer Pack**: Includes Azure credits
   - https://education.github.com/pack

M01 costs approximately $1-2/month, so $100 covers the entire program.

---

## After Completing All Milestones

### Your Portfolio

Once you complete M01, M02, and M03, you have:

**1. A public GitHub repository** showing:
- Real Azure infrastructure code
- Production-quality documentation
- Architecture decision records
- Security considerations
- Cost analysis

**2. Verifiable evidence** that you can:
- Design cloud architecture
- Write Infrastructure as Code
- Think about security, cost, and reliability
- Document like a senior engineer
- Use professional workflows (Git, CI/CD)

**3. A URL to put on your resume**:
```
https://github.com/YOUR-USERNAME/protrack-apprenticeship
```

### Showcasing Your Work

**On your resume**:
```
Cloud Engineering Apprenticeship (ProTrack)
- Designed and deployed production-grade Azure infrastructure using Terraform
- Implemented security best practices (HTTPS-only, TLS 1.2+, least privilege)
- Documented architecture decisions and deployment procedures
- Completed CI/CD workflows with automated validation
- Repository: github.com/YOUR-USERNAME/protrack-apprenticeship
```

**In interviews**:
- Walk through your runbook
- Explain design decisions
- Demonstrate security thinking
- Show your Terraform code
- Discuss tradeoffs you considered

**Hiring managers can verify**:
- Your commits are real (not copy-paste)
- You understand what you built
- You follow professional practices
- You can document complex systems

---

## Getting Help

### Before Asking

1. ✅ Read the error message completely
2. ✅ Check `README.md` and relevant docs
3. ✅ Search existing issues
4. ✅ Review `docs/MILESTONE_LOCKING.md`

### Where to Ask

**GitHub Issues** (in your repository):
- Technical problems
- CI failures
- Evidence collection issues

**ProTrack Discussions** (if available):
- General questions
- Clarifications on requirements
- Best practice advice

### How to Ask Good Questions

**Bad question**:
> "It doesn't work, help!"

**Good question**:
> "I'm getting this Terraform error when running `terraform apply`:
> ```
> Error: storage account name must be globally unique
> ```
> I'm using the name pattern `protrack-dev-jsmith-sa` but it's still failing.
> Here's my relevant code: [code snippet]
> What am I missing?"

**Include**:
- What you're trying to do
- What you expected
- What actually happened
- Error messages (full text)
- Code snippets (if relevant)

---

## Success Tips

1. **Start early** - Don't wait until the deadline
2. **Read everything** - The docs have answers
3. **Test locally** - Don't debug on CI
4. **Document as you go** - Don't save runbook for last
5. **Ask questions** - Better early than stuck
6. **Take screenshots** - Evidence is required
7. **No secrets** - Always double-check
8. **Think like an engineer** - Explain your WHY

---

**You've got this! Welcome to ProTrack. 🚀**

Time to build something hiring managers will notice.
