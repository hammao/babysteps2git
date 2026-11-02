// Micropaleontology dry-sediment 2-way riffle splitter
// Multi-part design — print as separate pieces (not one fused block).
//
// PART options:
//   cup         — collection cup (print qty 4)
//   catch_tray  — secondary spill tub with 4 cup nests (2 active + 2 spare)
//   riffle      — Jones-style alternating chute bank (2-way split)
//   funnel      — large anti-spill funnel
//   assembly    — colored preview only (do NOT slice/print)
//
// Units: mm. Tuned for FDM PLA/PETG @ 0.2 mm layers, 2–3 perimeters.

/* [Part] */
PART = "assembly"; // ["cup","catch_tray","riffle","funnel","assembly","tray_with_cups","exploded"]

/* [Tolerances] */
wall = 2.4;
clear = 0.5;
$fn = 48;

/* [Cup — print 4] */
cup_w = 68;
cup_d = 52;
cup_h = 42;
cup_t = 2.0;
cup_floor = 2.4;

/* [Catch tray] */
tray_t = 2.6;
tray_floor = 3.0;
tray_rim = 16;
nest_gap = 8;
margin = 10;

/* [Riffle — 2-way] */
n_chutes = 12;          // even → equal L/R count
chute_w = 5.0;
baffle = 1.8;
bank_d = 26;
bank_h = 48;
exit_h = 20;
ledge = 10;
angle = 38;             // chute lean from vertical (deg)

/* [Funnel] */
funnel_top_w = 150;
funnel_top_d = 100;
funnel_collar_h = 28;
funnel_cone_h = 50;
funnel_t = 2.2;

// ---- derived ----
inner_bank_w = n_chutes * chute_w + (n_chutes - 1) * baffle;
outer_bank_w = inner_bank_w + 2 * wall;
outer_bank_d = bank_d + 2 * wall;
throat_w = inner_bank_w + 2;
throat_d = bank_d - 2;

tray_inner_w = 2 * cup_w + 3 * nest_gap + 2 * margin;
tray_inner_d = 2 * cup_d + 3 * nest_gap + 2 * margin;
tray_outer_w = tray_inner_w + 2 * tray_t;
tray_outer_d = tray_inner_d + 2 * tray_t;
tray_h = tray_floor + tray_rim;
// riffle side wings must span out to the tray-wall rails
riffle_span_w = tray_inner_w - 2; // sits on rails inset by ~1 mm

function nests() = [
    [-(cup_w + nest_gap)/2, -(cup_d + nest_gap)/2], // A1 active
    [ (cup_w + nest_gap)/2, -(cup_d + nest_gap)/2], // B1 active
    [-(cup_w + nest_gap)/2,  (cup_d + nest_gap)/2], // A2 spare
    [ (cup_w + nest_gap)/2,  (cup_d + nest_gap)/2]  // B2 spare
];

// ============================================================================
// CUP (single hollow shell)
// ============================================================================
module cup() {
    difference() {
        // outer body + integrated rim lip (one solid)
        union() {
            translate([-cup_w/2, -cup_d/2, 0])
                cube([cup_w, cup_d, cup_h]);
            // rim lip flush with top
            translate([-(cup_w+6)/2, -(cup_d+6)/2, cup_h - 2.5])
                cube([cup_w + 6, cup_d + 6, 2.5]);
        }
        // cavity — open top
        translate([-(cup_w - 2*cup_t)/2, -(cup_d - 2*cup_t)/2, cup_floor])
            cube([cup_w - 2*cup_t, cup_d - 2*cup_t, cup_h]);
    }
}

// ============================================================================
// CATCH TRAY — secondary spill container + 4 nests
// ============================================================================
module catch_tray() {
    ns = nests();
    difference() {
        // outer tub
        translate([-tray_outer_w/2, -tray_outer_d/2, 0])
            cube([tray_outer_w, tray_outer_d, tray_h]);

        // main cavity
        translate([-tray_inner_w/2, -tray_inner_d/2, tray_floor])
            cube([tray_inner_w, tray_inner_d, tray_rim + 1]);

        // shallow floor recesses to locate each cup
        for (p = ns) {
            translate([
                p[0] - (cup_w + 2*clear)/2,
                p[1] - (cup_d + 2*clear)/2,
                tray_floor - 1.0
            ])
                cube([cup_w + 2*clear, cup_d + 2*clear, 1.2]);
        }

        // engraved nest markers (subtractive, stay manifold)
        markers = ["A1","B1","A2","B2"];
        for (i = [0:3]) {
            translate([ns[i][0], ns[i][1], tray_floor - 1.5])
                linear_extrude(1.0)
                    text(markers[i], size=7, halign="center", valign="center",
                         font="Liberation Sans:style=Bold");
        }
    }

    // low bay walls between the four cup nests (cups remain separate removable parts)
    bay_h = 10;
    // cross divider (between active row and spare row)
    translate([-tray_inner_w/2 + 2, -nest_gap/2, tray_floor])
        cube([tray_inner_w - 4, nest_gap - 2*clear, bay_h]);
    // center divider (between left A and right B)
    translate([-nest_gap/2, -tray_inner_d/2 + 2, tray_floor])
        cube([nest_gap - 2*clear, tray_inner_d - 4, bay_h]);


    // rails supporting the riffle above the ACTIVE (front) cups
    // Posts sit OUTSIDE the cup footprints, against the tray side walls.
    rail_top = tray_floor + cup_h + 1.5 + 7;
    ay = ns[0][1];
    rail_len = cup_d + nest_gap;
    for (sx = [-1, 1]) {
        // flush to inner side wall, clear of cup outer edge (~±72 mm)
        x0 = sx > 0 ? (tray_inner_w/2 - ledge) : (-tray_inner_w/2);
        translate([x0, ay - rail_len/2, tray_floor])
            cube([ledge, rail_len, rail_top - tray_floor]);
    }
    // front stop bar spanning between side rails
    translate([
        -tray_inner_w/2,
        ay - cup_d/2 - nest_gap/2 - 4,
        tray_floor
    ])
        cube([tray_inner_w, 4, rail_top - tray_floor]);
}

// ============================================================================
// RIFFLE BODY — alternating chutes → left / right (2-way)
// ============================================================================
module chute_cut(i) {
    // Vertical inlet slot + angled hull to side exit (true open channel)
    x = -inner_bank_w/2 + chute_w/2 + i * (chute_w + baffle);
    left = (i % 2 == 0);
    dir = left ? -1 : 1;

    // full-height vertical slot through the bank
    translate([x - chute_w/2, -bank_d/2 + 1, exit_h])
        cube([chute_w, bank_d - 2, bank_h + 2]);

    // angled path from mid-bank to side outlet
    hull() {
        translate([x - chute_w/2, -bank_d/2 + 1, exit_h + bank_h * 0.55])
            cube([chute_w, bank_d - 2, 1]);
        translate([
            dir * (outer_bank_w/2 + 10) - chute_w/2,
            -bank_d/2 + 2,
            0.5
        ])
            cube([chute_w + 2, bank_d - 4, 1]);
    }
}

module riffle() {
    total_h = bank_h + exit_h;
    difference() {
        union() {
            // main block
            translate([-outer_bank_w/2, -outer_bank_d/2, 0])
                cube([outer_bank_w, outer_bank_d, total_h]);
            // side wings that rest on tray-wall rails (outside the cups)
            translate([-riffle_span_w/2, -outer_bank_d/2, exit_h + 2])
                cube([riffle_span_w, outer_bank_d, 6]);
            // funnel socket collar
            translate([-(throat_w + 6)/2, -(throat_d + 6)/2, total_h])
                cube([throat_w + 6, throat_d + 6, 7]);
        }

        // funnel throat pocket
        translate([-(throat_w + clear)/2, -(throat_d + clear)/2, total_h - 1])
            cube([throat_w + clear, throat_d + clear, 10]);

        // feed pocket above baffles
        translate([-inner_bank_w/2, -bank_d/2 + 1, exit_h + bank_h - 6])
            cube([inner_bank_w, bank_d - 2, 8]);

        // alternating chute cavities
        for (i = [0:n_chutes-1]) chute_cut(i);

        // open underside L/R exits; keep thin center divider wall
        translate([-outer_bank_w/2 - 12, -bank_d/2 + 2, -1])
            cube([outer_bank_w/2 + 12 - baffle/2, bank_d - 4, exit_h + 4]);
        translate([baffle/2, -bank_d/2 + 2, -1])
            cube([outer_bank_w/2 + 12 - baffle/2, bank_d - 4, exit_h + 4]);

        // open side faces so sediment exits into cups (not trapped)
        translate([-outer_bank_w/2 - 15, -bank_d/2 + 3, -1])
            cube([16, bank_d - 6, exit_h + 8]);
        translate([outer_bank_w/2 - 1, -bank_d/2 + 3, -1])
            cube([16, bank_d - 6, exit_h + 8]);
    }
}

// ============================================================================
// FUNNEL — large mouth, seats into riffle collar
// ============================================================================
module funnel() {
    difference() {
        union() {
            // upper collar
            translate([-funnel_top_w/2, -funnel_top_d/2, funnel_cone_h])
                cube([funnel_top_w, funnel_top_d, funnel_collar_h]);
            // outer spill lip
            translate([-(funnel_top_w+12)/2, -(funnel_top_d+12)/2,
                       funnel_cone_h + funnel_collar_h - 4])
                cube([funnel_top_w + 12, funnel_top_d + 12, 4]);
            // cone shell
            hull() {
                translate([-(funnel_top_w - 4)/2, -(funnel_top_d - 4)/2, funnel_cone_h])
                    cube([funnel_top_w - 4, funnel_top_d - 4, 0.5]);
                translate([-(throat_w + 2*funnel_t)/2, -(throat_d + 2*funnel_t)/2, 0])
                    cube([throat_w + 2*funnel_t, throat_d + 2*funnel_t, 0.5]);
            }
            // insertion sleeve
            translate([-throat_w/2, -throat_d/2, -12])
                cube([throat_w, throat_d, 13]);
        }

        // hollow collar
        translate([-(funnel_top_w - 2*funnel_t)/2, -(funnel_top_d - 2*funnel_t)/2,
                   funnel_cone_h - 0.1])
            cube([funnel_top_w - 2*funnel_t, funnel_top_d - 2*funnel_t,
                  funnel_collar_h + 1]);

        // hollow cone
        hull() {
            translate([-(funnel_top_w - 2*funnel_t - 4)/2,
                       -(funnel_top_d - 2*funnel_t - 4)/2,
                       funnel_cone_h])
                cube([funnel_top_w - 2*funnel_t - 4,
                      funnel_top_d - 2*funnel_t - 4, 0.6]);
            translate([-(throat_w - 2*funnel_t)/2, -(throat_d - 2*funnel_t)/2, 0])
                cube([throat_w - 2*funnel_t, throat_d - 2*funnel_t, 0.6]);
        }

        // open sleeve bore
        translate([-(throat_w - 2*funnel_t)/2, -(throat_d - 2*funnel_t)/2, -13])
            cube([throat_w - 2*funnel_t, throat_d - 2*funnel_t, 16]);

        // open lip center
        translate([-(funnel_top_w - 2)/2, -(funnel_top_d - 2)/2,
                   funnel_cone_h + funnel_collar_h - 4.1])
            cube([funnel_top_w - 2, funnel_top_d - 2, 5]);
    }
}

// ============================================================================
// ASSEMBLY PREVIEWS (do not print)
// ============================================================================
module assembly() {
    ns = nests();
    color([0.35, 0.45, 0.55]) catch_tray();
    for (i = [0:3]) {
        color(i < 2 ? [0.92, 0.78, 0.25] : [0.85, 0.55, 0.25])
            translate([ns[i][0], ns[i][1], tray_floor + 0.4])
                cup();
    }
    color([0.55, 0.55, 0.6])
        translate([0, ns[0][1], tray_floor + cup_h + 8.5])
            riffle();
    color([0.4, 0.55, 0.75])
        translate([0, ns[0][1], tray_floor + cup_h + 8.5 + bank_h + exit_h + 7])
            funnel();
}

module tray_with_cups() {
    // Clear view of 4 separate removable cups in the spill tray
    ns = nests();
    color([0.35, 0.45, 0.55]) catch_tray();
    cup_colors = [
        [0.95, 0.80, 0.20],
        [0.30, 0.70, 0.85],
        [0.95, 0.55, 0.20],
        [0.45, 0.75, 0.40]
    ];
    for (i = [0:3]) {
        color(cup_colors[i])
            translate([ns[i][0], ns[i][1], tray_floor + 0.4])
                cup();
    }
}

module exploded() {
    ns = nests();
    color([0.35, 0.45, 0.55]) catch_tray();
    cup_colors = [
        [0.95, 0.80, 0.20],
        [0.30, 0.70, 0.85],
        [0.95, 0.55, 0.20],
        [0.45, 0.75, 0.40]
    ];
    for (i = [0:3]) {
        color(cup_colors[i])
            translate([ns[i][0], ns[i][1], tray_floor + 18])
                cup();
    }
    color([0.55, 0.55, 0.6])
        translate([0, ns[0][1], tray_floor + cup_h + 55])
            riffle();
    color([0.4, 0.55, 0.75])
        translate([0, ns[0][1], tray_floor + cup_h + 140])
            funnel();
}

if (PART == "cup") cup();
else if (PART == "catch_tray") catch_tray();
else if (PART == "riffle") riffle();
else if (PART == "funnel") funnel();
else if (PART == "tray_with_cups") tray_with_cups();
else if (PART == "exploded") exploded();
else assembly();
