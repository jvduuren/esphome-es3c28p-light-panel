# Wall-mount enclosure for the ES3C28P

A parametric case for the LCDWIKI ES3C28P, in landscape orientation. The board
screws in on M3, the shell closes with a snap-fit groove, and the back plate has
two keyhole slots for wall screws. USB-C exits straight out of the right side.

Outer size **91.6 x 55.6 x 13.8 mm**.

Source: [`es3c28p-case.scad`](es3c28p-case.scad). Every dimension is a named
parameter at the top of the file.

## The glass is flush with the front

The opening goes right through the bezel and the glass fills it, so the two end
up level. Printed in black the whole front reads as a single surface, with only
a 0.3 mm seam around the glass.

That is `front_style = "flush"`, the default. Two things follow from it.

The board is no longer held by its glass. The opening is 69.8 x 50.6 mm while
the board is 86 x 50, so 8.1 mm of bare PCB at each end sits behind the bezel
and that is what stops it coming forward.

And nothing presses on the glass any more, so the **pegs alone decide how deep
the board sits**. `peg_clearance` therefore becomes exactly how far the glass
ends up below the surface: 0.1 mm, deliberately a touch under, because glass
standing proud of the bezel would catch a fingernail.

A side effect worth having: with no bezel framing the picture, the display
being 3 mm off centre stops mattering.

`front_style = "lip"` is the alternative, leaving `glass_lip` of bezel in front
of the glass edge. No seam and a little sturdier, but the screen sits below the
surface and you see the step.

## The display is not centred on the board

Measured on hardware: the picture sits **3 mm off centre**, towards the
microphone end. The black glass border is 3 mm on that side and 9 mm on the
USB-C side. The vendor drawing says nothing about this — it gives the display
and board sizes but not where one sits on the other.

`win_off_x = -3.00` accounts for it. Centring the window instead leaves 3 mm of
bare glass showing at the USB end while the bezel eats 3 mm of picture at the
other, which is exactly what the first test print did.

If your board differs, the offset is half the difference between the two black
borders.

**The window and the glass pocket have separate offsets, and they must.** The
picture is off centre *within the glass*; the glass itself sits square on the
board. Moving both together puts the pocket off the glass and the board will
not seat. `win_off_x` moves the opening, `glass_off_x` moves the pocket, and
for this board that is -3.00 and 0.

## Print the test frame first

Seriously. Set `part = "test"` and print that before anything else — a few
grams, about twenty minutes. It is deep enough to hold the board, so it checks
the outline, the four hole positions, the window alignment, the USB-C notch and
how flush the glass ends up sitting.

The reason for the caution: every dimension here was read out of the vendor's
drawing `ES3C28P_Size.pdf` as **text**, because the drawing itself is an image
and could not be measured. The numbers are the manufacturer's own, but the
*interpretation* — which offset belongs to which feature, whether the display
is centred along the long axis — was inferred. The USB-C position in particular
is a guess, which is why that opening is oversized.

If the test frame is off, fix it in the parameters and print it again. Fixing it
after a four-hour print of the shell is not fun.

## Printing

| | |
|---|---|
| Material | PLA or PETG both fine; PETG if it will sit in sunlight |
| Layer height | 0.2 mm |
| Walls | 3 perimeters |
| Infill | 15% |
| Supports | **None needed** for either part |
| Orientation | Front: bezel face down on the plate. Back: flat, outside down. |

Printing the front face down gives the smoothest visible surface and puts no
overhang anywhere that matters. The window opening and the USB-C notch both
bridge distances an A1 handles without help.

## Assembly

**No fasteners are needed** beyond the two screws that put the back plate on
the wall.

1. Screw the back plate to the wall through its keyhole slots.
2. Drop the board onto the four pegs. The spigots enter its mounting holes and
   locate it; the shoulders set how far back it sits.
3. Press the front on until the rib clicks into the groove. That squeezes the
   glass against the bezel and the board against the pegs.

To take it apart, lever the front off. The board lifts straight out.

This is `retention = "clamp"`, the default. The pegs are deliberately 0.2 mm
short of the board so the bezel, not the pegs, decides the depth — the glass
should end up against the bezel, not hanging off the pegs.

### If the clamp is not tight enough

The snap fit is load bearing in this arrangement, which is the one thing here
that cannot be checked on paper. If the front does not grip convincingly,
switch to `retention = "screws"` and re-render. The pegs disappear, posts
appear in the front, and you fasten the board with **four M3 x 5 pan head**
screws self-tapping into the 2.5 mm pilots. Do not overtighten; it is plastic.

Five millimetres, not six. There is 5.90 mm between the back of the board and
the bottom of the pilot hole, so an M3 x 6 bottoms out with its tip 0.10 mm
short and forcing it pushes through the 0.6 mm of bezel that is keeping the
screw invisible. An M3 x 5 still takes 3.4 mm of thread and leaves 0.9 mm
spare. Nothing shows on the outside either way: the pilots are blind and the
back plate covers the heads.

Heat-set inserts will not fit: an M3 insert wants roughly 4.2 mm of hole and
5.7 mm of depth, and there is only 4.3 mm available before the pilot would
break through the visible face.

## Tuning for your printer

| Parameter | What it does |
|---|---|
| `fit` | Clearance around the board. Raise it if the board will not drop in. |
| `snap_depth` | How hard the lid clicks. Lower it if the back will not go on, raise it if it falls off. |
| `win_off_x`, `win_off_y` | Nudge the window if the picture sits off centre. |
| `usb_off_y`, `usb_w`, `usb_h` | The USB-C opening. Verify this on the test frame. |
| `retention` | `clamp` for pegs on the back plate, `screws` for posts in the front. |
| `peg_clearance` | How much the pegs fall short. Raise it if the front will not close. |

## A note on the proportions

The bezel is wider at the sides than at the top and bottom: roughly 16.5 mm
against 5.7 mm. That is not a design choice, it is the board — 86 x 50 mm of
PCB carrying a 58.6 x 44.2 mm picture. Any enclosure that hugs this board will
look like this. Making the case taller than it needs to be would balance it
visually, at the cost of a larger object.

## Files

Rendered STLs are checked in, so you do not need OpenSCAD to print this — drop
them straight into Bambu Studio or any other slicer.

| | |
|---|---|
| [`test-frame.stl`](test-frame.stl) | fit check, print this first |
| [`front.stl`](front.stl) | bezel and walls |
| [`back.stl`](back.stl) | lid with keyholes |

To re-render after changing a parameter you do need
[OpenSCAD](https://openscad.org/):

```bash
openscad -D 'part="test"'  -o test-frame.stl es3c28p-case.scad
openscad -D 'part="front"' -o front.stl      es3c28p-case.scad
openscad -D 'part="back"'  -o back.stl       es3c28p-case.scad
```

Slicers do not read `.scad`, only the rendered STL.
