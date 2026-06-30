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

tmp_input="$(mktemp)"
trap 'rm -f "$tmp_input"' EXIT
cat > "$tmp_input"

warning_regex='Needs user confirmation|[Nn]eeds confirmation|confirm with user|[Nn]eeds user input|[Tt]entative'

if rg -n "$warning_regex" "$tmp_input" >/dev/null 2>&1; then
  awk '
    BEGIN {
      inserted = 0
    }
    {
      print $0
      if (!inserted && /^Source: /) {
        print ""
        print "WARNING: This draft contains tentative answers that need user confirmation before submission."
        inserted = 1
      }
    }
    END {
      if (!inserted) {
        print "WARNING: This draft contains tentative answers that need user confirmation before submission."
        print ""
      }
    }
  ' "$tmp_input" > "$output_path"
else
  cat "$tmp_input" > "$output_path"
fi

printf '%s\n' "$output_path"
