# Wall-mount enclosure for the ES3C28P

A parametric case for the LCDWIKI ES3C28P, in landscape orientation. The board
screws in on M3, the shell closes with a snap-fit groove, and the back plate has
two keyhole slots for wall screws. USB-C exits straight out of the right side.

Outer size **91.6 x 55.6 x 14.4 mm**.

Source: [`es3c28p-case.scad`](es3c28p-case.scad). Every dimension is a named
parameter at the top of the file.

## The glass sits nearly flush

The inside of the bezel is pocketed to the outline of the touch panel, so the
glass comes forward and only a **0.6 mm lip** is left in front of it. Without
that pocket you look at the picture down the full bezel thickness, which reads
as a recessed screen and throws a shadow line around the image.

`glass_pocket` controls it. Raising it to `front_t` removes the lip entirely and
makes the glass the outer surface, which looks best — but the touch panel spans
the full board width, so a flush opening leaves only 2.5 mm of frame above and
below it and exposes the glass edges. The 0.6 mm lip is the compromise: flush to
the eye, still a continuous frame.

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
