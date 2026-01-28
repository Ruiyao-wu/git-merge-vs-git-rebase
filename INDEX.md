# Git Merge vs Git Rebase - Complete Learning Repository

A comprehensive, practical guide to understanding and mastering `git merge` and `git rebase` with runnable examples, detailed documentation, and team best practices.

## 📂 Repository Structure

```
.
├── README.md                          # Main comprehensive guide (START HERE)
├── QUICKSTART.md                      # 5-minute quick start guide
└── examples/
    ├── WORKFLOW.md                    # Complete team workflow (detailed)
    ├── demo-rebase.sh                 # Executable: Rebase demonstration
    ├── demo-merge.sh                  # Executable: Merge demonstration
    ├── demo-conflicts.sh              # Executable: Conflict resolution demo
    ├── demo-interactive-rebase.sh     # Executable: Interactive rebase demo
    ├── rebase-simple.md               # Guide: Simple rebase (no conflicts)
    ├── rebase-conflicts.md            # Guide: Rebase with conflicts
    ├── merge-simple.md                # Guide: Merge workflow
    └── interactive-rebase.md          # Guide: Clean up commits before PR
```

---

## 🎯 Where to Start

### 👶 Complete Beginner
1. Read [QUICKSTART.md](QUICKSTART.md) - 5 minutes
2. Run all 4 demo scripts:
   - `bash examples/demo-rebase.sh`
   - `bash examples/demo-merge.sh`
   - `bash examples/demo-conflicts.sh`
   - `bash examples/demo-interactive-rebase.sh`
3. Read [README.md](README.md) - Full guide

### 👤 Intermediate (some git experience)
1. Run the demo scripts to see the workflows
2. Read [README.md](README.md) - Focus on decision matrix
3. Read [examples/WORKFLOW.md](examples/WORKFLOW.md) - Learn the team workflow

### 👨‍💼 Team Lead / Advanced User
1. Read entire [README.md](README.md)
2. Read [examples/WORKFLOW.md](examples/WORKFLOW.md)
3. Share demos with your team
4. Establish your team's policy (merge-first or rebase-first)

---

## 📚 Documentation Overview

### Main Documents

| Document | Purpose | Read Time |
|----------|---------|-----------|
| [README.md](README.md) | Complete guide with best practices | 20 min |
| [QUICKSTART.md](QUICKSTART.md) | Quick start and common mistakes | 5 min |
| [examples/WORKFLOW.md](examples/WORKFLOW.md) | Step-by-step team workflow with examples | 15 min |

### Scenario Guides

| Scenario | Document | Read Time |
|----------|----------|-----------|
| Simple rebase (no conflicts) | [rebase-simple.md](examples/rebase-simple.md) | 5 min |
| Rebase with conflicts | [rebase-conflicts.md](examples/rebase-conflicts.md) | 8 min |
| Using merge instead | [merge-simple.md](examples/merge-simple.md) | 5 min |
| Clean up commits before PR | [interactive-rebase.md](examples/interactive-rebase.md) | 10 min |

### Demo Scripts

| Demo | What It Shows | Run With |
|------|---------------|----------|
| demo-rebase.sh | Clean linear history with rebase | `bash examples/demo-rebase.sh` |
| demo-merge.sh | Preserving history with merge | `bash examples/demo-merge.sh` |
| demo-conflicts.sh | Handling and resolving conflicts | `bash examples/demo-conflicts.sh` |
| demo-interactive-rebase.sh | Squashing/organizing commits | `bash examples/demo-interactive-rebase.sh` |

---

## 🚀 Quick Commands

### Daily Workflow
```bash
# Start
git fetch origin
git checkout -b feature/something

# Work
git add file
git commit -m "Clear message"

# Update
git rebase origin/main  # or git merge origin/main

# Clean (optional)
git rebase -i origin/main

# Push
git push --force-with-lease  # or git push

# Review
# ... get PR approved ...

# Merge
git checkout main && git pull origin main
git merge feature/something
git push origin main

# Cleanup
git branch -d feature/something
```

### Key Rules
```bash
✅ On your feature branch: rebase and --force-with-lease
✅ On shared branches: merge (never rebase)
✅ Before PR: interactive rebase to clean up
✅ Always: fetch before any operation
❌ Never: rebase main or use plain --force
```

---

## 🎓 Learning Path

### Path 1: Visual Learner (Demos First)
1. ✅ Run `demo-rebase.sh` → Watch history change
2. ✅ Run `demo-merge.sh` → Watch branches connect
3. ✅ Run `demo-conflicts.sh` → See conflict resolution
4. ✅ Read [README.md](README.md) for context
5. ✅ Read [examples/WORKFLOW.md](examples/WORKFLOW.md) for team workflow

### Path 2: Reader (Docs First)
1. ✅ Read [QUICKSTART.md](QUICKSTART.md)
2. ✅ Read [README.md](README.md)
3. ✅ Run demos to see concepts in action
4. ✅ Read [examples/WORKFLOW.md](examples/WORKFLOW.md)
5. ✅ Read specific scenario guides as needed

### Path 3: Hands-On (Practice)
1. ✅ Create a test repository
2. ✅ Try rebase workflow
3. ✅ Try merge workflow
4. ✅ Create intentional conflicts and resolve them
5. ✅ Practice interactive rebase
6. ✅ Read docs for deeper understanding

---

## 💡 Core Concepts at a Glance

### Git Merge
```
Before:
main:    A---B---E
feature:       C---D

After merge:
main:    A---B---E
feature:       C---D---M
```
- ✅ Creates a merge commit (M)
- ✅ Preserves both histories
- ✅ Safe for shared branches
- ✅ No commits rewritten
- ❌ Can create many merge commits

### Git Rebase
```
Before:
main:    A---B---E
feature:       C---D

After rebase:
main:    A---B---E
feature:           C'---D'
```
- ✅ Clean linear history
- ✅ No unnecessary merge commits
- ✅ Easier to read
- ❌ Rewrites commit hashes
- ❌ Not safe for shared branches

---

## 🏆 Best Practices Summary

### For Feature Branches (Personal Work)
1. ✅ Rebase often to stay updated
2. ✅ Interactive rebase before creating PR
3. ✅ Force-push with `--force-with-lease`
4. ✅ Keep commits focused and well-messaged
5. ✅ Rebase conflicts are manageable

### For Shared Branches (main, develop, etc)
1. ✅ Never rebase
2. ✅ Always merge
3. ✅ Require code review PRs
4. ✅ Never force-push
5. ✅ Require CI/tests to pass

### For Your Team
1. ✅ Document your policy (rebase vs merge)
2. ✅ Train team with demos
3. ✅ Use consistent commit message format
4. ✅ Protect main branch (no direct pushes)
5. ✅ Celebrate clean history!

---

## ⚠️ Golden Rules

### Rule 1: Never Rebase Shared Branches ❌
Rebasing rewrites history. If others depend on the branch, it breaks their work.

### Rule 2: Always Use `--force-with-lease` ✅
```bash
✅ git push --force-with-lease   # Safe
❌ git push --force              # Dangerous - no checks
```

### Rule 3: Fetch Before Any Operation ✅
```bash
git fetch origin  # Always start here
git rebase origin/main
git push --force-with-lease
```

### Rule 4: Merge to Main, Don't Rebase Into Main ✅
```bash
✅ git checkout main && git merge feature/branch
❌ git checkout main && git rebase feature/branch
```

### Rule 5: Interactive Rebase Before PR ✅
Clean up your commits before creating a pull request.

---

## 🆘 Quick Troubleshooting

| Problem | Solution | Command |
|---------|----------|---------|
| Rebase conflict | Edit file, mark resolved, continue | `git add file && git rebase --continue` |
| Too many conflicts | Abort and merge instead | `git rebase --abort && git merge origin/main` |
| Need to undo rebase | Check reflog and reset | `git reflog && git reset --hard HEAD@{1}` |
| Accidentally rebased main | Reset to before rebase | `git reflog && git reset --hard <good-commit>` |
| Want to go back | Use reflog to find state | `git reflog` then `git reset --hard HEAD@{N}` |

For more details, see [QUICKSTART.md](QUICKSTART.md).

---

## 🔗 External Resources

- **Atlassian Guide:** [Merging vs. Rebasing](https://www.atlassian.com/git/tutorials/merging-vs-rebasing)
- **GitHub Docs:** [Pull Request Merges](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/about-pull-request-merges)
- **Official Git:** [Git Documentation](https://git-scm.com/docs)
- **Pro Git Book:** [Free book by Scott Chacon](https://git-scm.com/book/en/v2)

---

## 📞 Support

- **Don't understand something?** Read the relevant guide
- **Want to see it in action?** Run the demo scripts
- **Want to practice?** Try the hands-on path
- **Leading a team?** Share the demos and WORKFLOW.md with your team

---

## ✨ What You'll Learn

After going through this repository, you'll be able to:

- [ ] Explain the difference between merge and rebase
- [ ] Know when to use each approach
- [ ] Rebase your feature branches confidently
- [ ] Handle merge conflicts during rebase
- [ ] Use interactive rebase to clean up commits
- [ ] Merge safely to main
- [ ] Teach others the best practices
- [ ] Establish git policies for your team

---

**Happy rebasing and merging! 🚀**

Start with [QUICKSTART.md](QUICKSTART.md) or [README.md](README.md) based on your learning style.
