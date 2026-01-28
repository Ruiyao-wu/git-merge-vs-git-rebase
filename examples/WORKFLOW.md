# Complete Team Workflow Guide

This document walks through the complete recommended workflow for a team using git merge and rebase best practices.

## 👥 Team Workflow Scenario

**Team:** 5 developers
**Project:** Login system with form, validation, security
**Repository:** Shared on GitHub
**Branch Policy:** Feature branches, PR reviews, merge to main

---

## 📋 The Workflow in Practice

### Phase 1: Setup Your Local Environment

```bash
# Clone the repository
git clone https://github.com/yourteam/project.git
cd project

# Configure your git identity (one time)
git config user.name "Your Name"
git config user.email "your.email@company.com"

# (Optional) Configure global settings
git config --global user.name "Your Name"
git config --global user.email "your.email@company.com"
```

### Phase 2: Create Your Feature Branch

```bash
# First, always start from the latest main
git checkout main
git pull origin main

# Create a descriptive feature branch
git checkout -b feature/login-form
# or
git checkout -b bugfix/password-reset
# or
git checkout -b feat/email-validation
```

**Branch Naming Convention:**
- `feature/` - new feature
- `bugfix/` or `fix/` - bug fix
- `hotfix/` - urgent production fix
- `refactor/` - code refactoring
- `docs/` - documentation only
- `test/` - tests only

### Phase 3: Do Your Work

```bash
# Make changes
echo "Login form component" > login.jsx
echo "Form validation rules" > validators.js

# Commit regularly with good messages
git add login.jsx
git commit -m "Add login form component structure"

git add validators.js
git commit -m "Add email and password validators"

# Keep commits focused - one feature/fix per commit
# Avoid: "Fixed stuff and added things"
# Instead: "Add password strength validator" / "Fix email regex pattern"
```

**Good Commit Message Format:**
```
Type: Brief description (50 chars max)

Optional detailed explanation if needed.
Explain WHAT and WHY, not HOW.

Can reference issues: Fixes #123, Related to #456
```

**Examples:**
```
✅ "Add email validation to login form"
✅ "Fix: Handle expired session tokens"
✅ "Refactor: Extract form validation into utils"
❌ "Fixed stuff"
❌ "Work in progress"
❌ "blah"
```

### Phase 4: Keep Your Branch Up-to-Date

```bash
# Check if main has new commits
git fetch origin

# See what's new on main
git log --oneline main..origin/main

# If main has changes, update your branch
git checkout your-feature-branch
git rebase origin/main
```

**Option A: Rebase (recommended for clean history)**
```bash
git rebase origin/main
# If conflicts: fix them, git add, git rebase --continue
git push --force-with-lease
```

**Option B: Merge (safer alternative)**
```bash
git merge origin/main
git push origin your-feature-branch
```

### Phase 5: Interactive Rebase Before PR

```bash
# Clean up your commits before creating a PR
git rebase -i origin/main

# In the editor:
# pick abc123 Add login form component
# pick def456 Add email validator
# pick ghi789 Fix typo
#
# Change to:
# pick abc123 Add login form component
# squash def456 Add email validator
# fixup ghi789 Fix typo  (discards typo message)

# Save and provide combined message for squash
```

### Phase 6: Push to Remote

```bash
# Push your clean feature branch
git push --force-with-lease

# OR if first push
git push -u origin feature/login-form
```

**Never use `git push --force` (plain force)**
- It overwrites remote without checking
- Use `--force-with-lease` instead
- It protects you from overwriting others' work

### Phase 7: Create Pull Request

```bash
# Using GitHub CLI
gh pr create --title "Add login form with validation" \
             --body "## Changes
- Add login form component
- Add email/password validators
- Add form submission handler

## Testing
- Manual test: username/password fields work
- Manual test: validation messages appear

Fixes #123"

# Or manually on GitHub:
# 1. Go to your repository
# 2. Click "Pull requests"
# 3. Click "New pull request"
# 4. Select: base=main, compare=feature/login-form
# 5. Fill in title and description
# 6. Click "Create pull request"
```

### Phase 8: Code Review

**While waiting for review:**
```bash
# Keep your branch updated if main changes
git fetch origin
git rebase origin/main
git push --force-with-lease
```

**Responding to review comments:**
```bash
# If reviewer asks for changes:
# Make the changes
git add .
git commit -m "Address review feedback: improve validation messages"

# Push (automatic update to PR)
git push origin feature/login-form

# Don't rebase yet! Reviewers can see what changed
```

**After changes are approved:**
```bash
# Optional: squash feedback commits for cleaner history
git rebase -i origin/main
# Squash feedback commits into original commits

git push --force-with-lease
```

### Phase 9: Merge to Main

**Option A: Merge via GitHub (recommended)**
```bash
# Go to your PR on GitHub
# Click "Merge pull request"
# Choose merge strategy:
#   "Create a merge commit" (recommended)
#   "Squash and merge" (if commits are already squashed)
#   "Rebase and merge" (if team prefers linear history)
# Click "Confirm merge"
```

**Option B: Merge via Command Line**
```bash
git checkout main
git pull origin main
git merge feature/login-form
git push origin main

# Delete the feature branch
git branch -d feature/login-form
git push origin --delete feature/login-form
```

### Phase 10: Cleanup

```bash
# Delete local branch
git branch -d feature/login-form

# Update main
git checkout main
git pull origin main

# Your feature is now in main!
```

---

## ⚡ Quick Commands Reference

### Daily Commands
```bash
# Start day
git fetch origin
git checkout main
git pull origin main

# Create feature branch
git checkout -b feature/something

# Check status
git status

# Commit
git add file.js
git commit -m "Message"

# Check what you changed
git diff

# See commit history
git log --oneline -10

# Push
git push origin feature/something
```

### Before Creating PR
```bash
# Update with latest main
git fetch origin
git rebase origin/main

# Clean up commits
git rebase -i origin/main

# Push
git push --force-with-lease
```

### During Code Review
```bash
# Make changes
git add .
git commit -m "Address feedback"

# Push (auto-updates PR)
git push origin feature/branch

# After approved, optionally squash
git rebase -i origin/main
git push --force-with-lease
```

### After Merge
```bash
# Update main
git checkout main
git pull origin main

# Clean up
git branch -d feature/branch
git push origin --delete feature/branch
```

---

## ❌ Common Mistakes & How to Fix Them

### Mistake 1: Forgot to pull before starting
```bash
# You started from old main
git fetch origin
git rebase origin/main

# Resolve conflicts if any
git rebase --continue
git push --force-with-lease
```

### Mistake 2: Committed to main instead of feature branch
```bash
# Uh oh, you did git commit on main

# Solution 1: Undo commit, move to feature branch
git reset HEAD~1
git checkout -b feature/something
git add .
git commit -m "Message"

# Solution 2: Or just start feature branch from current state
git checkout -b feature/something
git push --force origin feature/something
```

### Mistake 3: Rebase went wrong, too many conflicts
```bash
# Abort the rebase
git rebase --abort

# Go back to where you were
git log --oneline  # Check you're back

# Try merge instead
git merge origin/main
```

### Mistake 4: Accidentally used `git push --force`
```bash
# Check git reflog to see what happened
git reflog

# Go back to safe state
git reset --hard HEAD@{1}

# Inform your team immediately!
```

### Mistake 5: Pushed to main by accident
```bash
# Don't panic! Tell team immediately
# Then revert the commits
git revert main~2..main
git push origin main

# Or reset if super urgent and no one pulled yet
git reset --hard HEAD~2
git push --force-with-lease
```

---

## 🏆 Team Rules

### Rules for Everyone
1. ✅ **Always create a branch** - Never commit to main
2. ✅ **Always make PRs** - No direct pushes to main
3. ✅ **Always pull before rebase** - `git fetch origin` first
4. ✅ **Use descriptive messages** - Future-you will thank you
5. ✅ **Keep commits focused** - One feature per commit
6. ✅ **Use --force-with-lease** - Never plain --force
7. ✅ **Test before pushing** - Don't break the build

### Rules for Feature Branches
1. ✅ **Only you use it** - Branch is personal until PR
2. ✅ **Rebase often** - Keep up with main
3. ✅ **Rebase is safe** - No one else depends on it
4. ✅ **Force push is OK** - With --force-with-lease
5. ✅ **Clean up before PR** - Use interactive rebase

### Rules for Shared Branches (main, develop)
1. ❌ **Never push directly** - Always use PRs
2. ❌ **Never rebase** - Only merge
3. ❌ **Never force push** - Ever
4. ✅ **Require code review** - Must be approved
5. ✅ **Run CI/CD first** - Tests must pass
6. ✅ **Merge with care** - Take time to review

---

## 🔄 Example: Complete Feature Workflow

```bash
# Day 1: Start new feature
git fetch origin
git checkout main
git pull origin main
git checkout -b feature/2fa

# Make some changes
echo "2FA implementation" > auth.js
git add auth.js
git commit -m "Add two-factor authentication module"

# Day 2: Continue work
echo "2FA validation" >> auth.js
git add auth.js
git commit -m "Add 2FA validation logic"

# Day 3: Check if main updated
git fetch origin
git log --oneline origin/main..HEAD  # What you did
git log --oneline HEAD..origin/main  # What main has new

# Main has new stuff, update your branch
git rebase origin/main
# (maybe conflicts, fix them)

# Clean up commits before PR
git rebase -i origin/main
# Squash 'Fix' commits into main commits

# Push cleaned-up branch
git push --force-with-lease

# Create PR
gh pr create --title "Add two-factor authentication" \
             --body "Implements 2FA with TOTP support"

# Wait for review, make changes if needed
# (reviewer asks for better error handling)
git add error-handler.js
git commit -m "Improve error messages for 2FA failures"
git push origin feature/2fa

# After approval, merge
# (via GitHub PR button)

# Cleanup
git checkout main
git pull origin main
git branch -d feature/2fa
git push origin --delete feature/2fa
```

---

## 🎓 Learning Resources

- **Run the demos:**
  ```bash
  bash examples/demo-rebase.sh
  bash examples/demo-merge.sh
  bash examples/demo-conflicts.sh
  bash examples/demo-interactive-rebase.sh
  ```

- **Read the guides:**
  - [Main README](../README.md)
  - [Rebase Simple](rebase-simple.md)
  - [Rebase Conflicts](rebase-conflicts.md)
  - [Merge Simple](merge-simple.md)
  - [Interactive Rebase](interactive-rebase.md)

- **External Resources:**
  - [Atlassian Git Merge vs Rebase](https://www.atlassian.com/git/tutorials/merging-vs-rebasing)
  - [GitHub Docs: Merging a PR](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/merging-a-pull-request)
  - [Git Official Docs](https://git-scm.com/docs)
