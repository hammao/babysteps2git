# Micropaleontology dry-sediment splitter (Jones-type, 2-way)

A **classic Jones micro-riffle** layout for dried sediment — the same family of tool used in micropaleontology labs — rebuilt as **separate hollow printable parts** (the earlier single STL fused into an unusable solid).

```
        ┌─────────────────────┐
        │   LARGE FUNNEL      │  ← anti-spill hopper
        └─────────┬───────────┘
                  │
           ╱│╱│╱│╱│╱│╱│╲│╲     ← alternating vanes (1:1 split)
        ───╱  L   │   R  ╲───  ← A-frame side discharges
              ↓       ↓
            [A1]    [B1]       ← active pans (print 4 total)
            [A2]    [B2]       ← spare pans for sequential splits
        └─────────────────────┘  ← secondary spill tray + stand
```

Still a **2-way** splitter (left / right). Four cups = two under the outlets + two spares, like commercial Jones kits that ship four pans.

## Print list

| Part | Qty | STL |
|------|-----|-----|
| Hi-back pan / cup | **4** | `stl/cup.stl` |
| Spill catch tray | 1 | `stl/catch_tray.stl` |
| Open stand / frame | 1 | `stl/frame.stl` |
| Riffle bank (12 chutes) | 1 | `stl/riffle.stl` |
| Funnel | 1 | `stl/funnel.stl` |

`stl/original_solid_block.stl` is the prior failed one-piece model (reference only).

## Assemble

1. Place the catch tray on the bench; drop the frame into it.
2. Seat pans in labeled wells: **A1/B1** under the discharges, **A2/B2** at the back as spares.
3. Set the riffle onto the frame rails (A-frame hoods point into A1 and B1).
4. Seat the funnel sleeve into the riffle socket.
5. Pour dried sediment into the funnel; collect halves in A1 and B1. Swap spare pans to re-split.

## Print settings

- PLA or PETG · 0.20 mm layers · ≥3 perimeters · 20–30% infill
- Orient each part on its flat base; no supports required
- Clearance between mates: 0.6 mm — sand lightly if your printer runs large

```bash
./scripts/build_stls.sh
```

OpenSCAD source: `scad/splitter.scad` (`PART` selector). Preview-only: `assembly`, `exploded`, `side_view`.

## Sizing

Footprint ~260×210 mm, overall height ~250 mm — close to the original attempt’s envelope, but hollow and separable. Chute width defaults to 7 mm (tweak `chute_w` / `n_chutes` for your grain size). Split accuracy is unverified until tested with your sediment.
