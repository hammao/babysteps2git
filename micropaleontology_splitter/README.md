# Micropaleontology sediment splitters

Two complete printable kits:

| Kit | What it does | Folder |
|-----|----------------|--------|
| **2-way** | 1:1 left/right split. 4 cups = 2 active + 2 spare pans | `two_way/` |
| **4-way** | Cascaded Jones → four equal active cups (1/4 each) | `four_way/` |

## Quick download

Use the combined zip at the repo root of this folder:

`micropaleontology_splitters_2way_and_4way.zip`

## Local edit

```bash
git clone -b cursor/micropaleontology-splitter-4cups-8826 https://github.com/hammao/babysteps2git.git
cd babysteps2git/micropaleontology_splitter
```

- Edit 2-way: `two_way/scad/splitter_2way.scad` then `two_way/scripts/build_stls.sh`
- Edit 4-way: `four_way/scad/splitter_4way.scad` then `four_way/scripts/build_stls.sh`

OpenSCAD required to rebuild STLs.
