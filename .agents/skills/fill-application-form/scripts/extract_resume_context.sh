#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: $0 <resume-path>" >&2
  exit 1
fi

resume_path="$1"

if [[ ! -f "$resume_path" ]]; then
  echo "resume not found: $resume_path" >&2
  exit 1
fi

case "$resume_path" in
  *.docx) ;;
  *)
    echo "unsupported resume format: $resume_path (expected .docx)" >&2
    exit 1
    ;;
esac

hash_cmd=""
if command -v sha256sum >/dev/null 2>&1; then
  hash_cmd="sha256sum"
elif command -v shasum >/dev/null 2>&1; then
  hash_cmd="shasum -a 256"
else
  echo "missing sha256 tool" >&2
  exit 1
fi

cache_dir="tmp/application-forms/.cache"
log_path="${cache_dir}/extraction.log.tsv"
mkdir -p "$cache_dir"

resume_hash="$($hash_cmd "$resume_path" | awk '{print $1}')"
resume_name="$(basename "$resume_path" .docx)"
safe_name="$(printf '%s' "$resume_name" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//; s/-+/-/g')"
cache_path="${cache_dir}/${safe_name}-${resume_hash}.txt"

start_ns="$(date +%s%N)"
cache_hit=0

if [[ ! -f "$cache_path" ]]; then
  unzip -p "$resume_path" word/document.xml \
    | perl -0pe 's/<w:p[^>]*>/\n/g; s/<w:br\/?[^>]*>/\n/g; s/<[^>]+>//g; s/&amp;/\&/g; s/&lt;/</g; s/&gt;/>/g; s/\r//g; s/\n[ \t]*/\n/g; s/\n{3,}/\n\n/g;' \
    > "$cache_path"
else
  cache_hit=1
fi

end_ns="$(date +%s%N)"
duration_ms="$(( (end_ns - start_ns) / 1000000 ))"
timestamp_utc="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

printf '%s\t%s\t%s\t%s\t%s\n' \
  "$timestamp_utc" \
  "$resume_path" \
  "$resume_hash" \
  "$cache_hit" \
  "$duration_ms" >> "$log_path"

printf '%s\n' "$cache_path"
