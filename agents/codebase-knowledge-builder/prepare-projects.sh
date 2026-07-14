#!/usr/bin/env bash
set -euo pipefail

SOURCE_ROOT="${CODEBASE_SOURCE_ROOT:-$HOME/Documents/myData/sourceCode}"
KNOWLEDGE_ROOT="${CODEBASE_KNOWLEDGE_ROOT:-$HOME/.codex/projects}"
CODEGRAPH_BIN="${CODEGRAPH_BIN:-codegraph}"

usage() {
  printf '%s\n' \
    "Usage:" \
    "  $0 list" \
    "  $0 prepare-all" \
    "  $0 prepare <project-name-or-path>" \
    "  $0 status-all"
}

die() {
  printf 'ERROR\t%s\n' "$*" >&2
  exit 1
}

require_runtime() {
  [ -d "$SOURCE_ROOT" ] || die "source root not found: $SOURCE_ROOT"
  [ -x "$CODEGRAPH_BIN" ] || die "CodeGraph not executable: $CODEGRAPH_BIN"
}

canonical_source_root() {
  realpath -e "$SOURCE_ROOT"
}

discover_projects() {
  find "$(canonical_source_root)" -mindepth 1 -maxdepth 1 -type d ! -name '.*' -print0 |
    sort -z
}

resolve_project() {
  local requested="$1"
  local root candidate
  root="$(canonical_source_root)"

  if [ -d "$requested" ]; then
    candidate="$(realpath -e "$requested")"
  else
    candidate="$(realpath -e "$root/$requested" 2>/dev/null || true)"
  fi

  [ -n "$candidate" ] || die "project not found: $requested"
  [ "$(dirname "$candidate")" = "$root" ] || die "project must be an immediate folder of $root: $candidate"
  case "$(basename "$candidate")" in
    .*) die "hidden directories are not projects: $candidate" ;;
  esac
  printf '%s\n' "$candidate"
}

source_fingerprint() {
  local project="$1"
  (
    cd "$project"
    while IFS= read -r -d '' file; do
      relative="${file#./}"
      printf '%s\0' "$relative"
      sha256sum "$file"
    done < <(
      find . \
        \( -type d \( -name .git -o -name .codegraph -o -name node_modules -o -name vendor -o -name target -o -name build -o -name dist -o -name .venv -o -name .next \) -prune \) -o \
        -type f -print0 | sort -z
    )
  ) | sha256sum | awk '{print $1}'
}

git_revision() {
  local project="$1"
  git -C "$project" rev-parse HEAD 2>/dev/null || printf 'NO_GIT'
}

prepare_one() {
  local project name knowledge_dir action fingerprint revision
  project="$(resolve_project "$1")"
  name="$(basename "$project")"
  knowledge_dir="$KNOWLEDGE_ROOT/$name"
  mkdir -p "$KNOWLEDGE_ROOT"
  mkdir -p "$knowledge_dir/runs"

  if [ -d "$project/.codegraph" ]; then
    action="sync"
    CODEGRAPH_NO_DAEMON=1 CODEGRAPH_TELEMETRY=0 "$CODEGRAPH_BIN" sync "$project"
  else
    action="init"
    CODEGRAPH_NO_DAEMON=1 CODEGRAPH_TELEMETRY=0 "$CODEGRAPH_BIN" init "$project"
  fi

  fingerprint="$(source_fingerprint "$project")"
  revision="$(git_revision "$project")"
  printf 'PROJECT\t%s\t%s\t%s\t%s\t%s\t%s\n' "$name" "$project" "$knowledge_dir" "$action" "$revision" "$fingerprint"
  CODEGRAPH_NO_DAEMON=1 CODEGRAPH_TELEMETRY=0 "$CODEGRAPH_BIN" status "$project"
}

list_projects() {
  local project name knowledge_dir indexed manifest
  while IFS= read -r -d '' project; do
    name="$(basename "$project")"
    knowledge_dir="$KNOWLEDGE_ROOT/$name"
    indexed="no"
    manifest="no"
    [ -d "$project/.codegraph" ] && indexed="yes"
    [ -f "$knowledge_dir/knowledge-manifest.md" ] && manifest="yes"
    printf 'PROJECT\t%s\t%s\t%s\t%s\t%s\n' "$name" "$project" "$knowledge_dir" "$indexed" "$manifest"
  done < <(discover_projects)
}

prepare_all() {
  local project
  while IFS= read -r -d '' project; do
    prepare_one "$project"
  done < <(discover_projects)
}

status_all() {
  local project
  while IFS= read -r -d '' project; do
    printf 'STATUS\t%s\t%s\n' "$(basename "$project")" "$project"
    CODEGRAPH_NO_DAEMON=1 CODEGRAPH_TELEMETRY=0 "$CODEGRAPH_BIN" status "$project" || true
  done < <(discover_projects)
}

require_runtime

case "${1:-}" in
  list)
    list_projects
    ;;
  prepare-all)
    prepare_all
    ;;
  prepare)
    [ "$#" -eq 2 ] || die "usage: $0 prepare <project-name-or-path>"
    prepare_one "$2"
    ;;
  status-all)
    status_all
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    die "usage: $0 {list|prepare-all|prepare <project>|status-all}"
    ;;
esac
