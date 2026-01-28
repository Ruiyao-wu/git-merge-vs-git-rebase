# Quick Start Guide

Get started learning git merge vs rebase in 5 minutes!

## 🚀 Run the Demos

The easiest way to understand the difference is to see it in action.

### 1. Simple Rebase Demo
```bash
bash examples/demo-rebase.sh
```
**What it shows:** How rebase creates a clean linear history

### 2. Simple Merge Demo
```bash
bash examples/demo-merge.sh
```
**What it shows:** How merge preserves history with a merge commit

### 3. Conflict Resolution Demo
```bash
bash examples/demo-conflicts.sh
```
**What it shows:** How to handle and resolve conflicts during rebase

### 4. Interactive Rebase Demo
```bash
bash examples/demo-interactive-rebase.sh
```
**What it shows:** How to clean up commits before creating a PR

---

## 📚 Read the Docs

After running the demos, read the documentation:

1. **[Main README](README.md)** - Complete guide with best practices
2. **[Workflow Guide](examples/WORKFLOW.md)** - Step-by-step team workflow
3. **[Rebase Simple](examples/rebase-simple.md)** - How to rebase without conflicts
4. **[Rebase Conflicts](examples/rebase-conflicts.md)** - How to handle conflicts
5. **[Merge Simple](examples/merge-simple.md)** - Merge as a safe alternative
6. **[Interactive Rebase](examples/interactive-rebase.md)** - Clean up commits

---

## 💡 Key Takeaways

### When to Use Rebase ✅
- You have a **personal feature branch**
- **Only you** are working on it
- You want a **clean linear history**
- Before **creating a PR**

### When to Use Merge ✅
- The branch is **shared** with others
- You want **maximum safety**
- You want to **preserve history**
- Your **team prefers merges**

### Golden Rule ⚠️
**Never rebase shared/public branches!**
- Rebasing rewrites history
- It breaks collaboration
- Only rebase your own feature branches

---

## 🎯 The Recommended Workflow

```bash
# 1. Start fresh
git checkout main
git pull origin main

# 2. Create feature branch
git checkout -b feature/my-feature

# 3. Do your work
echo "code" > file.js
git add file.js
git commit -m "Clear message about what changed"

# 4. Keep up-to-date with main
git fetch origin
git rebase origin/main  # Clean history on your branch

# 5. Clean up commits before PR
git rebase -i origin/main  # Squash/organize commits

# 6. Push safely
git push --force-with-lease

# 7. Create PR
gh pr create --title "Feature description"

# 8. After review and approval: Merge
# (Click merge on GitHub, or)
git checkout main && git pull origin main
git merge feature/my-feature
git push origin main

# 9. Cleanup
git branch -d feature/my-feature
```

---

## ✋ STOP! Common Mistakes

### ❌ Never Use Plain `--force`
```bash
# WRONG:
git push --force

# RIGHT:
git push --force-with-lease
```

### ❌ Never Rebase Main
```bash
# WRONG:
git checkout main
git rebase something

# RIGHT:
git checkout main
git merge something
```

### ❌ Never Rebase Shared Branches
```bash
# WRONG:
git checkout shared-branch
git rebase main
git push --force

# RIGHT:
git checkout shared-branch
git merge main
git push
```

---

## 🆘 If Something Goes Wrong

### Undo a Rebase
```bash
git rebase --abort
```

### Undo a Commit
```bash
git reset HEAD~1
```

### Go Back to Previous State
```bash
git reflog  # See history
git reset --hard HEAD@{2}  # Go back
```

### Recover a Deleted Branch
```bash
git reflog  # Find it
git checkout -b recovered-branch HEAD@{1}
```

---

## 📞 Need Help?

1. **Run the demos** - See it in action
2. **Read the docs** - Detailed explanations
3. **Read the main README** - Complete guide with examples
4. **Check GitHub/GitLab docs** - Platform-specific help

---

## 🎓 Next Steps

1. ✅ Run all 4 demos
2. ✅ Read the main README
3. ✅ Read the WORKFLOW.md guide
4. ✅ Try it on a test branch
5. ✅ Apply to your real work

You're ready to use merge and rebase confidently!
