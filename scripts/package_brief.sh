#!/usr/bin/env bash
# Zip one take-home (brief + data) for sending to a mentee.
#
# Usage: scripts/package_brief.sh <take-home-folder> [output.zip]
# Example: scripts/package_brief.sh kestrel-cycles-support

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
name="${1:?usage: scripts/package_brief.sh <take-home-folder> [output.zip]}"
name="${name%/}"

if [[ "$name" == scripts* || ! -f "$repo_root/$name/README.md" ]]; then
  echo "error: '$name' is not a take-home folder" >&2
  exit 1
fi

out="${2:-$repo_root/$name.zip}"
case "$out" in /*) ;; *) out="$PWD/$out" ;; esac
rm -f "$out"
(cd "$repo_root" && zip -qr "$out" "$name" -x '*.DS_Store')
echo "wrote $out"
