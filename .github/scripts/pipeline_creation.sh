#!/bin/bash

set -e

# Get the necessary environment variables
SOURCE_BRANCH=$SOURCE_BRANCH
TARGET_BRANCH=$TARGET_BRANCH
PIPELINE_BRANCH=$PIPELINE_BRANCH
PR_NUMBER=$PR_NUMBER

# Configure git
git config --global user.email "github-actions[bot]@users.noreply.github.com"
git config --global user.name "github-actions[bot]"

# Exit if source branch starts with 'gh-pipeline'
if [[ $SOURCE_BRANCH == gh-pipeline* ]]; then
  echo "Source branch starts with 'gh-pipeline'. Skipping jobs."
  exit 0
fi

# Check if the pipeline branch exists
if git rev-parse --verify --quiet "origin/${PIPELINE_BRANCH}"; then
  echo "Pipeline branch exists. Merging PR source branch into pipeline branch..."
  git checkout "${PIPELINE_BRANCH}"
  git pull origin "${PIPELINE_BRANCH}"
  git merge "origin/${SOURCE_BRANCH}" --no-edit
  git push origin "${PIPELINE_BRANCH}"
else
  echo "Pipeline branch does not exist. Creating pipeline branch from source branch..."
  git checkout -b "${PIPELINE_BRANCH}" "origin/${SOURCE_BRANCH}"
  git push origin "${PIPELINE_BRANCH}"
fi

# Check if a PR exists with the pipeline branch as source
EXISTING_PR=$(gh pr list --state open --base "${TARGET_BRANCH}" --head "${PIPELINE_BRANCH}" --json number --jq '.[].number')

if [ -z "$EXISTING_PR" ]; then
  echo "No existing PR from pipeline branch. Creating a new PR..."
  
  NEW_PR=$(gh pr create --base "${TARGET_BRANCH}" --head "${PIPELINE_BRANCH}" --title "Pipeline PR from ${PIPELINE_BRANCH} to ${TARGET_BRANCH}" --body "This PR is created for the pipeline of original PR: #${PR_NUMBER}" --json number --jq '.number')
  
  echo "Pipeline PR created: #${NEW_PR}"

  # Add a comment to the original PR
  gh pr comment "${PR_NUMBER}" --body "A new PR was created for pipeline: #${NEW_PR}"

  # Close the original PR
  gh pr close "${PR_NUMBER}"
else
  echo "Pipeline PR already exists: #${EXISTING_PR}"
fi
