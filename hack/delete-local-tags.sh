#!/bin/bash
set -euo pipefail

# Delete every local tag (no-op when there are none).
git tag -l | xargs -r git tag -d
