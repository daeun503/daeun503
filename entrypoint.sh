#!/usr/bin/env bash
set -euo pipefail

cd /home/runner

export PATH="/opt/venv/bin:$PATH"

is_configured() {
  [[ -f ".runner" && -f ".credentials" ]]
}

if is_configured; then
  echo ">> Runner already configured. Starting runner..."
  exec ./run.sh
fi

echo ">> Runner not configured yet. Running initial configuration..."

: "${RUNNER_TOKEN:?RUNNER_TOKEN is required}"

REPO_URL="${REPO_URL:-https://github.com/daeun503/daeun503}"
RUNNER_NAME="${RUNNER_NAME:-docker-runner-$(hostname)}"
RUNNER_LABELS="${RUNNER_LABELS:-self-hosted,docker}"

./config.sh --unattended \
  --url "${REPO_URL}" \
  --token "${RUNNER_TOKEN}" \
  --name "${RUNNER_NAME}" \
  --labels "${RUNNER_LABELS}"

echo ">> Initial configuration done. Starting runner..."
exec ./run.sh
