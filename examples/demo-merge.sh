#!/bin/bash

# Demo: Git Merge Workflow
# This script demonstrates the merge approach (safe alternative to rebase)
# It creates a temporary git repo to show the process safely

set -e

DEMO_DIR="/tmp/git-merge-demo-$$"
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}GIT MERGE DEMO - Safe Workflow${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Cleanup on exit
cleanup() {
    echo -e "\n${YELLOW}Cleaning up demo repository...${NC}"
    rm -rf "$DEMO_DIR"
    echo -e "${GREEN}Done!${NC}"
}

trap cleanup EXIT

# Create demo repo
echo -e "${BLUE}Step 1: Creating demo repository${NC}"
mkdir -p "$DEMO_DIR"
cd "$DEMO_DIR"

git init
git config user.email "demo@example.com"
git config user.name "Demo User"

# Create initial commits on main
echo "# Login Feature" > login.md
git add login.md
git commit -m "A: Initial commit on main" > /dev/null

echo "Initial setup complete" >> login.md
git add login.md
git commit -m "B: Add initial setup on main" > /dev/null

echo -e "${GREEN}✓ Main branch created with commits A and B${NC}"
git log --oneline
echo ""

# Create feature branch
echo -e "${BLUE}Step 2: Creating feature branch${NC}"
git checkout -b feature/login-form > /dev/null 2>&1

echo "Login form UI component" >> login.md
git add login.md
git commit -m "C: Add login form UI" > /dev/null

echo "Email validation logic" >> login.md
git add login.md
git commit -m "D: Add validation logic" > /dev/null

echo -e "${GREEN}✓ Feature branch created with commits C and D${NC}"
git log --oneline -5
echo ""

# Simulate someone else pushing to main
echo -e "${BLUE}Step 3: Simulating new commit on main${NC}"
git checkout main > /dev/null 2>&1

echo "New security feature" >> login.md
git add login.md
git commit -m "E: Add security headers on main" > /dev/null

echo -e "${GREEN}✓ New commit E added to main${NC}"
git log --oneline -5
echo ""

# Show branch divergence
echo -e "${BLUE}Step 4: Visualizing diverged branches${NC}"
echo -e "${YELLOW}Current state - branches are now diverged:${NC}"
echo ""
echo "main:    A---B---E"
echo "feature:       C---D"
echo ""

# Switch back to feature and do merge
echo -e "${BLUE}Step 5: Merging main into feature${NC}"
git checkout feature/login-form > /dev/null 2>&1

echo -e "${YELLOW}Running: git merge main${NC}"
git merge main > /dev/null 2>&1

echo -e "${GREEN}✓ Merge successful! Created merge commit M${NC}"
echo ""

# Show new history
echo -e "${BLUE}Step 6: Viewing new history${NC}"
echo -e "${YELLOW}After merge - branches connected with merge commit:${NC}"
echo ""
git log --oneline --graph main..HEAD
echo ""
git log --oneline -6
echo ""

# Show what's different from rebase
echo -e "${BLUE}Step 7: Comparing Merge vs Rebase${NC}"
echo -e "${YELLOW}With MERGE (what we just did):${NC}"
echo "  A---B---E"
echo "     \\ \\ /"
echo "      M"
echo "     C---D"
echo ""
echo "✓ Preserves both histories"
echo "✓ Shows integration point (M)"
echo "✓ No commits rewritten (same hashes)"
echo "✓ Safe for shared branches"
echo ""

echo -e "${YELLOW}With REBASE (alternative):${NC}"
echo "  A---B---E---C'---D'"
echo ""
echo "✓ Linear history"
echo "✓ No merge commit"
echo "⚠ Commits rewritten (new hashes)"
echo ""

# Show merge commit details
echo -e "${BLUE}Step 8: Examining merge commit${NC}"
echo -e "${YELLOW}Merge commit message:${NC}"
git log -1 --format=%B
echo ""

# Show normal push (no --force needed)
echo -e "${BLUE}Step 9: Pushing to remote (safe push)${NC}"
echo -e "${YELLOW}With merge, you use normal: git push origin feature/login-form${NC}"
echo "✓ No --force needed (commits not rewritten)"
echo "✓ Safe for shared branches"
echo ""

# Show PR merge
echo -e "${BLUE}Step 10: Merging back to main${NC}"
git checkout main > /dev/null 2>&1

echo -e "${YELLOW}Running: git merge feature/login-form${NC}"
git merge feature/login-form > /dev/null 2>&1

echo -e "${GREEN}✓ Merge into main completed!${NC}"
echo ""

# Show final history
echo -e "${YELLOW}Final history (with merge commits):${NC}"
git log --oneline --graph
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Demo Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Key takeaway: Merge is safe and preserves history."
echo -e "Use on shared branches or when unsure about rebasing!"
echo ""
