// Wall-mount enclosure for the LCDWIKI ES3C28P 2.8" ESP32-S3 display module.
//
//   - board screwed in on M3, shell closes with a snap-fit groove
//   - landscape orientation, USB-C exiting straight out of the right side
//   - two keyhole slots in the back plate for wall screws
//
// All dimensions come from the vendor drawing ES3C28P_Size.pdf, except the
// USB-C position, which that drawing only shows graphically. That opening is
// therefore deliberately generous — see usb_* below.
//
// PRINT THE TEST FRAME FIRST. part = "test" is a 3 mm sliver that checks the
// board outline, the four hole positions and the window alignment for a few
// grams of filament. Everything here was derived from a text extraction of a
// PDF, not measured on a board, so spend the ten minutes.

/* [What to render] */
// front = bezel + walls, back = lid, test = fit check
part = "front";  // [front, back, test]

/* [Board — from the vendor drawing, do not change] */
pcb_w      = 86.00;  // long axis, horizontal in landscape
pcb_h      = 50.00;  // short axis
pcb_t      = 1.60;
pcb_r      = 3.50;   // corner radius
hole_dx    = 78.00;  // mounting hole pattern, long axis
hole_dy    = 42.00;  // mounting hole pattern, short axis
hole_d     = 3.20;   // holes are 3.2, so M3 passes through
glass_above = 4.30;  // 0.5 glue + 2.3 LCD + 0.5 glue + 1.0 touch panel
comp_below  = 4.70;  // tallest component on the back

/* [Display window] */
// Visible area is 58.05 x 43.60 (VA). A little over that, so the bezel does
// not creep into the picture if the board sits a hair off centre.
win_w      = 58.60;
win_h      = 44.20;
win_off_x  = 0;      // nudge if the window looks off centre on the test frame
win_off_y  = 0;

/* [USB-C opening — verify on the test frame] */
usb_w      = 13.00;  // generous: a plug moulding is wider than the connector
usb_h      = 8.00;
usb_off_y  = 0;      // along the short axis, 0 = centred on the edge

/* [Fit and tolerances — tune for your printer] */
fit        = 0.30;   // clearance around the board
wall       = 2.50;
front_t    = 2.00;   // bezel thickness
back_t     = 2.00;   // lid thickness
back_gap   = 1.20;   // air behind the tallest component
boss_od     = 5.50;
boss_pilot  = 2.50;  // M3 self-tapping; use 3.20 if you want nuts or inserts
snap_depth  = 0.80;
snap_h      = 1.50;
snap_inset  = 2.50;  // distance of the groove from the rear edge

/* [Wall mounting] */
keyhole_spacing = 60.00;
keyhole_big     = 8.00;   // screw head passes here
keyhole_small   = 4.20;   // shank slides into this
keyhole_drop    = 6.00;

/* [Hidden] */
$fn = 64;
eps = 0.01;

inner_w = pcb_w + 2 * fit;
inner_h = pcb_h + 2 * fit;
inner_d = glass_above + pcb_t + comp_below + back_gap;
outer_w = inner_w + 2 * wall;
outer_h = inner_h + 2 * wall;
outer_d = front_t + inner_d + back_t;
outer_r = pcb_r + wall + fit;

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

module rrect(w, h, r, th) {
    linear_extrude(th)
        offset(r = r) offset(r = -r)
            square([w, h], center = true);
}

// The four mounting holes, in board coordinates centred on the board.
module at_holes() {
    for (x = [-hole_dx / 2, hole_dx / 2])
        for (y = [-hole_dy / 2, hole_dy / 2])
            translate([x, y, 0]) children();
}

// ---------------------------------------------------------------------------
// Front: bezel, side walls, board posts
// ---------------------------------------------------------------------------

module front() {
    difference() {
        union() {
            // outer body
            rrect(outer_w, outer_h, outer_r, outer_d);
        }

        // cavity for the board and its components
        translate([0, 0, front_t])
            rrect(inner_w, inner_h, pcb_r + fit, inner_d + back_t + eps);

        // display window
        translate([win_off_x, win_off_y, -eps])
            rrect(win_w, win_h, 2, front_t + 2 * eps);

        // USB-C, straight out of the +X side
        translate([outer_w / 2 - wall / 2, usb_off_y,
                   front_t + glass_above + pcb_t / 2])
            cube([wall * 2, usb_w, usb_h], center = true);

        // snap groove, running right round the inside near the rear edge
        translate([0, 0, outer_d - back_t - snap_inset - snap_h / 2])
            difference() {
                rrect(inner_w + 2 * snap_depth, inner_h + 2 * snap_depth,
                      pcb_r + fit + snap_depth, snap_h);
                translate([0, 0, -eps])
                    rrect(inner_w - 1, inner_h - 1, pcb_r, snap_h + 2 * eps);
            }
    }

    // posts the board screws onto. Their height puts the glass against the
    // inside of the bezel, which is what keeps the front flush.
    translate([0, 0, front_t])
        at_holes()
            difference() {
                cylinder(d = boss_od, h = glass_above);
                translate([0, 0, -eps])
                    cylinder(d = boss_pilot, h = glass_above + 6);
            }
}

// ---------------------------------------------------------------------------
// Back: lid with snap rib and keyholes
// ---------------------------------------------------------------------------

module back() {
    lip_h = snap_inset + snap_h + 1.0;

    difference() {
        union() {
            rrect(outer_w, outer_h, outer_r, back_t);

            // lip that drops into the shell
            translate([0, 0, back_t - eps])
                difference() {
                    rrect(inner_w - 0.20, inner_h - 0.20, pcb_r + fit, lip_h);
                    translate([0, 0, -eps])
                        rrect(inner_w - 3.2, inner_h - 3.2, pcb_r, lip_h + 2 * eps);
                }

            // rib that catches in the groove
            translate([0, 0, back_t + lip_h - snap_inset - snap_h])
                difference() {
                    rrect(inner_w - 0.20 + 2 * snap_depth,
                          inner_h - 0.20 + 2 * snap_depth,
                          pcb_r + fit + snap_depth, snap_h);
                    translate([0, 0, -eps])
                        rrect(inner_w - 3.2, inner_h - 3.2, pcb_r,
                              snap_h + 2 * eps);
                }
        }

        // keyhole slots for wall screws
        for (x = [-keyhole_spacing / 2, keyhole_spacing / 2])
            translate([x, 0, -eps]) {
                cylinder(d = keyhole_big, h = back_t + 2 * eps);
                translate([0, -keyhole_drop, 0])
                    cylinder(d = keyhole_small, h = back_t + 2 * eps);
                translate([0, -keyhole_drop / 2, back_t / 2 + eps])
                    cube([keyhole_small, keyhole_drop, back_t + 2 * eps],
                         center = true);
            }
    }
}

// ---------------------------------------------------------------------------
// Test frame: outline, holes and window only. Print this first.
// ---------------------------------------------------------------------------

module test_frame() {
    t = 3.0;
    difference() {
        rrect(outer_w, outer_h, outer_r, t);

        // board outline, so you can drop the board in and check the fit
        translate([0, 0, 1.2])
            rrect(inner_w, inner_h, pcb_r + fit, t);

        // window, to check it lines up with the picture
        translate([win_off_x, win_off_y, -eps])
            rrect(win_w, win_h, 2, 1.2 + 2 * eps);

        // hole positions, drilled right through
        translate([0, 0, -eps])
            at_holes() cylinder(d = hole_d, h = t + 2 * eps);

        // USB-C notch
        translate([outer_w / 2 - wall / 2, usb_off_y, t / 2])
            cube([wall * 2, usb_w, t + 2 * eps], center = true);
    }
}

// ---------------------------------------------------------------------------

if (part == "front") front();
else if (part == "back") back();
else if (part == "test") test_frame();
