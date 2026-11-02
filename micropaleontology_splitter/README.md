# Micropaleontology dry-sediment splitter (2-way, 4 cups)

Gravity-fed **Jones-style riffle splitter** for dried sediment samples. Sediment is split **1:1 into two streams**; the catch tray holds **four separate removable cups** (active pair A1/B1 under the outlets, spare pair A2/B2 for sequential splits).

This redesign replaces the earlier single fused STL that printed as an unusable solid block. Every functional cavity is modeled with `difference()`, and each piece is a separate printable body.

## Parts to print

| STL | Qty | Role |
|-----|-----|------|
| `stl/cup.stl` | **4** | Removable collection cups |
| `stl/catch_tray.stl` | 1 | Secondary spill tub + 4 cup bays + rails |
| `stl/riffle.stl` | 1 | 12 alternating chutes → left / right |
| `stl/funnel.stl` | 1 | Large anti-spill funnel |

`stl/original_solid_block.stl` is the prior failed design, kept for reference only — do not print.

## Assemble

1. Seat four cups in the tray bays (`A1`/`B1` front = active; `A2`/`B2` rear = spare).
2. Rest the riffle body on the front rails above `A1`/`B1`.
3. Drop the funnel sleeve into the riffle collar.
4. Pour dried sediment into the funnel; collect the two halves in `A1` and `B1`.
5. For further halving, swap in the spare cups and re-split one aliquot.

## Print settings (FDM)

- Material: PLA or PETG
- Layer height: 0.20 mm (0.12 mm optional on riffle for cleaner chute edges)
- Perimeters: ≥ 3 · Infill: 20–30% · No supports needed for these orientations
- Suggested orientation: cups/tray/funnel flat on their bases; riffle on its base (collar up)
- Clearance between mates is 0.5 mm — dry-fit and lightly sand if your printer runs hot/large

## Rebuild STLs

```bash
chmod +x scripts/build_stls.sh
./scripts/build_stls.sh
```

Or open `scad/splitter.scad` in OpenSCAD, set `PART` to `cup` / `catch_tray` / `riffle` / `funnel`, and export.

Preview-only modes (do not slice): `assembly`, `tray_with_cups`, `exploded`.

## Design notes

- **2-way split:** 12 chutes, even count, alternating left/right exits.
- **Chute width:** 5 mm — suitable for fine dried sediment; widen in the SCAD parameters if grains bridge.
- **Secondary container:** the catch tray rim retains spills that miss a cup.
- **Accuracy** of the split vs. a calibrated lab Jones splitter is unverified until you test with your sediment.

## Parameters

Tunable at the top of `scad/splitter.scad`: wall thickness, cup size, chute count/width, funnel mouth, and nest gaps.
