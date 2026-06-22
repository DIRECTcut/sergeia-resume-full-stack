#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <base-name>" >&2
  exit 1
fi

base_name="$1"
slug="$(printf '%s' "$base_name" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-+/-/g')"

if [[ -z "$slug" ]]; then
  slug="application-form"
fi

mkdir -p tmp/application-forms
output_path="tmp/application-forms/${slug}.txt"
cat > "$output_path"
printf '%s\n' "$output_path"
