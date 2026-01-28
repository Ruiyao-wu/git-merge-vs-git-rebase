# Git Merge vs Git Rebase: Best Practices Guide

A comprehensive guide with practical examples for understanding when and how to use `git merge` vs `git rebase` in team workflows.

## 📋 Table of Contents

- [Quick Summary](#quick-summary)
- [Core Concepts](#core-concepts)
- [Key Differences](#key-differences)
- [Golden Rules](#golden-rules)
- [Decision Matrix](#decision-matrix)
- [Step-by-Step Workflow](#step-by-step-workflow)
- [Example Scenarios](#example-scenarios)
- [Running the Examples](#running-the-examples)

---

## 🎯 Quick Summary

Both **merge** and **rebase** integrate changes from one branch into another, but they handle history differently:

| Aspect | `git merge` | `git rebase` |
|--------|------------|-------------|
| **History** | Preserves all commits | Rewrites commit history |
| **Merge Commits** | Creates merge commit | Linear, no merge commit |
| **Safety** | Non-destructive ✅ | Rewrites history ⚠️ |
| **Best For** | Shared/public branches | Personal feature branches |
| **Team Impact** | Safe for collaboration | Only if branch is private |

---

## 🧠 Core Concepts

### What is `git merge`?

Combines two branches by creating a **merge commit** that ties together the histories of both branches.

```
Before merge:
main:    A---B---E
feature:       C---D

After merge:
main:    A---B---E
              \  \
feature:       C--D--M (merge commit)
```

**Characteristics:**
- ✅ Non-destructive — preserves all history
- ✅ Safe for shared branches
- ✅ Shows when changes were integrated
- ❌ Can create many merge commits if main is active
- ❌ History can become cluttered

### What is `git rebase`?

Takes commits from your branch and replays them on top of the latest main branch, creating a **clean linear history**.

```
Before rebase:
main:    A---B---E
feature:       C---D

After rebase:
main:    A---B---E
feature:           C'---D' (replayed commits)
```

**Characteristics:**
- ✅ Creates clean, linear history
- ✅ Easier to read and debug
- ✅ No extra merge commits
- ❌ Rewrites commit hashes
- ❌ Dangerous for shared branches

### Interactive Rebase

An advanced form that lets you reorder, squash, split, or edit commits:

```bash
git rebase -i origin/main
```

**Common uses:**
- Squash multiple small commits into one
- Reorder commits logically
- Edit commit messages
- Clean up before creating a PR

---

## 🔑 Key Differences

### Rewriting History
- **Merge**: Keeps original commits intact
- **Rebase**: Creates new commits with different hashes

### Collaboration Safety
- **Merge**: Always safe for shared branches
- **Rebase**: Only safe on private/personal branches

### History Visualization
- **Merge**: Shows parallel work and integration points
- **Rebase**: Shows linear progression

---

## ⚠️ Golden Rules

### Rule 1: Never Rebase Shared Branches ❌
```bash
# WRONG - Never do this on main, develop, or any shared branch
git rebase origin/main
git push --force

# This breaks everyone else's history!
```

### Rule 2: Rebase Your Own Private Branches ✅
```bash
# RIGHT - Safe on your feature branch
git checkout feature/my-feature
git rebase origin/main
git push --force-with-lease
```

### Rule 3: Use `--force-with-lease`, Never Plain `--force` ✅
```bash
# SAFE - Prevents overwriting others' work
git push --force-with-lease

# DANGEROUS - Will overwrite everything
git push --force
```

### Rule 4: Merge into Main, Don't Rebase into Main ✅
```bash
# RIGHT - Merge your feature into main
git checkout main
git merge feature/my-feature

# WRONG - Never rebase main into your branch then push
git rebase main  # Only do this locally on your feature branch
```

---

## 📊 Decision Matrix

| Scenario | Recommendation | Why |
|----------|----------------|-----|
| Updating your local feature branch | **Rebase** | Clean history, only you are affected |
| Branch is shared with teammates | **Merge** | No history rewriting, safe for all |
| Before creating a PR | **Rebase** | Clean up commits, easier review |
| Integrating back to main | **Merge** | Preserves feature branch history, creates clear integration point |
| Squashing commits before PR | **Interactive Rebase** | Cleanup without affecting shared history |
| Working on main branch | **Always Merge** | Never rebase main, ever |

---

## 🚀 Step-by-Step Workflow

This is the **recommended team workflow** following industry best practices:

### Phase 1: Setup
```bash
# 1. Start from main
git checkout main
git pull origin main

# 2. Create your feature branch
git checkout -b feature/login-form
```

### Phase 2: Develop
```bash
# 3. Do some work
echo "Login form UI" > login.txt
git add login.txt
git commit -m "Add login form UI"

echo "Validation logic" >> login.txt
git add login.txt
git commit -m "Add validation logic"
```

Your history:
```
main:    A---B
feature:       C---D (your commits)
```

### Phase 3: Someone Else Updates Main
```
main:    A---B---E (someone else merged)
feature:       C---D (you're now behind)
```

### Phase 4: Update Your Branch (Rebase Approach)
```bash
# 4. Get latest changes from remote
git fetch origin

# 5. Rebase your feature branch onto updated main
git checkout feature/login-form
git rebase origin/main
```

Result:
```
main:    A---B---E
feature:           C'---D' (replayed on new base)
```

### Phase 5: Push and Create PR
```bash
# 6. Force push with safety
git push --force-with-lease

# 7. Create PR on GitHub/GitLab/Bitbucket
# The PR shows clean commits: C' and D'
```

### Phase 6: Merge Back to Main
```bash
# 8. After review, merge back
git checkout main
git pull origin main
git merge feature/login-form
git push origin main
```

Final history:
```
A---B---E---C'---D'---M
        (clean linear history)
```

---

## 📚 Example Scenarios

### Scenario 1: Simple Rebase (No Conflicts)

See [examples/rebase-simple.md](examples/rebase-simple.md)

```bash
# Just rebase, no conflicts
git rebase origin/main

# Push safely
git push --force-with-lease
```

### Scenario 2: Rebase with Conflicts

See [examples/rebase-conflicts.md](examples/rebase-conflicts.md)

```bash
git rebase origin/main
# Git stops: CONFLICT in login.txt

# 1. Fix the conflict in your editor
# 2. Mark as resolved
git add login.txt

# 3. Continue rebase
git rebase --continue

# 4. If more conflicts, repeat
# 5. Then push
git push --force-with-lease
```

### Scenario 3: Merge Approach (Always Safe)

See [examples/merge-simple.md](examples/merge-simple.md)

```bash
git merge origin/main
# Creates merge commit, no rewriting
git push origin feature/login-form
```

### Scenario 4: Interactive Rebase (Clean Up Before PR)

See [examples/interactive-rebase.md](examples/interactive-rebase.md)

```bash
# Edit, reorder, squash commits
git rebase -i origin/main

# In editor:
# pick C1 Add login form UI
# squash C2 Add validation logic
#
# Result: Single commit with both changes
```

---

## 🏃 Running the Examples

We provide executable scripts demonstrating each workflow:

```bash
# View available examples
ls examples/

# Run a specific example
bash examples/demo-rebase.sh

# Or view documentation
cat examples/rebase-simple.md
```

### Example Scripts Include:

1. **demo-rebase.sh** - Complete rebase workflow demonstration
2. **demo-merge.sh** - Complete merge workflow demonstration  
3. **demo-conflicts.sh** - How to handle and resolve conflicts
4. **demo-interactive-rebase.sh** - Cleaning up commits before PR

---

## 💡 Pro Tips

### Tip 1: Check Before You Rebase
```bash
# See what's different
git log --oneline main..feature/my-feature  # Your commits
git log --oneline origin/main..feature/my-feature  # Behind main

# Only rebase if you're behind
git rebase origin/main
```

### Tip 2: Abort a Rebase If It Goes Wrong
```bash
# If rebase creates too many conflicts, abort
git rebase --abort

# Go back to before rebase
# Try merge instead
git merge origin/main
```

### Tip 3: Use Reflog to Recover
```bash
# See what you've done
git reflog

# Go back to a previous state
git reset --hard HEAD@{2}
```

### Tip 4: Interactive Rebase Before PR
```bash
# Clean up your commits before creating PR
git rebase -i origin/main

# Then create clean PR
git push --force-with-lease
git create-pr  # GitHub CLI
```

### Tip 5: Rebase Regularly on Long-Lived Branches
```bash
# Keep feature branch up-to-date with main
git fetch origin
git rebase origin/main

# This prevents huge conflicts later
```

---

## 🏢 Team Best Practices

### For Team Leaders / Repo Maintainers

1. **Establish Policy**: Document whether your team uses merge or rebase
2. **Protect Main**: Require PRs, no direct pushes to main
3. **CI/CD First**: Ensure tests pass before merge
4. **Code Review**: Require approval before merging PRs

### For Developers

1. **Always fetch first**: `git fetch origin` before any operation
2. **Rebase your feature branches**: Keep clean history
3. **Never force push main**: Use `git push` without `--force`
4. **Communicate with teammates**: If sharing a branch, discuss rebase vs merge
5. **Use descriptive commit messages**: Makes history readable

### GitHub/GitLab/Bitbucket Settings

**Recommended PR merge settings:**
- Require PR reviews before merge ✅
- Require status checks to pass ✅
- Dismiss stale PR approvals on new commits ✅
- Allow force-with-lease for branch owners ✅
- Auto-delete branch after merge ✅

---

## 📖 References

- [Atlassian Git Merge vs Rebase](https://www.atlassian.com/git/tutorials/merging-vs-rebasing)
- [Git Official Documentation](https://git-scm.com/docs)
- [GitHub Merging vs Rebasing](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/about-pull-request-merges)

---

## 🎓 Learning Path

1. **Start here**: Read [Quick Summary](#quick-summary) and [Golden Rules](#golden-rules)
2. **Run examples**: Execute the demo scripts to see real workflows
3. **Practice**: Try both merge and rebase on a test branch
4. **Apply**: Use rebase on your feature branches, merge to main
5. **Master**: Learn interactive rebase for cleanup