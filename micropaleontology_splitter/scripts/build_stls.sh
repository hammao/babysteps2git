#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCAD="$ROOT/scad/splitter.scad"
OUT="$ROOT/stl"
mkdir -p "$OUT"
for part in cup catch_tray frame riffle funnel; do
  echo "Rendering $part ..."
  openscad -o "$OUT/${part}.stl" -D "PART=\"${part}\"" "$SCAD"
done
echo "Done. Print cup.stl x4, plus one each of catch_tray, frame, riffle, funnel."
