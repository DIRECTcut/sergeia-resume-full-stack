#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 || $# -gt 3 ]]; then
  echo "Usage: $0 <resume-file> <vacancy-file> [language]"
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HR_BREAKER_DIR="$ROOT_DIR/tools/hr-breaker"
ROOT_ENV_FILE="$ROOT_DIR/.env"
RESUME_FILE="$1"
VACANCY_FILE="$2"
LANGUAGE="${3:-ru}"

resolve_path() {
  local input_path="$1"
  local dir_name
  local base_name

  dir_name="$(cd "$(dirname "$input_path")" && pwd)"
  base_name="$(basename "$input_path")"
  printf '%s/%s\n' "$dir_name" "$base_name"
}

if [[ ! -d "$HR_BREAKER_DIR" ]]; then
  echo "hr-breaker is not set up yet. Run scripts/setup-hr-breaker.sh first."
  exit 1
fi

if [[ ! -f "$RESUME_FILE" ]]; then
  echo "Resume file not found: $RESUME_FILE"
  exit 1
fi

if [[ ! -f "$VACANCY_FILE" ]]; then
  echo "Vacancy file not found: $VACANCY_FILE"
  exit 1
fi

RESUME_FILE="$(resolve_path "$RESUME_FILE")"
VACANCY_FILE="$(resolve_path "$VACANCY_FILE")"

if [[ -f "$ROOT_ENV_FILE" ]]; then
  # Load repo-local credentials without printing them.
  set -a
  # shellcheck disable=SC1090
  source "$ROOT_ENV_FILE"
  set +a
fi

cd "$HR_BREAKER_DIR"
uv run hr-breaker optimize "$RESUME_FILE" "$VACANCY_FILE" -l "$LANGUAGE"
