// Wall-mount enclosure for the LCDWIKI ES3C28P 2.8" ESP32-S3 display module.
//
//   - glass flush with the front, so in black it reads as one surface
//   - board trapped between four stops in the front and four pegs in the lid
//   - lid closes on four sprung tabs, no fasteners at all
//   - two keyhole slots for wall screws, USB-C straight out of the side
//
// Dimensions come from the vendor drawing ES3C28P_Size.pdf. Where that drawing
// was silent the value was measured on a board and is marked as such.
//
// PRINT THE TWO CLIPTEST PIECES BEFORE THE WHOLE CASE. They are a slice of wall and
// the matching slice of the lid, and it answers in fifteen minutes the one
// question arithmetic cannot: does the snap actually grip.

/* [What to render] */
part = "front";  // [front, back, test, cliptest-front, cliptest-back]

/* [Board — from the vendor drawing, do not change] */
pcb_w       = 86.00;  // long axis, horizontal in landscape
pcb_h       = 50.00;  // short axis
pcb_t       = 1.60;
pcb_r       = 3.50;
hole_dx     = 78.00;  // mounting hole pattern, long axis
hole_dy     = 42.00;  // mounting hole pattern, short axis
hole_d      = 3.20;
glass_above = 4.30;   // 0.5 glue + 2.3 LCD + 0.5 glue + 1.0 touch panel
comp_below  = 4.70;   // tallest component on the back

/* [Front face] */
// flush : the opening goes right through and the glass fills it. The board is
//         then stopped by four pads inside the bezel, not by its own glass.
// lip   : a rim of bezel stays in front of the glass edge, so the screen sits
//         glass_lip below the surface.
front_style = "flush";  // [flush, lip]
glass_lip   = 0.60;
glass_gap   = 0.30;     // clearance round the glass; the visible seam in flush
glass_w     = 69.20;
glass_h     = 50.00;

// Measured on hardware: the picture sits 3 mm off centre towards the
// microphone end. Only matters in "lip" style, where the bezel frames it.
win_w       = 58.60;
win_h       = 44.20;
win_off_x   = -3.00;
win_off_y   = 0;

// The pocket follows the glass, which is square on the board even though the
// picture on it is not. Deliberately NOT win_off: sharing one offset once put
// the pocket off the glass and the board would not seat.
glass_off_x = 0;
glass_off_y = 0;

/* [USB-C opening] */
// Confirmed to fit at 13 x 8 but with room to spare, so trimmed. If a plug
// moulding fouls it, put these back up rather than filing the print.
usb_w      = 12.00;
usb_h      = 7.00;
usb_off_y  = 0;
usb_off_z  = 1.50;   // towards the back; the connector sits on the rear face

/* [How the board is held] */
// clamp  : four pegs in the lid push the board onto four stops in the front.
// screws : posts in the front, four M3 x 5.
retention = "clamp";  // [clamp, screws]

stop_od       = 5.50;  // pads the board's front face lands on
stop_bore     = 3.60;  // clears the peg spigot coming through the board
peg_od        = 5.50;
peg_spigot_d  = 3.00;  // enters the board's 3.2 mm hole and locates it
peg_spigot_h  = 1.40;  // shorter than the 1.6 mm board, so it cannot foul
peg_clearance = 0.10;  // slack between stop and peg

/* [Lid rim and snap] */
// The rim runs down the SIDE of the board rather than behind it. That is what
// keeps the case shallow: between the board and the wall there is now a proper
// channel, so the rim never has to clear the connectors that sit right on the
// board edge. It costs 4.5 mm of width and height and saves 4.7 mm of depth,
// and it lets the tabs be 8 mm long instead of 3 mm, which is the difference
// between a snap that flexes and one that snaps off.
board_clear = 0.80;   // between the board edge and the inside of the rim
lip_t       = 1.40;   // rim thickness; the tabs are cut from this
lip_clear   = 0.35;   // slip fit of the rim in its channel
snap_depth  = 0.80;   // barb beyond the rim face; engagement is this minus
                      // lip_clear, so 0.45 mm
snap_h      = 1.60;
snap_from_tip = 1.50; // barb near the free end, for the longest lever
tab_w       = 12.00;
tab_slot    = 1.50;   // slot either side, so each tab is a cantilever
tab_x       = 22.00;  // the two bottom tabs, at +/- this
back_gap    = 1.20;   // air behind the tallest component

pry_w       = 10.00;  // two slots, one per tab, in the bottom rear edge
pry_h       = 2.00;

/* [Fit and tolerances] */
wall       = 2.50;
front_t    = 1.60;   // bezel thickness
back_t     = 2.00;

/* [Wall mounting] */
keyhole_spacing = 60.00;
keyhole_big     = 8.00;
keyhole_small   = 4.20;
keyhole_drop    = 6.00;

/* [Hidden] */
$fn = 64;
eps = 0.01;

glass_pocket = (front_style == "flush") ? front_t : front_t - glass_lip;

// The channel the rim lives in, and with it the whole outer size.
ring    = board_clear + lip_t + lip_clear;
bore_w  = pcb_w + 2 * ring;
bore_h  = pcb_h + 2 * ring;
outer_w = bore_w + 2 * wall;
outer_h = bore_h + 2 * wall;
outer_r = pcb_r + ring + wall;

pcb_front_z = front_t - glass_pocket + glass_above;
pcb_back_z  = pcb_front_z + pcb_t;
comp_end_z  = pcb_back_z + comp_below;

inner_d = comp_end_z - front_t + back_gap;
outer_d = front_t + inner_d + back_t;

stop_h = pcb_front_z - front_t;              // pad depth, bezel to board
peg_h  = (front_t + inner_d) - pcb_back_z - peg_clearance;
screw_depth = stop_h + front_t - 0.60;       // blind, 0.6 mm of bezel left

// Rim reaches down beside the board to just short of its front face.
lip_h  = (front_t + inner_d) - (pcb_front_z - 0.50);
lip_ox = bore_w / 2 - lip_clear;
lip_oy = bore_h / 2 - lip_clear;

// Barb position, expressed once so the groove and the barb cannot drift apart.
// They did once, by 0.75 mm, and only half the barb engaged.
// The front stops short of the rear face by exactly the thickness of the back
// plate, which fills that last slice. Building the front to the full outer
// depth makes the two overlap by back_t, so the lid bottoms out early and the
// barb never reaches its groove. That is what it did.
front_d = outer_d - back_t;

snap_lo_local = back_t + lip_h - snap_from_tip - snap_h;
groove_lo_z   = outer_d - snap_lo_local - snap_h;

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

module rrect(w, h, r, th) {
    linear_extrude(th)
        offset(r = r) offset(r = -r)
            square([w, h], center = true);
}

module at_holes() {
    for (x = [-hole_dx / 2, hole_dx / 2])
        for (y = [-hole_dy / 2, hole_dy / 2])
            translate([x, y, 0]) children();
}

// Four sprung tabs, two down each long side. [x offset, y sign]
//
// An earlier version made the top a rigid hook to hang the front on. It does
// not work at this scale: clearing a 0.65 mm ledge means lifting the front
// 0.65 mm, which drives the bottom rim 0.30 mm into the wall, and tilting it
// in instead needs 0.85 mm of side clearance at 4 degrees where there is 0.35.
// A 12 mm deep bore will not pivot into a 0.35 mm gap.
tabs = [[-tab_x, 1], [tab_x, 1], [-tab_x, -1], [tab_x, -1]];

// ---------------------------------------------------------------------------
// Front: bezel, walls, board stops, snap grooves
// ---------------------------------------------------------------------------

module front() {
  difference() {
    union() {
      difference() {
        rrect(outer_w, outer_h, outer_r, front_d);

        // the bore: board and rim channel together
        translate([0, 0, front_t])
            rrect(bore_w, bore_h, pcb_r + ring, front_d - front_t + eps);

        // display window (subsumed by the opening in flush style)
        translate([win_off_x, win_off_y, -eps])
            rrect(win_w, win_h, 2, front_t + 2 * eps);

        // glass opening, or pocket in lip style
        translate([glass_off_x, glass_off_y, front_t - glass_pocket])
            rrect(glass_w + 2 * glass_gap, glass_h + 2 * glass_gap, 1,
                  glass_pocket + eps);

        // USB-C, straight out of the +X side. Deeper than the wall because
        // the plug now has the rim channel to cross as well.
        translate([outer_w / 2 - (wall + ring) / 2 + eps, usb_off_y,
                   pcb_back_z - pcb_t / 2 + usb_off_z])
            cube([wall + ring + 2 * eps, usb_w, usb_h], center = true);

        // Pry slots at the bottom rear edge, one directly opposite each tab.
        // Levering midway between them would mean bending the whole bottom
        // wall to release two catches 22 mm away; here the leverage lands
        // exactly where the barb holds, and either tab can be freed on its
        // own. Lever here and the bottom releases; the top tabs follow as the
        // front lifts away. Bottom only, so there is one obvious way in.
        for (t = tabs)
            if (t[1] < 0)
                translate([t[0], -outer_h / 2, front_d - pry_h / 2 + eps])
                    cube([pry_w, 2 * wall + 2 * eps, pry_h], center = true);

        // a groove per tab
        for (t = tabs)
            translate([t[0], t[1] * (bore_h / 2 + (snap_depth + lip_clear) / 2),
                       groove_lo_z + snap_h / 2])
                cube([tab_w + 2 * tab_slot + 1.0,
                      snap_depth + lip_clear + eps, snap_h], center = true);
      }

      // Stops the board's front face lands on. Without these nothing limits
      // how far forward the board travels and the glass stands proud.
      if (retention == "clamp")
          translate([0, 0, front_t])
              at_holes()
                  difference() {
                      cylinder(d = stop_od, h = stop_h);
                      translate([0, 0, -eps])
                          cylinder(d = stop_bore, h = stop_h + 2 * eps);
                  }

      if (retention == "screws")
          translate([0, 0, front_t - glass_pocket])
              at_holes() cylinder(d = stop_od, h = stop_h + glass_pocket);
    }

    if (retention == "screws")
        translate([0, 0, front_t + stop_h - screw_depth])
            at_holes() cylinder(d = 2.50, h = screw_depth + eps);
  }
}

// ---------------------------------------------------------------------------
// Back: plate, rim with sprung tabs, pegs, keyholes
// ---------------------------------------------------------------------------

module back() {
    difference() {
        union() {
            rrect(outer_w, outer_h, outer_r, back_t);

            // rim
            translate([0, 0, back_t - eps])
                difference() {
                    rrect(2 * lip_ox, 2 * lip_oy, pcb_r + ring - lip_clear,
                          lip_h);
                    translate([0, 0, -eps])
                        rrect(2 * (lip_ox - lip_t), 2 * (lip_oy - lip_t),
                              pcb_r + board_clear, lip_h + 2 * eps);
                }

            // Barbs, ramped on BOTH ends. The leading ramp lets the lid cam
            // itself in; the trailing one is what lets the front come off
            // again without breaking a tab, which matters because the board
            // has to be reachable later.
            for (t = tabs)
                translate([t[0], t[1] * lip_oy, snap_lo_local])
                    rotate([0, 0, t[1] > 0 ? 0 : 180])
                        hull() {
                            translate([-tab_w / 2, 0, 0])
                                cube([tab_w, eps, eps]);
                            translate([-tab_w / 2, snap_depth - eps,
                                       snap_h / 2])
                                cube([tab_w, eps, eps]);
                            translate([-tab_w / 2, 0, snap_h - eps])
                                cube([tab_w, eps, eps]);
                        }

            // pegs that carry the board
            if (retention == "clamp")
                translate([0, 0, back_t])
                    at_holes() {
                        cylinder(d = peg_od, h = peg_h);
                        translate([0, 0, peg_h - eps])
                            cylinder(d = peg_spigot_d, h = peg_spigot_h);
                    }
        }

        // Slots that turn each barb into a cantilever. Without them the rim is
        // a closed loop with nowhere to flex, and the lid will not go on at
        // all — which is exactly what the first printed pair did.
        for (t = tabs)
            for (s = [-1, 1])
                translate([t[0] + s * (tab_w / 2 + tab_slot / 2),
                           t[1] * lip_oy, back_t + lip_h / 2 + eps])
                    cube([tab_slot, 4 * (lip_t + snap_depth), lip_h + 2 * eps],
                         center = true);

        // gap in the rim where the USB-C cable passes
        translate([bore_w / 2, usb_off_y, back_t + lip_h / 2])
            cube([4 * (lip_t + snap_depth), usb_w + 3.0, lip_h + 2 * eps],
                 center = true);

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
// Test frame: outline, opening, stops. Cheap check of the board fit.
// ---------------------------------------------------------------------------

module test_frame() {
    t = front_t + 3.5;
    difference() {
        rrect(outer_w, outer_h, outer_r, t);

        translate([0, 0, front_t])
            rrect(bore_w, bore_h, pcb_r + ring, t);

        translate([win_off_x, win_off_y, -eps])
            rrect(win_w, win_h, 2, front_t + 2 * eps);

        translate([glass_off_x, glass_off_y, front_t - glass_pocket])
            rrect(glass_w + 2 * glass_gap, glass_h + 2 * glass_gap, 1,
                  glass_pocket + eps);

        translate([outer_w / 2 - (wall + ring) / 2, usb_off_y, t / 2])
            cube([wall + ring + 2 * eps, usb_w, t + 2 * eps], center = true);
    }

    if (retention == "clamp")
        translate([0, 0, front_t])
            at_holes()
                difference() {
                    cylinder(d = stop_od, h = stop_h);
                    translate([0, 0, -eps])
                        cylinder(d = stop_bore, h = stop_h + 2 * eps);
                }
}

// ---------------------------------------------------------------------------
// Clip test: one tab and the wall it snaps into. Print this before committing
// hours to the real parts.
// ---------------------------------------------------------------------------

module cliptest_slice(is_front) {
    slice = 34;
    // Sliced along the bottom edge, where the pry slots are, so the test piece
    // shows both halves of the job: does it click, and does it come apart.
    cut_y = -(bore_h / 2 + wall / 2 + 1);

    // The box spans the full height of whichever part it cuts. An earlier
    // version started above z=0 and the wall slice came out floating, with
    // nothing under it to print on.
    if (is_front)
        intersection() {
            front();
            translate([tab_x, cut_y, front_d / 2])
                cube([slice, 2 * wall + 6, front_d + 2], center = true);
        }
    else
        intersection() {
            back();
            translate([tab_x, cut_y, (back_t + lip_h) / 2])
                cube([slice, 2 * wall + 6, back_t + lip_h + 2], center = true);
        }
}

// ---------------------------------------------------------------------------

if (part == "front") front();
else if (part == "back") back();
else if (part == "test") test_frame();
else if (part == "cliptest-front") cliptest_slice(true);
else if (part == "cliptest-back") cliptest_slice(false);
