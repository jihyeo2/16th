#!/bin/bash

hugo &&
cd public &&
git add . &&
git commit -m "Updated site" &&
git push origin gh-pages &&
cd ..