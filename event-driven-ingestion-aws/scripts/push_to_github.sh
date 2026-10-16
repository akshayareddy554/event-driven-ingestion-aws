#!/usr/bin/env bash
# Usage: bash scripts/push_to_github.sh <github-username>
set -euo pipefail
USER=${1:?usage: push_to_github.sh <github-username>}
if grep -rniE "AKIA[0-9A-Z]{16}|aws_secret_access_key" . --exclude-dir=.git --exclude-dir=.venv; then
  echo "Possible secret found. Aborting."; exit 1
fi
git init -b main
git add .
git commit -m "Initial commit: event-driven ingestion on AWS (DynamoDB, SQS, SNS, Kinesis)"
if command -v gh >/dev/null; then
  gh repo create event-driven-ingestion-aws --public --source=. --remote=origin --push
else
  git remote add origin "https://github.com/$USER/event-driven-ingestion-aws.git"
  git push -u origin main
fi
