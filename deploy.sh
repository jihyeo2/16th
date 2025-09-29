#!/bin/bash

# Push changes to main branch first
git add . &&
git commit -m "🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>" &&
git push origin main &&

# Build and deploy to gh-pages
hugo &&
cd public &&
git add . &&
git commit -m "Updated site - Added category toggle system

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>" &&
git push origin gh-pages &&
cd ..