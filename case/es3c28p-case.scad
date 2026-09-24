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
// Measured on hardware 2026-09-24: the display sits 3 mm off centre on the
// board, towards the microphone end. The vendor drawing does not mention this.
// Centring the window left 3 mm of bare glass showing at the USB end while the
// bezel covered 3 mm of picture at the other. Both observations independently
// give -3.00, and at that offset the margin is 0.275 mm on each side.
win_off_x  = -3.00;
win_off_y  = 0;

/* [Glass recess] */
// Without this the glass sits the full bezel thickness back and you look at
// the picture down a tunnel. This pockets the inside of the bezel to the
// outline of the touch panel, so the glass moves forward and only a thin lip
// is left in front of it. The lip ends up front_t - glass_pocket thick.
//
// Set glass_pocket = front_t for a fully flush front: the glass then becomes
// the outer surface. That looks best but leaves a visible seam around the
// glass and only 2.5 mm of bezel above and below it, so it is fragile.
glass_w      = 69.20;  // touch panel, long axis
glass_h      = 50.00;  // touch panel, short axis — the full board width
glass_pocket = 1.00;   // how far forward the glass comes; leaves a 0.6 mm lip

/* [USB-C opening — verify on the test frame] */
usb_w      = 13.00;  // generous: a plug moulding is wider than the connector
usb_h      = 8.00;
usb_off_y  = 0;      // along the short axis, 0 = centred on the edge
usb_off_z  = 1.50;   // towards the back: the connector sits on the rear face

/* [How the board is held] */
// clamp  : pegs on the back plate carry the board, the bezel presses on the
//          glass, and the snap fit holds the sandwich together. No fasteners
//          at all. The snap becomes load bearing, so print it first and check
//          it grips before committing.
// screws : posts in the front, four M3 x 6. Use this if the clamp ends up
//          loose, or if you want the front removable without disturbing the
//          board.
retention = "clamp";  // [clamp, screws]

peg_od        = 5.50;
peg_spigot_d  = 3.00;  // enters the board's 3.2 mm hole to locate it
peg_spigot_h  = 1.40;  // shorter than the 1.6 mm board, so it cannot foul
peg_clearance = 0.20;  // pegs deliberately short; the bezel sets the depth

/* [Fit and tolerances — tune for your printer] */
fit        = 0.30;   // clearance around the board
wall       = 2.50;
front_t    = 1.60;   // bezel thickness
back_t     = 2.00;   // lid thickness
back_gap   = 1.20;   // air behind the tallest component
boss_od     = 5.50;
boss_pilot  = 2.50;  // M3 self-tapping into plastic
bezel_keep  = 0.60;  // material left in front of the pilot hole, so it stays
                     // blind and no hole shows on the visible face
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

// The glass pocket pulls the whole board forward by glass_pocket, so the depth
// behind it shrinks by the same amount and the posts get shorter to match.
// Getting this wrong means the board will not seat against the bezel.
inner_d = glass_above + pcb_t + comp_below - glass_pocket + back_gap;
outer_w = inner_w + 2 * wall;
outer_h = inner_h + 2 * wall;
outer_d = front_t + inner_d + back_t;
outer_r = pcb_r + wall + fit;

post_h      = glass_above - glass_pocket;            // posts the PCB rests on
pcb_front_z = front_t - glass_pocket + glass_above;  // front face of the PCB
screw_depth = post_h + front_t - bezel_keep;         // usable thread depth

// Distance from the inside of the back plate to the back of the board. The
// pegs are this tall, less a whisker, so the bezel and not the pegs decides
// how deep the board sits.
peg_h = (front_t + inner_d) - (pcb_front_z + pcb_t) - peg_clearance;

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
      difference() {
        // outer body
        rrect(outer_w, outer_h, outer_r, outer_d);

        // cavity for the board and its components
        translate([0, 0, front_t])
            rrect(inner_w, inner_h, pcb_r + fit, inner_d + back_t + eps);

        // display window
        translate([win_off_x, win_off_y, -eps])
            rrect(win_w, win_h, 2, front_t + 2 * eps);

        // pocket on the inside of the bezel, to the outline of the touch
        // panel, so the glass comes forward instead of sitting at the back of
        // a 2 mm tunnel
        translate([win_off_x, win_off_y, front_t - glass_pocket])
            rrect(glass_w + 2 * fit, glass_h + 2 * fit, 1,
                  glass_pocket + eps);

        // USB-C, straight out of the +X side
        translate([outer_w / 2 - wall / 2, usb_off_y,
                   pcb_front_z + pcb_t / 2 + usb_off_z])
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

      // Posts the board screws onto. Their height puts the glass against the
      // inside of the bezel, which is what keeps the front flush.
      // Absent in clamp mode, where the back plate carries the board instead.
      // Started at the pocket floor rather than at the bezel face. Now that
      // the pocket is offset, a post can straddle its edge, and this keeps the
      // base on solid material either way. The top ends up unchanged.
      if (retention == "screws")
          translate([0, 0, front_t - glass_pocket])
              at_holes() cylinder(d = boss_od, h = post_h + glass_pocket);
    }

    // The pilot hole runs on into the bezel and stops bezel_keep short of the
    // outside, so a 3.3 mm post still gives 4.3 mm of thread engagement
    // without a hole appearing on the visible face. Drilled from the whole
    // body, not just the post, which is why the posts are unioned in first.
    if (retention == "screws")
        translate([0, 0, front_t + post_h - screw_depth])
            at_holes() cylinder(d = boss_pilot, h = screw_depth + eps);
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

            // Pegs that carry the board in clamp mode. The shoulder sets how
            // far back the board sits and the spigot drops into its mounting
            // hole, so the board cannot shift sideways. Note the pegs land
            // where the screw posts would be, so only ever one or the other.
            if (retention == "clamp")
                translate([0, 0, back_t])
                    at_holes() {
                        cylinder(d = peg_od, h = peg_h);
                        translate([0, 0, peg_h - eps])
                            cylinder(d = peg_spigot_d, h = peg_spigot_h);
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
    // Deep enough to actually hold the board, so the glass drops into the
    // pocket and you can see how flush the front sits.
    t = front_t + 3.5;
    difference() {
        rrect(outer_w, outer_h, outer_r, t);

        // board outline, so you can drop the board in and check the fit
        translate([0, 0, front_t])
            rrect(inner_w, inner_h, pcb_r + fit, t);

        // window, to check it lines up with the picture
        translate([win_off_x, win_off_y, -eps])
            rrect(win_w, win_h, 2, front_t + 2 * eps);

        // the glass pocket, which is the whole point of reprinting this
        translate([win_off_x, win_off_y, front_t - glass_pocket])
            rrect(glass_w + 2 * fit, glass_h + 2 * fit, 1, glass_pocket + eps);

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
