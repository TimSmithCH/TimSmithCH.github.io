#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

GITHUB_USER="TimSmithCH"
GITHUB_EMAIL="tim.smith@cern.ch"
TARGET_BRANCH="gen_tracks"

# Save some useful information
REPO=`git config remote.origin.url`
TOKEN_REPO=${REPO/github.com/$GITHUB_USER:$GITHUB_TOKEN@github.com}

# Prepare for push
mv tracks/gpx/*.geojson tracks/geojson/
git config user.name ${GITHUB_USER}
git config user.email ${GITHUB_EMAIL}

# If there are no changes to the compiled out (e.g. this is a README update) then just bail.
if git diff --quiet; then
    echo "No changes to the output on this push; exiting."
    exit 0
fi

# Commit the "changes", i.e. the new version.
# The delta will show diffs between new and old versions.
git add -A tracks/geojson/*
git commit -m "Upload generated geojson tracks"

# Now that we're all set up, we can push.
git push $TOKEN_REPO $TARGET_BRANCH
