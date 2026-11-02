#!/usr/bin/env bash
# Export printable STLs from the OpenSCAD source.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCAD="$ROOT/scad/splitter.scad"
OUT="$ROOT/stl"
mkdir -p "$OUT" "$ROOT/render"

for part in cup catch_tray riffle funnel; do
  echo "Rendering $part ..."
  openscad -o "$OUT/${part}.stl" -D "PART=\"${part}\"" "$SCAD"
done

echo "Done. Print cup.stl ×4, plus one each of catch_tray, riffle, funnel."
