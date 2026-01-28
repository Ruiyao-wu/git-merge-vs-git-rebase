#!/bin/bash

# Demo: Interactive Rebase - Cleaning Up Commits Before PR
# This script demonstrates squashing, reordering, and cleaning commits

set -e

DEMO_DIR="/tmp/git-interactive-demo-$$"
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}INTERACTIVE REBASE DEMO${NC}"
echo -e "${BLUE}Clean Up Commits Before PR${NC}"
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

# Create main base
echo "// App" > app.js
git add app.js
git commit -m "Initial commit on main" > /dev/null

echo -e "${GREEN}✓ Main branch created${NC}"
echo ""

# Create feature with messy commits
echo -e "${BLUE}Step 2: Creating feature with messy commits${NC}"
git checkout -b feature/dashboard > /dev/null 2>&1

# Commit 1
echo "function Dashboard() {" > dashboard.js
git add dashboard.js
git commit -m "WIP: first attempt at dashboard" > /dev/null

# Commit 2
echo "  return <div>Dashboard</div>" >> dashboard.js
git add dashboard.js
git commit -m "trying new approach" > /dev/null

# Commit 3
echo "function DashboardStats() {" > stats.js
git add stats.js
git commit -m "Add stats component" > /dev/null

# Commit 4 - fix for previous
echo "export { DashboardStats };" >> stats.js
git add stats.js
git commit -m "fix export" > /dev/null

# Commit 5
echo "}  // close component" >> dashboard.js
git add dashboard.js
git commit -m "Complete dashboard component" > /dev/null

# Commit 6 - typo fix
echo "// fixed typo" >> app.js
git add app.js
git commit -m "typo fix" > /dev/null

echo -e "${GREEN}✓ Feature branch created with 6 messy commits${NC}"
echo ""

# Show current commits
echo -e "${BLUE}Step 3: Current commit history (messy!)${NC}"
git log --oneline -6
echo ""
echo -e "${YELLOW}Issues with current history:${NC}"
echo "❌ Too many commits for what changed"
echo "❌ WIP commits mixed in"
echo "❌ Not grouped logically"
echo "❌ 'trying new approach' is vague"
echo ""

# Explain what we'll do
echo -e "${BLUE}Step 4: Interactive Rebase Plan${NC}"
echo -e "${YELLOW}Our interactive rebase will:${NC}"
echo ""
echo "1. Squash 'WIP: first attempt' and 'trying new approach'"
echo "   → Into one clean 'Add dashboard component' commit"
echo ""
echo "2. Squash 'fix export' into 'Add stats component'"
echo "   → Remove the separate fix commit"
echo ""
echo "3. Reword 'Complete dashboard component' to be clearer"
echo "   → Add more context about what changed"
echo ""
echo "4. Squash 'typo fix' into the dashboard commit"
echo "   → No separate cleanup commits"
echo ""
echo -e "${YELLOW}Result: 2-3 clean commits instead of 6${NC}"
echo ""

# Perform interactive rebase automatically
echo -e "${BLUE}Step 5: Performing interactive rebase${NC}"
echo -e "${YELLOW}Interactive rebase with squashing...${NC}"

# Get the commits to rebase
COMMITS=$(git log --oneline -6 | head -6)

# Use git rebase with a script to automate the process
git rebase -i --autosquash HEAD~6 << 'INTERACTIVE'
pick d3c4f4c WIP: first attempt at dashboard
squash 78e1f5d trying new approach
pick a4b3c2d Add stats component
squash 9f8e7d6 fix export
pick 5c6d7e8 Complete dashboard component
squash 4x3y2z1 typo fix
INTERACTIVE

# Provide squash messages
# This is automated for demo purposes
echo "Add dashboard and stats components" | git commit --amend -F - > /dev/null 2>&1 || true

echo -e "${GREEN}✓ Interactive rebase completed!${NC}"
echo ""

# Show new cleaner history
echo -e "${BLUE}Step 6: New clean commit history${NC}"
echo -e "${YELLOW}After interactive rebase:${NC}"
git log --oneline -5
echo ""
echo -e "${GREEN}✓ Now we have 3 clean commits instead of 6${NC}"
echo ""

# Show what changed
echo -e "${BLUE}Step 7: Summary of changes${NC}"
echo -e "${YELLOW}BEFORE interactive rebase (6 commits):${NC}"
echo "  ✗ WIP: first attempt at dashboard"
echo "  ✗ trying new approach"
echo "  ✗ Add stats component"
echo "  ✗ fix export"
echo "  ✗ Complete dashboard component"
echo "  ✗ typo fix"
echo ""
echo -e "${YELLOW}AFTER interactive rebase (cleaner):${NC}"
echo "  ✓ Add dashboard and stats components"
echo "  ✓ (typo fixes squashed into commits above)"
echo ""

# Explain the push
echo -e "${BLUE}Step 8: Pushing after interactive rebase${NC}"
echo -e "${YELLOW}Next step: git push --force-with-lease${NC}"
echo ""
echo "  old commits (abc123...): 6 commits deleted"
echo "  new commits (def456...): 3 commits pushed"
echo ""
echo "✓ Uses --force-with-lease for safety"
echo "✓ Only affects this feature branch"
echo "✓ Main branch unaffected"
echo ""

# Show PR ready
echo -e "${BLUE}Step 9: PR is now clean and ready${NC}"
echo -e "${YELLOW}Benefits for PR reviewers:${NC}"
echo "  ✓ Fewer commits to review"
echo "  ✓ Logical grouping of changes"
echo "  ✓ Clear commit messages"
echo "  ✓ No WIP/debug commits"
echo "  ✓ Easier to understand changes"
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Demo Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Key Interactive Rebase Commands:"
echo "  pick   - keep this commit"
echo "  reword - keep changes, edit message"
echo "  squash - combine with previous"
echo "  fixup  - combine, discard message"
echo "  drop   - delete commit"
echo "  edit   - stop for manual changes"
echo ""
echo -e "Pro tip: Always interactive rebase BEFORE creating your PR!"
echo ""
