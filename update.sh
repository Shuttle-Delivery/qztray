#!/bin/bash

# Exit immediately if any command fails
set -e

echo "Fetching updates from upstream master..."
git fetch upstream master

echo "Checking out master branch, if not already..."
git checkout master

echo "Checking changes from upstream/master..."
git log master..upstream/master --oneline

echo "Merging upstream/master into local master..."
git merge upstream/master

echo "Pushing updated master to origin..."
git push origin master

echo "✅ Done: Your master branch is now synced with upstream and pushed to origin."