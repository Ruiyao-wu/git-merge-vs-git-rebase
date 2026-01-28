# Example 2: Rebase with Conflicts

This example shows how to handle conflicts when rebasing your feature branch on updated main.

## Scenario

```
1. main:    A---B
   feature:       C---D

2. Someone pushes E that MODIFIES THE SAME FILE:
   main:    A---B---E (changed login.txt)
   feature:       C---D (also changed login.txt)

3. You try to rebase:
   main:    A---B---E
   feature:       C---D (CONFLICT on login.txt)
```

## Step-by-Step Commands

### Step 1: Attempt Rebase
```bash
git fetch origin
git checkout feature/login-form
git rebase origin/main
```

**Output (conflict case):**
```
Auto-merging login.txt
CONFLICT (content): Merge conflict in login.txt
error: could not apply abc1234... Add validation logic
hint: Resolve all conflicts manually, mark them as resolved with
hint: "git add <paths>" and run "git rebase --continue"
hint: You can instead skip this commit: run "git rebase --skip"
hint: To abort and retry the original rebase: run "git rebase --abort"
Resolve all conflicts before continuing your rebase.
```

### Step 2: Check Conflict Details
```bash
# See which files have conflicts
git status

# Output:
# On branch feature/login-form
# You are currently rebasing branch 'feature/login-form' on 'abc1234'.
# Unmerged paths:
#   (use "git restore --staged <file>..." to unstage)
#   (use "git restore <file>..." to discard changes in both working and rebasing)
#   both modified:   login.txt
```

### Step 3: Open the Conflicted File
```bash
cat login.txt
```

**You'll see markers:**
```
<<<<<<< HEAD
Login Form Validation v2
username required
password required
correct: use this from main
=======
Login Form Validation v1
username field
password field
my version: this is what I added
>>>>>>> abc1234 (Add validation logic)
```

**Explanation:**
- `HEAD` = current state on main (the new base)
- `<<<<<<< / =======` = conflict boundary
- The lower part = your commit being replayed

### Step 4: Resolve the Conflict

**Option A: Keep main's version**
```bash
# Manually edit to keep main's changes
# Remove the conflict markers and keep:
Login Form Validation v2
username required
password required
```

**Option B: Keep your version**
```bash
# Keep your changes, remove main's:
Login Form Validation v1
username field
password field
```

**Option C: Combine both**
```bash
# Use the best of both
Login Form Validation v2
username required (from main)
password required (from main)
additional validation (your addition)
```

### Step 5: Mark Conflict as Resolved
```bash
# Stage the resolved file
git add login.txt

# Check status
git status
# Should show: 'both modified:   login.txt' -> 'added by us'
```

### Step 6: Continue Rebase
```bash
# Tell git to continue rebasing
git rebase --continue
```

**Possible outcomes:**

**A) No more conflicts:**
```
Successfully rebased and updated refs/heads/feature/login-form.
```

**B) More conflicts (multiple commits touch the file):**
Git will stop at the next conflict. Repeat steps 2-5.

### Step 7: Verify Rebase Completed
```bash
# Check your commits are on top of main
git log --oneline -5

# Should show:
# abc1234 Add validation logic (replayed, new hash)
# def5678 Add login form UI (replayed, new hash)
# ghi9012 E (from main)
# hij0123 B
# ...
```

### Step 8: Push Safely
```bash
git push --force-with-lease
```

## If Something Goes Wrong: Abort

```bash
# Abort the rebase if it's too messy
git rebase --abort

# You're back to your original state before rebase
git log --oneline  # Shows original C and D hashes

# Then try merge instead
git merge origin/main
```

## Conflict Resolution Tools

### Use Git Mergetool
```bash
# Let your editor handle conflicts visually
git config merge.tool vscode
git rebase origin/main

# When conflict: git mergetool
# Resolves in VS Code side-by-side view
```

### Manual Resolution Checklist
- [ ] Understand what changed in main (E)
- [ ] Understand what you changed (C, D)
- [ ] Decide which version is correct
- [ ] Edit file to keep best of both
- [ ] Remove conflict markers (`<<<<`, `====`, `>>>>`)
- [ ] Test the file if possible
- [ ] `git add` the file
- [ ] `git rebase --continue`

## Key Takeaway

⚠️ Conflicts happen when both branches modify the same lines
✅ They're manageable — just take time to resolve carefully
✅ Use your editor or mergetool for easier visualization
✅ Always test after resolving
✅ `git rebase --abort` if overwhelmed
