#!/bin/bash

# Exit immediately if any command fails
set -e

echo "Fetching updates from upstream..."
git fetch upstream

echo "Checking out master branch..."
git checkout master

echo "Merging upstream/master into local master..."
git merge upstream/master

echo "Pushing updated master to origin..."
git push origin master

echo "✅ Done: Your master branch is now synced with upstream and pushed to origin."