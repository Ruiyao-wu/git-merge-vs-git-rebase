#!/bin/bash

# Demo: Simple Rebase Workflow
# This script demonstrates the recommended rebase workflow
# It creates a temporary git repo to show the process safely

set -e

DEMO_DIR="/tmp/git-rebase-demo-$$"
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}GIT REBASE DEMO - Simple Workflow${NC}"
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

echo -e "${GREEN}✓ New commit E added to main (simulating someone else's work)${NC}"
git log --oneline -5
echo ""

# Show branch divergence
echo -e "${BLUE}Step 4: Visualizing diverged branches${NC}"
echo -e "${YELLOW}Current state - branches are now diverged:${NC}"
echo ""
echo "main:    A---B---E"
echo "feature:       C---D"
echo ""

# Switch back to feature and do rebase
echo -e "${BLUE}Step 5: Rebasing feature onto main${NC}"
git checkout feature/login-form > /dev/null 2>&1

echo -e "${YELLOW}Running: git rebase main${NC}"
git rebase main > /dev/null 2>&1

echo -e "${GREEN}✓ Rebase successful! Commits C and D replayed on top of E${NC}"
echo ""

# Show new history
echo -e "${BLUE}Step 6: Viewing new history${NC}"
echo -e "${YELLOW}After rebase - clean linear history:${NC}"
echo ""
git log --oneline --graph main..HEAD
echo ""
git log --oneline
echo ""

# Show commit hashes changed
echo -e "${BLUE}Step 7: Understanding what changed${NC}"
echo -e "${YELLOW}The rebase created NEW commits with DIFFERENT hashes:${NC}"
echo "  C (old hash) → C' (new hash)"
echo "  D (old hash) → D' (new hash)"
echo ""
echo -e "${YELLOW}This is why we use: git push --force-with-lease${NC}"
echo ""

# Show differences
echo -e "${BLUE}Step 8: Summary${NC}"
echo -e "${GREEN}✓ Before rebase:${NC}"
echo "  - Feature branch: 2 commits (C, D)"
echo "  - Behind main: 1 commit (E)"
echo ""
echo -e "${GREEN}✓ After rebase:${NC}"
echo "  - Feature branch: 2 commits (C', D') on top of E"
echo "  - Linear history: A---B---E---C'---D'"
echo "  - No merge commit needed"
echo ""

# Show PR merge
echo -e "${BLUE}Step 9: Merging to main${NC}"
git checkout main > /dev/null 2>&1

echo -e "${YELLOW}Running: git merge feature/login-form${NC}"
git merge feature/login-form > /dev/null 2>&1

echo -e "${GREEN}✓ Fast-forward merge completed!${NC}"
echo ""
echo -e "${YELLOW}Final clean history:${NC}"
git log --oneline
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Demo Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Key takeaway: Rebase keeps history clean and linear."
echo -e "Use git rebase on your personal feature branches!"
echo ""
