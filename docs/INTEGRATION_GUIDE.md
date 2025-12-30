# ProTrack Core Integration Guide

This document explains how to integrate `protrack-azure-student-template` with `protrack-core` for automated evaluation and milestone unlocking.

## Overview

The student template repository handles:
- ✅ Milestone locking enforcement
- ✅ Terraform validation
- ✅ File structure validation
- ✅ Security scanning

The core repository (`protrack-core`) should handle:
- 📊 Grading and scoring
- 📝 Detailed evaluation feedback
- 🔓 Milestone unlock automation
- 📈 Progress tracking

---

## Integration Points

### 1. Reusable Evaluation Workflow

**Location**: `protrack-core/.github/workflows/evaluate.yml`

**Purpose**: Centralized evaluation logic called by student repositories

**Expected Interface**:

```yaml
name: ProTrack Core Evaluator

on:
  workflow_call:
    inputs:
      milestone:
        description: 'Milestone being evaluated (M01, M02, M03)'
        required: true
        type: string
      student_repo:
        description: 'Student repository name (org/repo)'
        required: true
        type: string
      pr_number:
        description: 'Pull request number'
        required: true
        type: number
      student_id:
        description: 'Student identifier'
        required: false
        type: string
    secrets:
      evaluation_token:
        description: 'GitHub token for accessing student repo'
        required: true
    outputs:
      score:
        description: 'Total score (0-100)'
        value: ${{ jobs.evaluate.outputs.score }}
      passed:
        description: 'Whether student passed (score >= 70)'
        value: ${{ jobs.evaluate.outputs.passed }}
      feedback:
        description: 'Detailed evaluation feedback'
        value: ${{ jobs.evaluate.outputs.feedback }}

jobs:
  evaluate:
    runs-on: ubuntu-latest
    outputs:
      score: ${{ steps.grade.outputs.score }}
      passed: ${{ steps.grade.outputs.passed }}
      feedback: ${{ steps.grade.outputs.feedback }}

    steps:
      - name: Checkout student repository
        uses: actions/checkout@v4
        with:
          repository: ${{ inputs.student_repo }}
          ref: ${{ github.event.pull_request.head.sha }}
          token: ${{ secrets.evaluation_token }}

      - name: Run evaluation
        id: grade
        run: |
          # Your evaluation logic here
          # This should analyze:
          # - Terraform code quality
          # - Documentation completeness
          # - Evidence quality
          # - Security compliance

          # Output score and feedback
          echo "score=85" >> $GITHUB_OUTPUT
          echo "passed=true" >> $GITHUB_OUTPUT
          echo "feedback=Well done!" >> $GITHUB_OUTPUT

      - name: Post results as PR comment
        uses: actions/github-script@v7
        with:
          github-token: ${{ secrets.evaluation_token }}
          script: |
            github.rest.issues.createComment({
              owner: context.repo.owner,
              repo: context.repo.repo,
              issue_number: ${{ inputs.pr_number }},
              body: `## ProTrack Evaluation Results\n\n**Score**: ${{ steps.grade.outputs.score }}/100\n\n**Status**: ${{ steps.grade.outputs.passed == 'true' && '✅ PASSED' || '❌ FAILED' }}\n\n${{ steps.grade.outputs.feedback }}`
            })
```

### 2. Student Template Integration

**File**: `.github/workflows/evaluate.yml` (in student template)

**Update the `generate-scorecard` job**:

```yaml
generate-scorecard:
  name: Generate Scorecard
  runs-on: ubuntu-latest
  needs: [detect-milestone, terraform-validate, check-required-files, security-scan]
  if: github.event_name == 'pull_request'

  steps:
    - name: Call ProTrack Core Evaluator
      uses: QuestLogicSolutions/protrack-core/.github/workflows/evaluate.yml@main
      with:
        milestone: ${{ needs.detect-milestone.outputs.milestone }}
        student_repo: ${{ github.repository }}
        pr_number: ${{ github.event.pull_request.number }}
        student_id: ${{ github.actor }}
      secrets:
        evaluation_token: ${{ secrets.PROTRACK_EVALUATION_TOKEN }}
```

---

## Milestone Unlock Automation

### 3. Unlock Workflow

**Location**: `protrack-core/.github/workflows/unlock-milestone.yml`

**Trigger**: When a student PR is merged

**Purpose**: Automatically unlock the next milestone in the student's repository

```yaml
name: Unlock Next Milestone

on:
  workflow_dispatch:
    inputs:
      student_repo:
        description: 'Student repository (org/repo)'
        required: true
        type: string
      completed_milestone:
        description: 'Milestone just completed (M01, M02)'
        required: true
        type: string

jobs:
  unlock:
    runs-on: ubuntu-latest

    steps:
      - name: Determine next milestone
        id: next
        run: |
          case "${{ inputs.completed_milestone }}" in
            M01) echo "milestone=M02" >> $GITHUB_OUTPUT ;;
            M02) echo "milestone=M03" >> $GITHUB_OUTPUT ;;
            M03) echo "milestone=COMPLETE" >> $GITHUB_OUTPUT ;;
          esac

      - name: Checkout student repository
        if: steps.next.outputs.milestone != 'COMPLETE'
        uses: actions/checkout@v4
        with:
          repository: ${{ inputs.student_repo }}
          token: ${{ secrets.PROTRACK_UNLOCK_TOKEN }}
          ref: main

      - name: Remove LOCKED files
        if: steps.next.outputs.milestone != 'COMPLETE'
        run: |
          MILESTONE="${{ steps.next.outputs.milestone }}"

          # Remove LOCKED files for next milestone
          rm -f "milestones/$MILESTONE/LOCKED"
          rm -f "docs/$MILESTONE/LOCKED"

          # Verify files were removed
          if [[ -f "milestones/$MILESTONE/LOCKED" ]]; then
            echo "ERROR: Failed to remove milestone lock"
            exit 1
          fi

      - name: Inject milestone content
        if: steps.next.outputs.milestone != 'COMPLETE'
        run: |
          MILESTONE="${{ steps.next.outputs.milestone }}"

          # TODO: Fetch milestone content from secure storage
          # This could be:
          # - GitHub API (from protrack-milestone-content repo)
          # - Azure Blob Storage
          # - GitHub Packages
          # - Git submodule

          echo "Content injection placeholder for $MILESTONE"

      - name: Commit and push unlock
        if: steps.next.outputs.milestone != 'COMPLETE'
        run: |
          MILESTONE="${{ steps.next.outputs.milestone }}"

          git config user.name "ProTrack Bot"
          git config user.email "protrack@questlogicsolutions.com"

          git add .
          git commit -m "Unlock $MILESTONE after ${{ inputs.completed_milestone }} completion

          Student: ${{ github.actor }}
          Previous Milestone: ${{ inputs.completed_milestone }}
          Unlocked: $MILESTONE
          Date: $(date -u +%Y-%m-%d)
          "

          git push origin main

      - name: Notify student
        if: steps.next.outputs.milestone != 'COMPLETE'
        uses: actions/github-script@v7
        with:
          github-token: ${{ secrets.PROTRACK_UNLOCK_TOKEN }}
          script: |
            const [owner, repo] = "${{ inputs.student_repo }}".split('/');

            github.rest.issues.create({
              owner: owner,
              repo: repo,
              title: `🎉 Milestone ${{ steps.next.outputs.milestone }} Unlocked!`,
              body: `Congratulations on completing **${{ inputs.completed_milestone }}**!

            ## Next Steps

            1. Pull the latest changes:
               \`\`\`bash
               git checkout main
               git pull origin main
               \`\`\`

            2. Verify ${{ steps.next.outputs.milestone }} is unlocked:
               \`\`\`bash
               ls milestones/${{ steps.next.outputs.milestone }}/
               # Should NOT see LOCKED file
               \`\`\`

            3. Create a new branch:
               \`\`\`bash
               git checkout -b ${{ steps.next.outputs.milestone | lower }}-work
               \`\`\`

            4. Start working on ${{ steps.next.outputs.milestone }}!

            Good luck! 🚀`
            });
```

### 4. Trigger Unlock on PR Merge

**In student template**: `.github/workflows/on-merge.yml`

```yaml
name: Post-Merge Actions

on:
  pull_request:
    types: [closed]
    branches:
      - main

jobs:
  trigger-unlock:
    if: github.event.pull_request.merged == true
    runs-on: ubuntu-latest

    steps:
      - name: Detect completed milestone
        id: milestone
        run: |
          # Extract milestone from PR title or branch name
          BRANCH="${{ github.event.pull_request.head.ref }}"

          if [[ "$BRANCH" =~ m01 ]]; then
            echo "milestone=M01" >> $GITHUB_OUTPUT
          elif [[ "$BRANCH" =~ m02 ]]; then
            echo "milestone=M02" >> $GITHUB_OUTPUT
          elif [[ "$BRANCH" =~ m03 ]]; then
            echo "milestone=M03" >> $GITHUB_OUTPUT
          else
            echo "milestone=UNKNOWN" >> $GITHUB_OUTPUT
          fi

      - name: Trigger unlock workflow
        if: steps.milestone.outputs.milestone != 'UNKNOWN'
        uses: actions/github-script@v7
        with:
          github-token: ${{ secrets.PROTRACK_UNLOCK_TOKEN }}
          script: |
            await github.rest.actions.createWorkflowDispatch({
              owner: 'QuestLogicSolutions',
              repo: 'protrack-core',
              workflow_id: 'unlock-milestone.yml',
              ref: 'main',
              inputs: {
                student_repo: '${{ github.repository }}',
                completed_milestone: '${{ steps.milestone.outputs.milestone }}'
              }
            });
```

---

## Required GitHub Secrets

### In Student Template Repository

1. **`PROTRACK_EVALUATION_TOKEN`**
   - Purpose: Allows protrack-core to read student code
   - Scope: `repo` (read access)
   - Created in: protrack-core

2. **`PROTRACK_UNLOCK_TOKEN`**
   - Purpose: Allows protrack-core to unlock milestones
   - Scope: `repo` (write access to student repos)
   - Created in: protrack-core

### Setup Instructions

```bash
# In protrack-core, create a GitHub App or PAT with:
# - repo (full control of private repositories)

# Add as organization secret:
# Settings → Secrets and variables → Actions → New organization secret

Name: PROTRACK_EVALUATION_TOKEN
Value: ghp_xxxxxxxxxxxx

Name: PROTRACK_UNLOCK_TOKEN
Value: ghp_xxxxxxxxxxxx
```

---

## Evaluation Criteria (for protrack-core)

### Terraform Quality (40 points)

- **Syntax & Formatting** (10 pts)
  - `terraform fmt` compliance
  - No syntax errors
  - Consistent style

- **Best Practices** (15 pts)
  - Proper variable usage
  - Output definitions
  - Resource naming
  - Tag application

- **Security** (15 pts)
  - HTTPS enforcement
  - TLS version compliance
  - No hardcoded secrets
  - Proper access controls

### Documentation (30 points)

- **Runbook Completeness** (15 pts)
  - All sections filled
  - No TODO markers
  - Diagrams included

- **Quality** (15 pts)
  - Clear explanations
  - Design rationale
  - Security thinking
  - Cost awareness

### Evidence (20 points)

- **Completeness** (10 pts)
  - deployment_evidence.json present
  - Valid JSON structure
  - Screenshots included

- **Quality** (10 pts)
  - Shows successful deployment
  - No secrets exposed
  - Matches documentation

### Process (10 points)

- **Git Hygiene** (5 pts)
  - Clean commit history
  - Descriptive messages
  - Proper branch naming

- **PR Quality** (5 pts)
  - Checklist completed
  - Clear description
  - Responds to feedback

---

## Testing the Integration

### 1. Local Testing (Without Core)

```bash
# Test current student workflow
cd protrack-azure-student-template
git checkout -b test-m01-work

# Modify M01 files
# ...

# Run CI locally (act)
act pull_request
```

### 2. Integration Testing (With Core)

```bash
# 1. Create test student repo
gh repo create test-student-template --template QuestLogicSolutions/protrack-azure-student-template

# 2. Clone and work on M01
git clone https://github.com/YOUR_ORG/test-student-template
cd test-student-template
git checkout -b m01-work
# Complete M01...

# 3. Submit PR
git push origin m01-work
gh pr create --title "Complete M01" --body "Test PR"

# 4. Verify CI runs
# - Check that protrack-core evaluator is called
# - Check scorecard is generated
# - Check PR comment is posted

# 5. Merge PR
gh pr merge 1 --squash

# 6. Verify unlock
# - Check that M02 LOCKED files are removed
# - Check that unlock notification issue is created
```

---

## Rollout Plan

### Phase 1: Template Only (Current State)
- ✅ Student template is ready
- ✅ Local validation works
- ⏸️ Manual grading required

### Phase 2: Core Integration
- 🔨 Build protrack-core repository
- 🔨 Implement reusable evaluation workflow
- 🔨 Test with pilot students

### Phase 3: Automated Unlocking
- 🔨 Implement unlock workflow
- 🔨 Create milestone content repository
- 🔨 Test end-to-end flow

### Phase 4: Production
- 🚀 Deploy to all students
- 📊 Monitor evaluation quality
- 🔄 Iterate based on feedback

---

## Troubleshooting

### Issue: Unlock workflow doesn't run

**Check**:
- `PROTRACK_UNLOCK_TOKEN` is set in organization secrets
- Token has `repo` scope
- Workflow dispatch is correctly configured

### Issue: Evaluation fails to post results

**Check**:
- `PROTRACK_EVALUATION_TOKEN` is valid
- Student repo allows workflow access
- PR number is correct

### Issue: Students can't see unlocked content

**Check**:
- LOCKED files were actually removed
- Content was properly injected
- Students pulled latest main branch

---

## Contact

For questions about integration:
- **Repository**: https://github.com/QuestLogicSolutions/protrack-core
- **Issues**: Open an issue in protrack-core
- **Email**: cloudcwfranck <yakengne@gmail.com>

---

**Last Updated**: 2025-12-30
**Integration Status**: ⏸️ Awaiting protrack-core setup
