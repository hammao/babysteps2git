# 2-way micropaleontology splitter (Jones riffle + 4 pans)

**2-way split only** (left / right). Four cups = **A1/B1 active** under the outlets + **A2/B2 spare** pans in a rear storage bay for sequential half-splits.

```
        FUNNEL
          │
     riffle /\/\/\
       ╱        ╲
     A1         B1     ← ACTIVE
   ────────── divider ──────────
     A2         B2     ← SPARE STORAGE (not under chutes)
```

## Print

| Part | Qty | File |
|------|-----|------|
| Cup | **4** | `stl/cup.stl` |
| Catch tray | 1 | `stl/catch_tray.stl` |
| Frame | 1 | `stl/frame.stl` |
| Riffle | 1 | `stl/riffle.stl` |
| Funnel | 1 | `stl/funnel.stl` |

```bash
./scripts/build_stls.sh
```

Source: `scad/splitter_2way.scad`
