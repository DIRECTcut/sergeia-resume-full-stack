#!/usr/bin/env bash
set -euo pipefail

base_name="${1:-cover-letter}"
slug="$(printf '%s' "$base_name" \
  | tr '[:upper:]' '[:lower:]' \
  | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-{2,}/-/g')"

if [[ -z "$slug" ]]; then
  slug="cover-letter"
fi

out_dir="tmp/cover-letters"
mkdir -p "$out_dir"
out_path="$out_dir/$slug.txt"

cat > "$out_path"
printf '%s\n' "$out_path"
