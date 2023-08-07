#!/usr/bin/env bash

MAIN_BRANCH=main
TARGET_BRANCH=gh-pages
WTREE_DIR=./.worktree
DATETIME=$(date)
COMMIT_MSG="Updated GitHub Pages ($DATETIME)"

# Prepare worktree directory
mkdir -p $WTREE_DIR
git worktree add $WTREE_DIR $TARGET_BRANCH

# Build output files and add them to worktree
mdbook build
rsync -av book/ $WTREE_DIR/

# Commit changes in worktree
pushd $WTREE_DIR
git add -A
git commit -m "$COMMIT_MSG"
popd

# Cleanup
git worktree remove $WTREE_DIR
rm -rf $WTREE_DIR

# Commit changes in main branch
git add src
git commit -m "$COMMIT_MSG"

# Push changes to remote origin (GitHub)
git push origin $MAIN_BRANCH
git push origin $TARGET_BRANCH

