# ProTrack Core Integration Plan

## Current Status

**Student Template**: ✅ **READY** (on main branch, CI passing)
**ProTrack Core**: ❌ **Does not exist yet** (404 error)

---

## How It Works TODAY (Without protrack-core)

### What Students Can Do NOW

Students can **immediately start using the template**:

1. **Click "Use this template"** → Create their own repository
2. **Complete M01** with full guidance
3. **Submit PR** → CI validates automatically
4. **Get feedback** → Fix issues based on CI errors
5. **Manual review** → Administrator reviews and grades
6. **Manual unlock** → Administrator removes M02 LOCKED files

**What works automatically**:
- ✅ Terraform validation
- ✅ File structure checks
- ✅ Security scanning
- ✅ Evidence validation
- ✅ Milestone lock enforcement

**What requires manual work**:
- ⚠️ Grading (no scorecard generated)
- ⚠️ Unlocking M02/M03 (admin must manually remove LOCKED files)
- ⚠️ Detailed feedback (just pass/fail from CI)

---

## How It Will Work WITH protrack-core

### What protrack-core Should Provide

**Repository**: `https://github.com/QuestLogicSolutions/protrack-core`

**Purpose**: Centralized evaluation and automation logic

**Structure**:
```
protrack-core/
├── .github/
│   └── workflows/
│       ├── evaluate.yml          # Reusable grading workflow
│       └── unlock-milestone.yml  # Automatic unlock on PR merge
├── evaluators/
│   ├── terraform_quality.py      # Analyzes Terraform code
│   ├── documentation.py          # Scores runbook quality
│   ├── evidence.py               # Validates evidence
│   └── security.py               # Security checks
├── scorecards/
│   └── templates/                # Scorecard markdown templates
├── milestone-content/            # M02/M03 content to inject
│   ├── M02/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── runbook.md
│   └── M03/
│       ├── main.tf
│       ├── variables.tf
│       └── runbook.md
└── README.md
```

---

## Integration Architecture

### Student Repository Flow

```
Student creates PR (m01-work → main)
         ↓
.github/workflows/evaluate.yml runs
         ↓
┌─────────────────────────────────────┐
│ Local Validation (in student repo) │
│ - Terraform fmt/validate            │
│ - File structure check              │
│ - Security scan                     │
│ - Milestone lock check              │
└─────────────────────────────────────┘
         ↓
         ✅ All local checks pass
         ↓
┌─────────────────────────────────────┐
│ Call protrack-core evaluator        │
│ (reusable workflow)                 │
└─────────────────────────────────────┘
         ↓
protrack-core/.github/workflows/evaluate.yml
         ↓
┌─────────────────────────────────────┐
│ Detailed Evaluation                 │
│ - Grade Terraform (40 pts)          │
│ - Grade documentation (30 pts)      │
│ - Grade evidence (20 pts)           │
│ - Grade process (10 pts)            │
└─────────────────────────────────────┘
         ↓
┌─────────────────────────────────────┐
│ Generate Scorecard                  │
│ - Total score /100                  │
│ - Pass/Fail (70+ = pass)            │
│ - Detailed feedback                 │
└─────────────────────────────────────┘
         ↓
Post scorecard as PR comment
         ↓
Student sees detailed grading
         ↓
Student merges PR (if passing)
         ↓
┌─────────────────────────────────────┐
│ Post-merge webhook triggers         │
│ protrack-core unlock workflow       │
└─────────────────────────────────────┘
         ↓
protrack-core/.github/workflows/unlock-milestone.yml
         ↓
┌─────────────────────────────────────┐
│ Automatic Unlock                    │
│ 1. Detect completed milestone       │
│ 2. Remove LOCKED files              │
│ 3. Inject M02 content               │
│ 4. Commit to student's main         │
│ 5. Create notification issue        │
└─────────────────────────────────────┘
         ↓
Student sees M02 unlocked
```

---

## Implementation Steps

### Phase 1: Create protrack-core Repository

```bash
# Create repository
gh repo create QuestLogicSolutions/protrack-core --private --clone

cd protrack-core

# Create structure
mkdir -p .github/workflows evaluators scorecards/templates milestone-content/{M02,M03}
```

### Phase 2: Implement Reusable Evaluator

**File**: `.github/workflows/evaluate.yml`

```yaml
name: ProTrack Evaluator

on:
  workflow_call:
    inputs:
      milestone:
        required: true
        type: string
      student_repo:
        required: true
        type: string
      pr_number:
        required: true
        type: number
    secrets:
      evaluation_token:
        required: true
    outputs:
      score:
        description: "Total score (0-100)"
        value: ${{ jobs.evaluate.outputs.score }}
      passed:
        description: "Pass/fail (70+ passes)"
        value: ${{ jobs.evaluate.outputs.passed }}

jobs:
  evaluate:
    runs-on: ubuntu-latest
    outputs:
      score: ${{ steps.grade.outputs.score }}
      passed: ${{ steps.grade.outputs.passed }}

    steps:
      - name: Checkout protrack-core
        uses: actions/checkout@v4

      - name: Checkout student repository
        uses: actions/checkout@v4
        with:
          repository: ${{ inputs.student_repo }}
          ref: refs/pull/${{ inputs.pr_number }}/head
          token: ${{ secrets.evaluation_token }}
          path: student-repo

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          pip install pyyaml jinja2 markdown

      - name: Run Terraform quality evaluation
        id: terraform
        run: |
          python evaluators/terraform_quality.py \
            --repo student-repo \
            --milestone ${{ inputs.milestone }} \
            --output terraform_score.json

      - name: Run documentation evaluation
        id: docs
        run: |
          python evaluators/documentation.py \
            --repo student-repo \
            --milestone ${{ inputs.milestone }} \
            --output docs_score.json

      - name: Run evidence evaluation
        id: evidence
        run: |
          python evaluators/evidence.py \
            --repo student-repo \
            --milestone ${{ inputs.milestone }} \
            --output evidence_score.json

      - name: Calculate total score
        id: grade
        run: |
          python -c "
          import json

          with open('terraform_score.json') as f:
              tf = json.load(f)
          with open('docs_score.json') as f:
              docs = json.load(f)
          with open('evidence_score.json') as f:
              ev = json.load(f)

          total = tf['score'] + docs['score'] + ev['score']
          passed = total >= 70

          print(f'score={total}')
          print(f'passed={str(passed).lower()}')
          " >> $GITHUB_OUTPUT

      - name: Generate scorecard
        run: |
          python -c "
          import json
          from jinja2 import Template

          # Load scores
          with open('terraform_score.json') as f:
              tf = json.load(f)
          with open('docs_score.json') as f:
              docs = json.load(f)
          with open('evidence_score.json') as f:
              ev = json.load(f)

          total = tf['score'] + docs['score'] + ev['score']

          # Generate markdown
          scorecard = f'''# ProTrack Evaluation Results - ${{ inputs.milestone }}

## Overall Score: {total}/100

**Status**: {'✅ PASSED' if total >= 70 else '❌ FAILED'}

---

## Category Breakdown

### Terraform Quality: {tf['score']}/40

{tf['feedback']}

### Documentation: {docs['score']}/30

{docs['feedback']}

### Evidence: {ev['score']}/20

{ev['feedback']}

---

## Next Steps

{'✅ Your PR is ready to merge! After merging, the next milestone will unlock automatically.' if total >= 70 else '❌ Please address the feedback above and push updates. CI will re-run automatically.'}

---

**Evaluated by**: ProTrack Core v1.0
**Timestamp**: $(date -u +"%Y-%m-%d %H:%M:%S UTC")
'''

          with open('scorecard.md', 'w') as f:
              f.write(scorecard)
          "

      - name: Post scorecard as PR comment
        uses: actions/github-script@v7
        with:
          github-token: ${{ secrets.evaluation_token }}
          script: |
            const fs = require('fs');
            const scorecard = fs.readFileSync('scorecard.md', 'utf8');

            const [owner, repo] = '${{ inputs.student_repo }}'.split('/');

            await github.rest.issues.createComment({
              owner: owner,
              repo: repo,
              issue_number: ${{ inputs.pr_number }},
              body: scorecard
            });
```

### Phase 3: Update Student Template

**Modify**: `protrack-azure-student-template/.github/workflows/evaluate.yml`

**Change the `generate-scorecard` job to**:

```yaml
  generate-scorecard:
    name: Generate Scorecard
    needs: [detect-milestone, terraform-validate, check-required-files, security-scan]
    if: github.event_name == 'pull_request'
    uses: QuestLogicSolutions/protrack-core/.github/workflows/evaluate.yml@main
    with:
      milestone: ${{ needs.detect-milestone.outputs.milestone }}
      student_repo: ${{ github.repository }}
      pr_number: ${{ github.event.pull_request.number }}
    secrets:
      evaluation_token: ${{ secrets.PROTRACK_EVALUATION_TOKEN }}
```

### Phase 4: Implement Unlock Automation

**File**: `protrack-core/.github/workflows/unlock-milestone.yml`

See full example in: `docs/INTEGRATION_GUIDE.md`

### Phase 5: Set Up Secrets

**In GitHub Organization Settings**:

```
Settings → Secrets and variables → Actions → New organization secret

Name: PROTRACK_EVALUATION_TOKEN
Value: <GitHub PAT with repo scope>

Name: PROTRACK_UNLOCK_TOKEN
Value: <GitHub PAT with repo write scope>
```

These secrets allow protrack-core to:
- Read student repositories for evaluation
- Write to student repositories for unlocking

---

## Testing Integration

### Test with Pilot Student

1. **Create test student repository**:
   ```bash
   # Student uses template
   # Go to template repo → "Use this template"
   # Creates: username/protrack-test
   ```

2. **Complete M01**:
   ```bash
   git clone https://github.com/username/protrack-test
   cd protrack-test
   git checkout -b m01-work
   # Complete M01...
   git push origin m01-work
   ```

3. **Open PR** → Triggers evaluation

4. **Verify**:
   - ✅ Local CI checks pass (in student repo)
   - ✅ protrack-core evaluator is called
   - ✅ Scorecard appears as PR comment
   - ✅ Score is accurate

5. **Merge PR** → Triggers unlock

6. **Verify**:
   - ✅ M02 LOCKED files removed
   - ✅ M02 content injected
   - ✅ Notification issue created
   - ✅ Student can pull and start M02

---

## Current Workaround (Manual Process)

### Until protrack-core is built:

**For Grading**:
1. Student submits PR
2. CI validates structure
3. **Administrator manually reviews**:
   - Read Terraform code
   - Review runbook
   - Check evidence
   - Assign score using rubric in `docs/M01/runbook.md`
4. **Leave PR comment** with score and feedback
5. Student addresses feedback or merges

**For Unlocking**:
1. Student's M01 PR is merged
2. **Administrator manually unlocks**:
   ```bash
   # Clone student's repository
   git clone https://github.com/student/protrack-apprenticeship
   cd protrack-apprenticeship
   git checkout main

   # Remove LOCKED files
   rm milestones/M02/LOCKED docs/M02/LOCKED

   # Add M02 content (if ready)
   # cp -r /path/to/M02/content/* milestones/M02/

   # Commit and push
   git add .
   git commit -m "Unlock M02 after M01 completion"
   git push origin main

   # Notify student
   gh issue create --title "M02 Unlocked!" --body "Congratulations..."
   ```

This works but **doesn't scale** beyond a few students.

---

## Timeline

### Immediate (Week 1)
- ✅ Student template is live
- ✅ Students can start M01
- ⚠️ Manual grading required
- ⚠️ Manual unlocking required

### Short-term (Week 2-3)
- 🔨 Build protrack-core repository
- 🔨 Implement evaluator workflow
- 🔨 Create M02/M03 content
- 🧪 Test with pilot students

### Medium-term (Week 4-6)
- 🚀 Deploy automated grading
- 🚀 Deploy automated unlocking
- 📊 Monitor first cohort
- 🔄 Iterate based on feedback

---

## Required Effort

### To build protrack-core:

**Evaluator Logic** (20-30 hours):
- Python scripts for grading
- Terraform quality checks
- Documentation scoring
- Evidence validation

**Workflows** (10-15 hours):
- Reusable evaluation workflow
- Unlock automation
- Testing and debugging

**Content Creation** (40-60 hours):
- M02 requirements and Terraform
- M03 requirements and Terraform
- Runbook templates
- Evidence guides

**Total**: ~70-105 hours of development

---

## Summary

### Current State
✅ **Students can use the template TODAY**
✅ **All validation works automatically**
⚠️ **Grading and unlocking are manual**

### Future State (with protrack-core)
✅ **Everything automated**
✅ **Detailed scorecards generated**
✅ **Instant unlock on PR merge**
✅ **Scales to hundreds of students**

### Bridge Strategy
1. Launch with manual grading (works for <10 students)
2. Build protrack-core in parallel
3. Test with pilot cohort
4. Roll out automation to all students

---

**The student template is production-ready. The core can be built iteratively.**
