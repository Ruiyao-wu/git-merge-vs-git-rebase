#!/bin/bash

# Demo: Handling Merge Conflicts During Rebase
# This script demonstrates what happens when conflicts occur and how to resolve them

set -e

DEMO_DIR="/tmp/git-conflicts-demo-$$"
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}GIT CONFLICT DEMO - Rebase with Conflicts${NC}"
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

# Create initial content on main
cat > form.js << 'EOF'
// Login Form Handler
function handleLogin() {
  const username = document.getElementById('username').value;
  const password = document.getElementById('password').value;
  
  if (!username || !password) {
    alert('Please enter username and password');
    return;
  }
  
  // Submit to server
  submitForm({ username, password });
}
EOF

git add form.js
git commit -m "A: Create login form handler" > /dev/null

echo -e "${GREEN}✓ Initial commit A on main${NC}"
echo ""

# Create feature branch
echo -e "${BLUE}Step 2: Creating feature branch${NC}"
git checkout -b feature/validation > /dev/null 2>&1

# Add validation in feature
cat > form.js << 'EOF'
// Login Form Handler
function handleLogin() {
  const username = document.getElementById('username').value;
  const password = document.getElementById('password').value;
  
  // Feature branch change: Add validation
  if (!username.includes('@')) {
    alert('Username must be an email');
    return;
  }
  
  if (password.length < 8) {
    alert('Password must be at least 8 characters');
    return;
  }
  
  // Submit to server
  submitForm({ username, password });
}
EOF

git add form.js
git commit -m "C: Add email validation" > /dev/null

echo -e "${GREEN}✓ Feature branch commit C (adds email validation)${NC}"
echo ""

# Simulate different change on main
echo -e "${BLUE}Step 3: Someone else modifies the same file on main${NC}"
git checkout main > /dev/null 2>&1

cat > form.js << 'EOF'
// Login Form Handler
function handleLogin() {
  console.log('Login attempt');  // Main branch change
  const username = document.getElementById('username').value;
  const password = document.getElementById('password').value;
  
  if (!username || !password) {
    alert('Please enter username and password');
    return;
  }
  
  // Main branch change: Add security header
  const headers = { 'X-CSRF-Token': getCsrfToken() };
  
  // Submit to server with headers
  submitFormSecure({ username, password }, headers);
}
EOF

git add form.js
git commit -m "B: Add security headers to submission" > /dev/null

echo -e "${GREEN}✓ Main branch commit B (adds security headers)${NC}"
echo ""

# Show divergence
echo -e "${BLUE}Step 4: Visualizing the conflict scenario${NC}"
echo -e "${YELLOW}Both branches modified form.js:${NC}"
echo ""
echo "main:       A---B (added security headers)"
echo "feature:        C (added email validation)"
echo ""
echo -e "${MAGENTA}Both modified the same area → CONFLICT${NC}"
echo ""

# Try to rebase and see conflict
echo -e "${BLUE}Step 5: Attempting to rebase${NC}"
git checkout feature/validation > /dev/null 2>&1

echo -e "${YELLOW}Running: git rebase main${NC}"
git rebase main > /dev/null 2>&1 || {
    echo -e "${RED}✗ Conflict detected!${NC}"
    echo ""
}

echo -e "${YELLOW}Git stopped and says:${NC}"
git status | head -20
echo ""

# Show conflicted file
echo -e "${BLUE}Step 6: Examining the conflicted file${NC}"
echo -e "${YELLOW}Content of form.js:${NC}"
echo ""
cat form.js
echo ""

# Resolve the conflict
echo -e "${BLUE}Step 7: Resolving the conflict manually${NC}"
echo -e "${YELLOW}We want to KEEP BOTH changes${NC}"
echo ""

cat > form.js << 'EOF'
// Login Form Handler
function handleLogin() {
  console.log('Login attempt');  // From main
  const username = document.getElementById('username').value;
  const password = document.getElementById('password').value;
  
  // From feature: Add validation
  if (!username.includes('@')) {
    alert('Username must be an email');
    return;
  }
  
  if (password.length < 8) {
    alert('Password must be at least 8 characters');
    return;
  }
  
  // From main: Add security header
  const headers = { 'X-CSRF-Token': getCsrfToken() };
  
  // Submit to server with headers
  submitFormSecure({ username, password }, headers);
}
EOF

echo -e "${YELLOW}Fixed file to include both:${NC}"
echo "✓ Security headers (from main)"
echo "✓ Email validation (from feature)"
echo ""

# Mark resolved
echo -e "${BLUE}Step 8: Marking conflict as resolved${NC}"
git add form.js > /dev/null

echo -e "${YELLOW}Running: git add form.js${NC}"
git status | grep "both modified"
echo ""

# Continue rebase
echo -e "${BLUE}Step 9: Continuing the rebase${NC}"
echo -e "${YELLOW}Running: git rebase --continue${NC}"
git rebase --continue > /dev/null 2>&1

echo -e "${GREEN}✓ Rebase completed!${NC}"
echo ""

# Show final state
echo -e "${BLUE}Step 10: Viewing final history${NC}"
echo -e "${YELLOW}Final clean history:${NC}"
echo ""
git log --oneline -5
echo ""

echo -e "${YELLOW}Content of resolved file:${NC}"
cat form.js
echo ""

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Demo Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "Summary:"
echo "1. Both branches modified form.js → conflict"
echo "2. Git stopped and asked us to resolve"
echo "3. We edited the file to keep both changes"
echo "4. Marked it resolved with git add"
echo "5. Continued rebase with git rebase --continue"
echo ""
echo -e "Key takeaway:"
echo "✓ Conflicts are manageable"
echo "✓ git rebase --abort cancels if too complex"
echo "✓ Use your editor to resolve carefully"
echo "✓ Always test the merged result"
echo ""
