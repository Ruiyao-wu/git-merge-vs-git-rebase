# Example 4: Interactive Rebase (Clean Up Before PR)

This example shows how to use interactive rebase to organize your commits before creating a PR.

## Scenario

You've been working on a feature and made several commits. Some are cleanup, some are experimental. Before creating a PR, you want to:
- Squash related commits
- Reorder commits logically
- Edit commit messages
- Remove experimental commits

```
Before interactive rebase:
feature:  A---B (WIP: first attempt)
             C---D (trying new approach)
             E---F---G (actual work)
             H (oops, fix typo)

After interactive rebase:
feature:  A---B' (squashed into one)
             C'---D'---E' (logical commits)
```

## Step-by-Step Commands

### Step 1: Check Your Commits
```bash
git log --oneline origin/main..HEAD

# Output (commits since branching from main):
# abc1234 Fix typo in comment
# def5678 Add more validation tests
# ghi9012 Refactor form handler
# hij0123 Update UI styles
# jkl2345 Add form validation
# mno3456 Create login form component
```

### Step 2: Start Interactive Rebase
```bash
# Interactive rebase onto main
git rebase -i origin/main

# This opens your editor with all commits
```

**Editor shows:**
```
pick mno3456 Create login form component
pick jkl2345 Add form validation
pick hij0123 Update UI styles
pick ghi9012 Refactor form handler
pick def5678 Add more validation tests
pick abc1234 Fix typo in comment

# Rebase [base]..abc1234 onto [base] (6 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous
# f, fixup <commit> = like "squash", but discard this commit's log message
# d, drop <commit> = remove commit
# x, exec <command> = run command (the rest of the line) using shell
#
# These lines can be reordered; they are executed from top to bottom.
# If you remove a line here THAT COMMIT WILL BE LOST.
```

### Step 3: Edit the Rebase Commands

Modify the commands to organize your commits:

```bash
# Reorganize and clean up commits
pick mno3456 Create login form component
pick jkl2345 Add form validation
squash def5678 Add more validation tests      # Merge into previous
pick hij0123 Update UI styles
pick ghi9012 Refactor form handler
fixup abc1234 Fix typo in comment             # Merge, discard message
```

**Commands explained:**
- `pick` = keep this commit
- `squash` = keep changes, merge into previous commit
- `fixup` = like squash, but discard the message
- `reword` = keep changes, but edit the message
- `drop` = delete this commit entirely
- `edit` = stop here for manual changes

### Step 4: Squash Similar Commits

Change:
```bash
pick mno3456 Create login form component
pick jkl2345 Add form validation
pick def5678 Add more validation tests
pick hij0123 Update UI styles
pick ghi9012 Refactor form handler
pick abc1234 Fix typo in comment
```

To:
```bash
pick mno3456 Create login form component
pick jkl2345 Add form validation
squash def5678 Add more validation tests      # Squash into validation
pick hij0123 Update UI styles
pick ghi9012 Refactor form handler
fixup abc1234 Fix typo in comment             # Fixup into handler
```

**Result:** 4 logical commits instead of 6

### Step 5: Reorder if Needed

Move related commits together:
```bash
pick mno3456 Create login form component
pick hij0123 Update UI styles                 # Move style before validation
pick jkl2345 Add form validation
squash def5678 Add more validation tests
pick ghi9012 Refactor form handler
fixup abc1234 Fix typo in comment
```

### Step 6: Save and Watch the Rebase

When you save your editor (`:wq` in vim), git starts the rebase:

```bash
[detached HEAD abc1234] Create login form component
 2 files changed, 45 insertions(+)
[detached HEAD def5678] Update UI styles
 1 file changed, 30 insertions(+)
# Git prompts for squashed commit message...
```

### Step 7: Confirm Squashed Commit Message

When git squashes commits, it asks for the combined message:

```bash
# Old messages were:
# Add form validation
# Add more validation tests

# New combined message:
Add form validation and test coverage
```

Edit the message to be clear about both changes, then save.

### Step 8: Verify Result
```bash
git log --oneline -6

# Output (4 clean commits):
# abc1234 Refactor form handler
# def5678 Update UI styles
# ghi9012 Add form validation and test coverage
# hij0123 Create login form component
# [rest of main branch]

# Compare with main
git log --oneline origin/main..HEAD
# Shows only your 4 organized commits
```

### Step 9: Force-Push
```bash
git push --force-with-lease
```

**Old history on remote had 6 commits, now has 4 with different hashes.**

### Step 10: Update PR
```bash
# PR automatically updates
# Shows: Force pushed 6 commits, now 4 commits
# Code review can see cleaner commits now

gh pr view
```

## Advanced: Reword Commits

Use `reword` to edit commit messages:

```bash
reword mno3456 Create login form component
pick jkl2345 Add form validation
```

Git stops at mno3456, opens editor for you to change the message:

```bash
# Old message:
Create login form component

# Edit to be more descriptive:
feat: Create login form component with styling

- Add form HTML template
- Import style modules
- Wire up event handlers
```

## Advanced: Edit Commits

Use `edit` to stop and make changes:

```bash
edit mno3456 Create login form component
pick jkl2345 Add form validation
```

Git stops, you can:
```bash
# Make changes
echo "export const VERSION = '1.0.0'" >> constants.js

# Stage
git add constants.js

# Continue
git rebase --continue
```

## If Something Goes Wrong

```bash
# Abort the interactive rebase
git rebase --abort

# Go back to original commits
git log --oneline -6
# Shows original 6 commits
```

## Common Interactive Rebase Patterns

### Pattern 1: Squash All Into One
```bash
pick abc1234 First commit
squash def5678 Second commit
squash ghi9012 Third commit
```
Result: 1 commit with all changes

### Pattern 2: Combine Related, Keep Others
```bash
pick abc1234 Feature A
pick def5678 Feature A tests
squash ghi9012 Feature A refactor
pick hij0123 Feature B
pick jkl2345 Feature B tests
squash mno3456 Feature B refactor
```
Result: 2 commits, each with feature + tests + refactoring

### Pattern 3: Remove Debug Commits
```bash
pick abc1234 Real work
drop def5678 Debug: temp commit
drop ghi9012 WIP: trying approach
pick hij0123 Real work continued
```
Result: Clean history without debug commits

### Pattern 4: Reorder by Feature
```bash
pick abc1234 Feature B part 1
pick def5678 Feature A part 1
pick ghi9012 Feature B part 2
# Reorder to:
pick abc1234 Feature A part 1
pick def5678 Feature B part 1
pick ghi9012 Feature B part 2
```
Result: Commits grouped by feature

## Key Takeaway

✅ Interactive rebase lets you organize commits before PR
✅ Squash related commits for cleaner history
✅ Reword messages to be clear and descriptive
✅ Drop debug/WIP commits
✅ Reorder commits logically
✅ Use before creating/updating PR
✅ Safe when done on personal feature branch
✅ `git rebase --abort` to undo if wrong
