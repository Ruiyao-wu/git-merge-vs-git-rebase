# Example 1: Simple Rebase (No Conflicts)

This example shows the cleanest case where you rebase your feature branch on updated main without any conflicts.

## Scenario

```
1. main:    A---B
   feature:       C---D

2. Someone pushes E to main:
   main:    A---B---E
   feature:       C---D (you're behind)

3. You rebase to catch up:
   main:    A---B---E
   feature:           C'---D' (replayed commits)
```

## Step-by-Step Commands

### Step 1: Start Fresh
```bash
git fetch origin
git status
```

Your branch is now shown as "behind" main.

### Step 2: Rebase Your Feature Branch
```bash
# Ensure you're on your feature branch
git checkout feature/login-form

# Rebase onto the latest main
git rebase origin/main
```

**Output (if no conflicts):**
```
Successfully rebased and updated refs/heads/feature/login-form.
```

### Step 3: Check Your History
```bash
# View your commits
git log --oneline -5

# Compare with main
git log --oneline origin/main..HEAD
```

You should see C' and D' — new commits with new hashes.

### Step 4: Push with Safety
```bash
# Force push with lease (safe method)
git push --force-with-lease

# NOT git push --force (dangerous!)
```

### Step 5: Create/Update Your PR
```bash
# If already have PR, it auto-updates
# If not, create one on GitHub/GitLab/Bitbucket

gh pr create --base main --title "Add login form"
```

## Final History

```
main:    A---B---E
feature:           C'---D'
                        ↓ (PR merge point)
```

## What Changed?

| Before Rebase | After Rebase |
|---|---|
| C: abc1234 | C': def5678 |
| D: def5678 | D': ghi9012 |

The commit hashes changed because git replayed them on a new base. This is why you must force-push.

## Key Takeaway

✅ No conflicts = simple, smooth rebase
✅ Clean linear history
✅ Safe push with `--force-with-lease`
✅ PR merges cleanly with no extra commit
