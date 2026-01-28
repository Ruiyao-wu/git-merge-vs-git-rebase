# Example 3: Merge (Safe Alternative to Rebase)

This example shows the merge approach, which is safer for shared branches and always preserves history.

## Scenario

```
1. main:    A---B
   feature:       C---D

2. Someone pushes E to main:
   main:    A---B---E
   feature:       C---D (you're behind)

3. You merge (no rewrite):
   main:    A---B---E
   feature:       C---D---M (merge commit created)
```

## Step-by-Step Commands

### Step 1: Fetch and Update
```bash
git fetch origin
git checkout feature/login-form
git status
```

Output shows: "behind 'origin/main' by 1 commit"

### Step 2: Merge Main Into Feature
```bash
# Merge main into your feature branch
git merge origin/main
```

**Output (no conflicts):**
```
Merge made by the 'ort' strategy.
 login.txt | 1 +
 1 file changed, 1 insertion(+)
```

**Git automatically created a merge commit.**

### Step 3: Check the New History
```bash
git log --oneline --graph -5

# Output:
#   *   abc1234 Merge branch 'origin/main' into feature/login-form
#   |\
#   | * def5678 E (from main)
#   * | ghi9012 D (your commit)
#   * | hij0123 C (your commit)
#   |/
#   * jkl2345 B
```

Notice the merge commit (`M`) connecting both branches.

### Step 4: Push to Remote
```bash
# Normal push (no --force needed!)
git push origin feature/login-form
```

### Step 5: Create/Update PR
```bash
# PR is now updated with merge
# GitHub shows: "1 commit ahead of main"
# PR will merge cleanly

gh pr create --base main --title "Add login form"
```

### Step 6: PR Review and Merge
On GitHub/GitLab/Bitbucket:
1. Request review
2. Get approval
3. Click "Merge pull request"
4. Choose merge strategy (usually "Create a merge commit" or "Squash and merge")

### Step 7: Final History After Merge
```bash
git checkout main
git pull origin main
git log --oneline --graph -5

# Output:
#   *   abc1234 Merge pull request #123 from feature/login-form
#   |\
#   | * def5678 D
#   | * ghi9012 C
#   * | hij0123 E
#   |/
#   * jkl2345 B
```

## Comparison: Merge vs Rebase Results

### After Merge:
```
A---B---E---M
        \  /
         \/
      C---D
```
**Preserves parallel history**
**Shows integration point (M)**
**No commits rewritten**

### After Rebase:
```
A---B---E---C'---D'
```
**Linear history**
**No merge commit**
**Commits rewritten (new hashes)**

## When to Use Merge

✅ **Shared branches** — Never rewrite shared history
✅ **Team policy** — If your team prefers merge commits
✅ **Uncertain about conflicts** — Merge is more forgiving
✅ **Want clear integration points** — Merge commits mark integrations
✅ **Less experienced with git** — Merge is safer to learn

## Merge Commit Message

When you `git merge`, git creates a commit message:

```
Merge branch 'origin/main' into feature/login-form

# Auto-generated, but you can edit it:
git merge origin/main --no-edit  # Keep auto message
```

You can customize it:
```bash
# Use your own message
git merge origin/main -m "Integrate latest main with validation improvements"
```

## Handling Merge Conflicts

If files conflict during merge, it's very similar to rebase:

```bash
git merge origin/main

# CONFLICT (content): Merge conflict in login.txt
# (same as rebase)

# Fix the file
nano login.txt

# Mark as resolved
git add login.txt

# Complete the merge (not --continue like rebase)
git commit -m "Merge branch 'origin/main' into feature/login-form"

# Push
git push origin feature/login-form
```

## Key Takeaway

✅ Merge creates a merge commit (preserves history)
✅ Never rewrites commits (always safe)
✅ Slightly messier history but clear integration points
✅ Good for shared branches
✅ Recommended when unsure
✅ Easier for teams new to git
