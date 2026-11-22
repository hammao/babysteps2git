#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCAD="$ROOT/scad/splitter_4way.scad"
OUT="$ROOT/stl"
mkdir -p "$OUT"
for part in cup catch_tray frame riffle_stage1 riffle_stage2 funnel; do
  echo "Rendering 4-way $part ..."
  openscad -o "$OUT/${part}.stl" -D "PART=\"${part}\"" "$SCAD"
done
echo "Done. Print: cup x4, riffle_stage2 x2, plus one each of catch_tray, frame, riffle_stage1, funnel."
