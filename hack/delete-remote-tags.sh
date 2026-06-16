#!/bin/bash
set -euo pipefail

# Delete every tag on the origin remote (no-op when there are none).
git fetch --tags
git tag -l | xargs -r git push origin --delete
