#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
# Keycloak Sizing — one-time GitHub Pages setup
# Usage: bash setup.sh YOUR_GITHUB_USERNAME
# Requires: git, gh (GitHub CLI) — https://cli.github.com
# ─────────────────────────────────────────────────────────────────
set -e

USERNAME="${1:-}"
REPO="keycloak-sizing"

if [[ -z "$USERNAME" ]]; then
  echo "Usage: bash setup.sh YOUR_GITHUB_USERNAME"
  exit 1
fi

echo ""
echo "▶ Setting up: https://github.com/$USERNAME/$REPO"
echo ""

# Check dependencies
command -v git >/dev/null || { echo "❌ git not found. Install from https://git-scm.com"; exit 1; }
command -v gh  >/dev/null || { echo "❌ gh not found. Install from https://cli.github.com"; exit 1; }

# Auth check
gh auth status 2>/dev/null || {
  echo ""
  echo "⚠  Not logged in to GitHub CLI. Running: gh auth login"
  gh auth login
}

echo "✅ Authenticated as: $(gh api user --jq .login)"
echo ""

# Create the repo (public, with Pages enabled)
if gh repo view "$USERNAME/$REPO" &>/dev/null; then
  echo "ℹ  Repo already exists: github.com/$USERNAME/$REPO"
else
  gh repo create "$REPO" \
    --public \
    --description "Keycloak full-stack sizing calculator — Red Hat Build of Keycloak v26.x" \
    --homepage "https://$USERNAME.github.io/$REPO/" \
    --confirm 2>/dev/null || \
  gh repo create "$USERNAME/$REPO" \
    --public \
    --description "Keycloak full-stack sizing calculator — Red Hat Build of Keycloak v26.x"
  echo "✅ Created: github.com/$USERNAME/$REPO"
fi

echo ""

# Init git if needed
if [[ ! -d ".git" ]]; then
  git init
  git branch -M main
fi

# Configure remote
git remote remove origin 2>/dev/null || true
git remote add origin "https://github.com/$USERNAME/$REPO.git"

# Update README with actual URL
sed -i.bak "s/YOUR_USERNAME/$USERNAME/g" README.md && rm -f README.md.bak

# Commit and push
git add -A
git commit -m "🔐 Add Keycloak sizing calculator" --allow-empty
git push -u origin main --force

echo ""
echo "✅ Pushed to GitHub!"
echo ""

# Enable Pages via GitHub API (source: GitHub Actions)
echo "▶ Enabling GitHub Pages..."
gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  "/repos/$USERNAME/$REPO/pages" \
  -f "source[branch]=main" \
  -f "build_type=workflow" 2>/dev/null || \
gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  "/repos/$USERNAME/$REPO/pages" \
  -f "build_type=workflow" 2>/dev/null || \
echo "ℹ  Pages may already be enabled — check Settings → Pages in your repo."

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Done! Your tool will be live in ~60 seconds at:"
echo ""
echo "   https://$USERNAME.github.io/$REPO/"
echo ""
echo "Future updates: edit index.html, then git push."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
