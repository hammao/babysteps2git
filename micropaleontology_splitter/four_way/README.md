# 4-way micropaleontology splitter (cascaded Jones)

True **1/4 split** into four active cups:

```
              FUNNEL
                │
         riffle_stage1 (L / R)
           ╱              ╲
   riffle_stage2      riffle_stage2
      ╱    ╲             ╱    ╲
    A1     A2          B1     B2
```

## Print

| Part | Qty | File |
|------|-----|------|
| Cup | **4** | `stl/cup.stl` |
| Catch tray | 1 | `stl/catch_tray.stl` |
| Frame | 1 | `stl/frame.stl` |
| Stage-1 riffle | 1 | `stl/riffle_stage1.stl` |
| Stage-2 riffle | **2** | `stl/riffle_stage2.stl` |
| Funnel | 1 | `stl/funnel.stl` |

```bash
./scripts/build_stls.sh
```

Source: `scad/splitter_4way.scad`
