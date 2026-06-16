#!/bin/bash
set -euo pipefail

# Version source of truth: the `const Version` in main.go (the same line that
# `make release` greps). Keeps the changelog version aligned with the release tag.
NEXT_TAG=$(grep 'const Version =' main.go | cut -d'"' -f2)
PREV_VERSION=$(git describe --tags "$(git rev-list --tags --max-count=1)")
NEW_HASH=$(git rev-parse --verify HEAD)

OUTPUT=$(git log "${PREV_VERSION}..${NEW_HASH}" --no-merges \
  --pretty=format:'* [view commit](http://github.com/AndriyKalashnykov/gotest/commit/%H) %s' --reverse)

{
  echo "<!-- START ${NEXT_TAG} -->"
  echo "## ${NEXT_TAG}"
  echo ""
  echo "${OUTPUT}"
  echo "<!-- END ${NEXT_TAG} -->"
  echo ""
} >> CHANGELOG.md
