#!/usr/bin/env bash
#
# @input:  None (operates on current git repository)
# @output: A fresh git repository with a single commit on main containing the
#          current working tree state. All prior history is destroyed.
# @scenario: Squash entire git history into one clean starting commit while
#            preserving the exact working directory as-is.

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

# -------------------------------------------------------------------
# Step 0: Pre-flight checks
# -------------------------------------------------------------------
echo "[CHECK] Verifying we are on main branch..."
CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$CURRENT_BRANCH" != "main" ]]; then
    echo "[ERROR] This script only operates on the 'main' branch."
    echo "[ERROR] Current branch: $CURRENT_BRANCH"
    exit 1
fi

echo "[CHECK] Ensuring working tree is clean (no uncommitted changes)..."
if ! git diff-index --quiet HEAD --; then
    echo "[ERROR] Working tree has uncommitted changes. Please commit or stash them first."
    git status --short
    exit 1
fi

# -------------------------------------------------------------------
# Step 1: Create orphan branch with no history, stage everything
# -------------------------------------------------------------------
echo "[SQUASH] Creating orphan branch with zero history..."
git checkout --orphan main-squash-tmp

echo "[SQUASH] Staging all working tree files..."
git add -A

echo "[SQUASH] Creating single squashed commit..."
git commit -m "Initial commit (history squashed on ${TIMESTAMP})"

# -------------------------------------------------------------------
# Step 2: Replace main with the orphan branch
# -------------------------------------------------------------------
echo "[REPLACE] Replacing main branch with squashed commit..."
git branch -D main
git branch -m main-squash-tmp main

# -------------------------------------------------------------------
# Step 3: Force push to remote
# -------------------------------------------------------------------
echo "[PUSH] Force pushing ONLY main to origin (no other branches/tags touched)..."
git push origin +main:main

echo ""
echo "[SUCCESS] main branch squashed & force pushed to origin."
echo "  New HEAD: $(git rev-parse --short HEAD)"
echo ""
