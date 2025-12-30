# ProTrack: Azure Cloud Engineering Apprenticeship

**ProTrack** is a CI-validated, milestone-based apprenticeship platform that proves real-world cloud engineering competency to hiring managers. This repository is your **student workspace** where you'll build, document, and demonstrate production-grade Azure infrastructure skills.

## What Milestone 01 Proves

By completing M01, you demonstrate to potential employers that you can:
- Design and deploy Azure infrastructure using Terraform
- Document architecture decisions like a senior engineer
- Capture evidence of working deployments
- Follow enterprise CI/CD workflows
- Think critically about security, cost, and reliability

**This isn't a tutorial.** It's a portfolio piece.

---

## How ProTrack Works

```
Clone Repo → Work on Branch → Build Infrastructure → Document Everything
     ↓
Submit PR → CI Validates → Review Feedback → Merge
     ↓
Next Milestone Unlocks
```

### Milestone Locking
- **M01** is open and ready for you to start
- **M02** and **M03** are **LOCKED** until you pass M01
- You cannot skip ahead—CI enforces sequential completion
- See [MILESTONE_LOCKING.md](docs/MILESTONE_LOCKING.md) for details

---

## 🚀 Student Quickstart

### Prerequisites
- GitHub account
- Azure subscription (free student tier works)
- Terraform >= 1.6 installed locally
- Basic Git knowledge

### Step-by-Step Instructions

#### 1. Clone This Repository
```bash
git clone https://github.com/YOUR-USERNAME/protrack-azure-student-template.git
cd protrack-azure-student-template
```

#### 2. Create Your Working Branch
```bash
git checkout -b m01-work
```

#### 3. Complete Milestone 01

**A) Write Terraform Code**
- Navigate to `milestones/M01/`
- Complete the TODO sections in the Terraform files
- Your infrastructure must include:
  - 1 Resource Group
  - 1 Storage Account (with secure defaults)
  - Proper tagging and naming conventions

**B) Document Your Work**
- Fill out `docs/M01/runbook.md` with:
  - Architecture decisions
  - Security considerations
  - Deployment steps
  - Troubleshooting guidance
- **This is graded.** Treat it like a real engineer handoff.

**C) Collect Evidence**
- Run the evidence collection script:
  ```bash
  ./scripts/collect_evidence.sh M01
  ```
- This captures screenshots and deployment state
- Evidence is saved to `evidence/M01/`

**D) Test Locally**
```bash
cd milestones/M01
terraform init
terraform plan
terraform apply
```

#### 4. Submit Your Work
```bash
git add .
git commit -m "Complete Milestone 01: Azure fundamentals"
git push origin m01-work
```

Open a Pull Request to `main`.

#### 5. Read CI Feedback
- CI runs automatically on your PR
- It validates:
  - Terraform syntax and structure
  - Required files are present
  - Milestone locking rules
  - Evidence completeness
- **Fix any errors** before requesting review

#### 6. Merge and Unlock
- Once CI passes and your PR is approved, merge it
- **M02 automatically unlocks**
- Repeat the process for the next milestone

---

## 📁 Repository Structure

```
.github/workflows/       # CI automation (DO NOT MODIFY)
milestones/
  M01/                   # ← START HERE
    main.tf              # Your Terraform code
    variables.tf         # Input variables
    outputs.tf           # Output values
    versions.tf          # Provider constraints
    terraform.tfvars.example
  M02/LOCKED             # Unlocks after M01 passes
  M03/LOCKED             # Unlocks after M02 passes

docs/
  M01/runbook.md         # Your architecture documentation
  M02/                   # Unlocks later
  M03/                   # Unlocks later
  MILESTONE_LOCKING.md   # How unlocking works

evidence/
  M01/                   # Auto-generated evidence goes here
  M02/
  M03/

scripts/
  collect_evidence.sh    # Generates deployment proof
```

### What Belongs Where

| Directory | Purpose | Student Edits? |
|-----------|---------|----------------|
| `milestones/M0X/` | Your Terraform infrastructure code | ✅ YES |
| `docs/M0X/` | Architecture documentation and runbooks | ✅ YES |
| `evidence/M0X/` | Auto-generated deployment screenshots | ❌ Auto-generated |
| `.github/workflows/` | CI validation logic | ❌ NO—will break CI |
| `scripts/` | Helper scripts for evidence collection | ❌ Read-only |

---

## 🚨 Do Not Delete or Modify

### Protected Files and Folders
The following are **enforced by CI** and must not be altered:

- `.github/workflows/` — CI logic lives in `protrack-core`, not here
- `LOCKED` files — Milestone gates that unlock automatically
- `scripts/` directory structure — Evidence automation depends on this
- Terraform version constraints in `versions.tf`

### Why CI Enforcement?
- **Prevents skipping milestones** — You can't learn M03 without M01 foundations
- **Ensures consistency** — All students are evaluated fairly
- **Mirrors real engineering** — Production workflows have guardrails too

**Attempting to bypass these restrictions will fail CI and block your PR.**

---

## CI Validation

Every PR triggers automated checks:

✅ **Terraform Validation**
- Syntax is correct (`terraform validate`)
- Formatting follows standards (`terraform fmt`)
- Required resources are present

✅ **Structure Validation**
- Required files exist (runbook, evidence, outputs)
- Milestone locking is respected
- No prohibited files are committed (secrets, `.tfstate`)

✅ **Evidence Validation**
- Evidence files are present for the milestone
- Screenshots show successful deployment

### What Happens If CI Fails?
- Your PR is blocked from merging
- Read the CI logs to see what failed
- Fix the issues and push again
- CI re-runs automatically

---

## Azure Configuration

All milestones use:
- **Region**: `eastus2` (cost-optimized)
- **Provider**: Azure (`azurerm`)
- **Authentication**: GitHub OIDC (no credentials in code)

### Local Development
For local testing, authenticate with Azure CLI:
```bash
az login
```

### CI Authentication
CI uses GitHub's OIDC integration with Azure—no secrets required.

---

## Evidence Collection

Evidence proves your infrastructure is real and working.

### When to Collect Evidence
- After `terraform apply` succeeds
- Before destroying resources
- Before submitting your PR

### How to Collect Evidence
```bash
./scripts/collect_evidence.sh M01
```

This script:
1. Captures Azure portal screenshots (if available)
2. Exports Terraform state metadata
3. Records resource IDs and outputs
4. Saves everything to `evidence/M01/`

**Never commit secrets or credentials.** The script filters these automatically.

---

## Getting Help

### Before Asking for Help
1. Read the error message carefully
2. Check the CI logs for specific failures
3. Review `docs/MILESTONE_LOCKING.md`
4. Verify your Terraform syntax locally

### Where to Get Help
- **Issues**: Open a GitHub issue in this repo
- **Discussions**: Check the ProTrack community board
- **CI Errors**: Read the workflow run logs (link in your PR)

---

## Grading Criteria

Each milestone is evaluated on:

| Category | Weight | What We Look For |
|----------|--------|------------------|
| **Terraform Quality** | 40% | Correct syntax, best practices, security |
| **Documentation** | 30% | Clear runbook, architecture decisions, diagrams |
| **Evidence** | 20% | Complete screenshots, deployment proof |
| **Process** | 10% | Clean Git history, PR description quality |

**Aim for production quality, not just passing CI.**

---

## Philosophy

ProTrack is designed around one principle: **If you can't document it and deploy it repeatably, you don't understand it.**

- We don't give you step-by-step instructions
- We give you requirements and let you architect
- We validate outcomes, not process
- We prepare you for real engineering teams

This is hard by design. That's what makes it valuable.

---

## Next Steps

1. Read `docs/M01/runbook.md` to understand requirements
2. Review `milestones/M01/main.tf` to see what's expected
3. Create your working branch: `git checkout -b m01-work`
4. Start building

**Welcome to ProTrack. Show us what you can build.**
