// =============================================================================
// Micropaleontology dry-sediment splitter — TRUE 4-WAY (cascaded Jones)
// =============================================================================
// Funnel → stage-1 2-way → two stage-2 2-way banks → 4 ACTIVE cups.
//
// PART options:
//   cup            ×4
//   catch_tray     ×1
//   frame          ×1
//   riffle_stage1  ×1   (top bank, L/R)
//   riffle_stage2  ×2   (identical; sit under L and R outlets)
//   funnel         ×1
//   assembly / exploded  (preview only)
//
// Units: mm.

/* [Part] */
PART = "assembly"; // ["cup","catch_tray","frame","riffle_stage1","riffle_stage2","funnel","assembly","exploded"]

wall = 2.6;
clear = 0.6;
$fn = 48;

tray_w = 280;
tray_d = 240;
tray_h = 30;
tray_t = 2.8;
tray_floor = 3.0;

cup_w = 90;
cup_d = 70;
cup_h = 48;
cup_t = 2.0;
cup_floor = 2.2;
cup_back = 16;

n1 = 12;
n2 = 8;
chute_w = 6.5;
vane_t = 1.8;
bank_d = 50;
bank_h = 48;
bank2_d = 42;
bank2_h = 40;
end_w = 3.5;
hood = 32;

funnel_w = 220;
funnel_d = 160;
funnel_rim = 10;
funnel_t = 2.4;
funnel_collar = 28;
funnel_cone = 65;

leg = 10;

inner1 = n1 * chute_w + (n1 - 1) * vane_t;
outer1 = inner1 + 2 * end_w;
outer1_d = bank_d + 2 * wall;
throat_w = inner1 - 2;
throat_d = bank_d - 6;

inner2 = n2 * chute_w + (n2 - 1) * vane_t;
outer2 = inner2 + 2 * end_w;
outer2_d = bank2_d + 2 * wall;

function nests() = [
    [-(cup_w/2 + 12), -(cup_d/2 + 18)], // A1
    [ (cup_w/2 + 12), -(cup_d/2 + 18)], // B1
    [-(cup_w/2 + 12),  (cup_d/2 + 18)], // A2
    [ (cup_w/2 + 12),  (cup_d/2 + 18)]  // B2
];

stage2_z = tray_floor + cup_h + 10;
stage1_z = stage2_z + bank2_h + 14;

module cup() {
    back = cup_d + cup_back;
    difference() {
        translate([-cup_w/2, -cup_d/2, 0]) cube([cup_w, back, cup_h]);
        translate([-(cup_w-2*cup_t)/2, -(cup_d-2*cup_t)/2, cup_floor])
            cube([cup_w-2*cup_t, back-2*cup_t, cup_h]);
    }
}

module catch_tray() {
    ns = nests();
    difference() {
        translate([-tray_w/2, -tray_d/2, 0]) cube([tray_w, tray_d, tray_h]);
        translate([-(tray_w-2*tray_t)/2, -(tray_d-2*tray_t)/2, tray_floor])
            cube([tray_w-2*tray_t, tray_d-2*tray_t, tray_h]);
        for (p = ns) {
            translate([p[0]-(cup_w+1.2)/2, p[1]-(cup_d+1.2)/2, tray_floor-1])
                cube([cup_w+1.2, cup_d+cup_back+1.2, 1.2]);
        }
        labels = ["A1","B1","A2","B2"];
        for (i = [0:3])
            translate([ns[i][0], ns[i][1], tray_floor-1.3])
                linear_extrude(1)
                    text(labels[i], size=8, halign="center", valign="center",
                         font="Liberation Sans:style=Bold");
    }
    translate([-1.5, -(tray_d-2*tray_t)/2, tray_floor])
        cube([3, tray_d-2*tray_t, 14]);
    translate([-(tray_w-2*tray_t)/2, -1.5, tray_floor])
        cube([tray_w-2*tray_t, 3, 14]);
}

module frame() {
    // Connected stand: skirt + legs + stage2 cradles + stage1 cradle
    z1 = stage1_z + 6;
    union() {
        // rim skirt tied to legs
        difference() {
            translate([-tray_w/2+8, -tray_d/2+8, 0])
                cube([tray_w-16, tray_d-16, 8]);
            translate([-tray_w/2+20, -tray_d/2+20, -1])
                cube([tray_w-40, tray_d-40, 12]);
        }
        // legs
        for (sx=[-1,1], sy=[-1,1]) {
            translate([
                sx*(tray_w/2-18)-(sx>0?0:leg),
                sy*(tray_d/2-18)-(sy>0?0:leg),
                0
            ]) cube([leg, leg, z1]);
        }
        // stage-2 cradles (left and right), connected to legs via bars
        for (sx=[-1,1]) {
            translate([
                sx*(outer1/2 + 8) - (sx>0 ? 0 : outer2_d + 12),
                -outer2/2 - 8,
                stage2_z
            ])
                cube([outer2_d + 12, outer2 + 16, 8]);
        }
        // front/rear bars tying stage-2 cradles
        translate([-(outer1 + outer2_d), -4, stage2_z])
            cube([2*(outer1 + outer2_d), 8, 8]);
        // stage-1 cradle
        translate([-(outer1+28)/2, -outer1_d/2-8, stage1_z])
            cube([outer1+28, outer1_d+16, 8]);
        // vertical posts from stage2 plane up to stage1 cradle
        for (sx=[-1,1]) {
            translate([sx*(outer1/2+6)-(sx>0?0:8), -4, stage2_z])
                cube([8, 8, stage1_z - stage2_z + 8]);
        }
    }
}

module chute_cut(i, n, iw, ow, bd, bh, reach) {
    x = -iw/2 + chute_w/2 + i*(chute_w + vane_t);
    dir = (i % 2 == 0) ? -1 : 1;
    hull() {
        translate([x-chute_w/2, -bd/2, bh-1]) cube([chute_w, bd, 2]);
        translate([x-chute_w/2 + dir*(ow/2 + reach*0.5), -bd/2+3, -10])
            cube([chute_w+2, bd-6, 2]);
    }
}

module riffle_bank(n, bd, bh, reach, with_socket=false) {
    iw = n*chute_w + (n-1)*vane_t;
    ow = iw + 2*end_w;
    od = bd + 2*wall;
    difference() {
        union() {
            translate([-ow/2, -od/2, 0]) cube([ow, od, bh]);
            for (sx=[-1,1])
                hull() {
                    translate([sx*(ow/2)-(sx>0?0:3), -od/2, bh*0.4]) cube([3, od, 3]);
                    translate([sx*(ow/2+reach)-(sx>0?0:18), -od/2+3, -8])
                        cube([18, od-6, 3]);
                }
            translate([-(ow+24)/2, -od/2, 8]) cube([ow+24, od, 5]);
            if (with_socket)
                translate([-(throat_w+10)/2, -(throat_d+10)/2, bh])
                    cube([throat_w+10, throat_d+10, 7]);
        }
        translate([-iw/2, -bd/2, bh-7]) cube([iw, bd, 16]);
        for (i=[0:n-1]) chute_cut(i, n, iw, ow, bd, bh, reach);
        translate([-ow/2-reach-2, -bd/2+3, -12])
            cube([ow/2+reach-1, bd-6, 18]);
        translate([1, -bd/2+3, -12])
            cube([ow/2+reach-1, bd-6, 18]);
        if (with_socket)
            translate([-(throat_w+clear)/2, -(throat_d+clear)/2, bh-1])
                cube([throat_w+clear, throat_d+clear, 12]);
    }
}

module riffle_stage1() {
    riffle_bank(n1, bank_d, bank_h, hood, with_socket=true);
}

module riffle_stage2() {
    // Printed twice. Rotate 90° in assembly so L/R become front/rear pair.
    riffle_bank(n2, bank2_d, bank2_h, 26, with_socket=false);
}

module funnel() {
    difference() {
        union() {
            translate([-(funnel_w+2*funnel_rim)/2, -(funnel_d+2*funnel_rim)/2, funnel_cone])
                cube([funnel_w+2*funnel_rim, funnel_d+2*funnel_rim, funnel_collar]);
            hull() {
                translate([-(funnel_w+2*funnel_rim-6)/2, -(funnel_d+2*funnel_rim-6)/2, funnel_cone])
                    cube([funnel_w+2*funnel_rim-6, funnel_d+2*funnel_rim-6, 1]);
                translate([-(throat_w+2*funnel_t)/2, -(throat_d+2*funnel_t)/2, 0])
                    cube([throat_w+2*funnel_t, throat_d+2*funnel_t, 1]);
            }
            translate([-throat_w/2, -throat_d/2, -16]) cube([throat_w, throat_d, 17]);
        }
        translate([-(funnel_w-2*funnel_t)/2, -(funnel_d-2*funnel_t)/2, funnel_cone-0.1])
            cube([funnel_w-2*funnel_t, funnel_d-2*funnel_t, funnel_collar+2]);
        hull() {
            translate([-(funnel_w-2*funnel_t-6)/2, -(funnel_d-2*funnel_t-6)/2, funnel_cone])
                cube([funnel_w-2*funnel_t-6, funnel_d-2*funnel_t-6, 1.2]);
            translate([-(throat_w-2*funnel_t)/2, -(throat_d-2*funnel_t)/2, 0])
                cube([throat_w-2*funnel_t, throat_d-2*funnel_t, 1.2]);
        }
        translate([-(throat_w-2*funnel_t)/2, -(throat_d-2*funnel_t)/2, -17])
            cube([throat_w-2*funnel_t, throat_d-2*funnel_t, 20]);
    }
}

module assembly() {
    ns = nests();
    color([0.42,0.45,0.50]) catch_tray();
    color([0.50,0.52,0.55]) translate([0,0,tray_floor]) frame();
    cols = [[0.95,0.75,0.15],[0.25,0.60,0.90],[0.95,0.50,0.20],[0.35,0.75,0.45]];
    for (i=[0:3])
        color(cols[i]) translate([ns[i][0], ns[i][1], tray_floor+0.5]) cup();
    // stage-2 under L and R, rotated so outlets feed front/rear cups
    color([0.65,0.65,0.68])
        translate([-(outer1/2 + hood*0.35), 0, stage2_z+8])
            rotate([0,0,90]) riffle_stage2();
    color([0.65,0.65,0.68])
        translate([ (outer1/2 + hood*0.35), 0, stage2_z+8])
            rotate([0,0,90]) riffle_stage2();
    color([0.55,0.55,0.60])
        translate([0, 0, stage1_z+8]) riffle_stage1();
    color([0.38,0.52,0.78])
        translate([0, 0, stage1_z+8+bank_h+7]) funnel();
}

module exploded() {
    ns = nests();
    color([0.42,0.45,0.50]) catch_tray();
    color([0.50,0.52,0.55]) translate([0,0,40]) frame();
    cols = [[0.95,0.75,0.15],[0.25,0.60,0.90],[0.95,0.50,0.20],[0.35,0.75,0.45]];
    for (i=[0:3]) color(cols[i]) translate([ns[i][0], ns[i][1], 70]) cup();
    color([0.65,0.65,0.68]) translate([-90,0,150]) rotate([0,0,90]) riffle_stage2();
    color([0.65,0.65,0.68]) translate([ 90,0,150]) rotate([0,0,90]) riffle_stage2();
    color([0.55,0.55,0.60]) translate([0,0,230]) riffle_stage1();
    color([0.38,0.52,0.78]) translate([0,0,330]) funnel();
}

if (PART=="cup") cup();
else if (PART=="catch_tray") catch_tray();
else if (PART=="frame") frame();
else if (PART=="riffle_stage1") riffle_stage1();
else if (PART=="riffle_stage2") riffle_stage2();
else if (PART=="funnel") funnel();
else if (PART=="exploded") exploded();
else assembly();
