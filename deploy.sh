#!/bin/bash

# Push changes to main branch first
git add . &&
git commit -m "Update content" &&
git push origin main &&

# Build and deploy to gh-pages
hugo &&
cd public &&
git add . &&
git commit -m "Updated site" &&
git push origin HEAD:gh-pages &&
cd ..