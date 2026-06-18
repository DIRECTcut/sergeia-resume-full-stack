#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS_DIR="$ROOT_DIR/tools"
HR_BREAKER_DIR="$TOOLS_DIR/hr-breaker"
HR_BREAKER_REPO_URL="${HR_BREAKER_REPO_URL:-https://github.com/btseytlin/hr-breaker.git}"
HR_BREAKER_REF="${HR_BREAKER_REF:-a6a3cbe166f5f285ac2c5f888b201d42c5d6ac67}"

mkdir -p "$TOOLS_DIR"

if [[ ! -d "$HR_BREAKER_DIR/.git" ]]; then
  git clone "$HR_BREAKER_REPO_URL" "$HR_BREAKER_DIR"
fi

cd "$HR_BREAKER_DIR"
git fetch --tags origin
git checkout "$HR_BREAKER_REF"
uv sync

if [[ ! -f ".env" ]]; then
  cp .env.example .env
  echo "Created $HR_BREAKER_DIR/.env from .env.example"
  echo "Set your LLM provider API key there before running optimization."
fi

echo "hr-breaker is ready in $HR_BREAKER_DIR at $HR_BREAKER_REF"
