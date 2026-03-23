#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SHARED="$SCRIPT_DIR/shared.md"
CONF="$SCRIPT_DIR/sync.conf"

BEGIN_MARKER='<!-- SHARED:BEGIN -->'
END_MARKER='<!-- SHARED:END -->'

usage() {
  cat <<'EOF'
Usage: sync.sh <command>

Commands:
  push    Write shared.md into the SHARED:BEGIN/END region of every target
  diff    Show targets whose shared region has drifted from shared.md
  list    Show registered targets and whether the file exists
EOF
  exit 1
}

require_conf() {
  if [[ ! -f "$CONF" ]]; then
    echo "error: $CONF not found — copy sync.conf.example and edit paths" >&2
    exit 1
  fi
}

targets() {
  grep -v '^\s*#' "$CONF" | grep -v '^\s*$'
}

do_push() {
  require_conf
  local shared_content
  shared_content="$(cat "$SHARED")"
  local count=0

  while IFS= read -r target; do
    if [[ ! -f "$target" ]]; then
      echo "skip: $target (file not found)"
      continue
    fi

    if ! grep -qF "$BEGIN_MARKER" "$target"; then
      echo "skip: $target (no $BEGIN_MARKER marker)"
      continue
    fi

    # Build new file: before marker, marker+content+marker, after marker
    local tmp
    tmp="$(mktemp)"
    awk -v begin="$BEGIN_MARKER" -v end="$END_MARKER" -v content="$shared_content" '
      $0 == begin { print; print content; skip=1; next }
      $0 == end   { skip=0 }
      skip        { next }
                  { print }
    ' "$target" > "$tmp"

    if diff -q "$target" "$tmp" > /dev/null 2>&1; then
      echo "ok:   $target (no change)"
    else
      cp "$tmp" "$target"
      echo "push: $target (updated)"
      count=$((count + 1))
    fi
    rm -f "$tmp"
  done < <(targets)

  echo "--- $count file(s) updated"
}

do_diff() {
  require_conf
  local drifted=0

  while IFS= read -r target; do
    if [[ ! -f "$target" ]]; then
      continue
    fi
    if ! grep -qF "$BEGIN_MARKER" "$target"; then
      continue
    fi

    # Extract current shared region
    local current
    current="$(awk -v begin="$BEGIN_MARKER" -v end="$END_MARKER" '
      $0 == begin { skip=1; next }
      $0 == end   { skip=0; next }
      skip        { print }
    ' "$target")"

    if ! diff -q <(echo "$current") "$SHARED" > /dev/null 2>&1; then
      echo "drift: $target"
      diff --color=auto -u "$SHARED" <(echo "$current") | head -30
      echo "..."
      drifted=$((drifted + 1))
    fi
  done < <(targets)

  if [[ $drifted -eq 0 ]]; then
    echo "all targets in sync"
  else
    echo "--- $drifted file(s) drifted"
  fi
}

do_list() {
  require_conf
  while IFS= read -r target; do
    if [[ -f "$target" ]]; then
      if grep -qF "$BEGIN_MARKER" "$target"; then
        echo "ok:     $target"
      else
        echo "no-tag: $target (missing markers)"
      fi
    else
      echo "miss:   $target"
    fi
  done < <(targets)
}

case "${1:-}" in
  push) do_push ;;
  diff) do_diff ;;
  list) do_list ;;
  *)    usage ;;
esac
