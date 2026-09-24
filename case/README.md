# Wall-mount enclosure for the ES3C28P

A parametric case for the LCDWIKI ES3C28P, in landscape orientation. The board
screws in on M3, the shell closes with a snap-fit groove, and the back plate has
two keyhole slots for wall screws. USB-C exits straight out of the right side.

Outer size **91.6 x 55.6 x 15.8 mm**.

Source: [`es3c28p-case.scad`](es3c28p-case.scad). Every dimension is a named
parameter at the top of the file.

## Print the test frame first

Seriously. Set `part = "test"` and print that before anything else — it is a
3 mm sliver, a few grams, about fifteen minutes. It checks the board outline,
the four hole positions, the window alignment and the USB-C notch.

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

1. Drop the board into the front shell, glass against the inside of the bezel.
   The four posts set the depth so the glass sits flush.
2. Four M3 screws, 6 mm, through the board into the posts. They self-tap into
   the 2.5 mm pilot holes. Do not overtighten — it is plastic.
3. Press the back plate on until the rib clicks into the groove.

If you would rather use heat-set inserts or nuts, set `boss_pilot = 3.20`.

## Tuning for your printer

| Parameter | What it does |
|---|---|
| `fit` | Clearance around the board. Raise it if the board will not drop in. |
| `snap_depth` | How hard the lid clicks. Lower it if the back will not go on, raise it if it falls off. |
| `win_off_x`, `win_off_y` | Nudge the window if the picture sits off centre. |
| `usb_off_y`, `usb_w`, `usb_h` | The USB-C opening. Verify this on the test frame. |
| `boss_pilot` | 2.50 for self-tapping M3, 3.20 for nuts or inserts. |

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
