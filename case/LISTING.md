# Listing copy for MakerWorld / Printables

Everything below is ready to paste. The `---` rules separate the fields of the
upload form; they are not part of any field.

---

## Title

Wall mount for the LCDWIKI ES3C28P 2.8" ESP32-S3 touch display

*(Keep "ES3C28P" in the title. That SKU is how anyone who owns this board will
search for it.)*

---

## Summary / short description

A two-part snap-fit wall case for the LCDWIKI ES3C28P touch display. The glass
finishes flush with the bezel, the cable can leave to the left or the right, and
the only fasteners are the two screws that put it on the wall. No supports.

---

## Description

A wall-mount enclosure for the **LCDWIKI ES3C28P** — the 2.8" IPS ESP32-S3 touch
display module sold as a voice-assistant board, and a very good Home Assistant
light panel once you put it in something that looks deliberate.

Two parts, no fasteners. The board drops onto four pegs in the back plate, the
front presses on square, and four sprung tabs click it home. The only screws in
the whole thing are the two that hang the back plate on the wall.

**Outer size 96.1 x 60.1 x 13.8 mm.**

### What makes it worth printing

**The glass is flush with the front.** The opening goes right through the bezel
and the touch glass fills it, so the two finish level. Printed in black the front
reads as a single surface, with a 0.3 mm seam round the glass as the only
interruption. The board is held by four pads inside the bezel that its front face
lands on — the glass itself carries nothing.

**The cable can leave either side.** Print `front.stl` for a cable on the right
or `front-usb-left.stl` for one on the left. One back plate fits both: its rim is
notched on both sides and the keyholes are slotted both ways from their opening,
so it hangs either way up.

**It comes apart again.** Two pry slots in the bottom rear edge, one directly
opposite each of the bottom two tabs. A small flat screwdriver in either one and
a twist releases that side; the top tabs follow as you lift the front away. The
barbs are ramped on both faces on purpose — a one-way latch holds beautifully and
then has to be destroyed to get the board back out.

**The case is wider than the board, for a reason.** The obvious layout runs the
lid's rim behind the board. It cannot work on this module: the USB-C socket, the
battery, UART and speaker connectors all sit right on the board edge, and there
is 0.3 mm between the board and the wall. So the rim runs down the *side* of the
board in a channel of its own instead. That also leaves each snap tab 8 mm of
length to flex in rather than 3 mm, which is the difference between a tab that
springs and a tab that snaps off.

### Print it

| | |
|---|---|
| Material | PLA indoors; PETG if it will see sun |
| Layer height | 0.2 mm |
| Walls | 3 perimeters |
| Infill | 15% |
| Supports | **none** |
| Orientation | Front: bezel face down. Back: flat, outside down. |
| Print sequence | By layer, if both go on one plate |

**Print both parts on one plate.** The peg spigots in the back plate are 3 mm
across and only seven layers tall. Printed alone they never get time to cool and
come out soft; alongside the front, each layer takes long enough that they set.

The bed texture prints into whatever faces down. On a textured PEI plate the
bezel comes out matte and grainy, which looks deliberate in black. A smooth plate
gives gloss instead.

### Print the clip test first

`cliptest-front.stl` and `cliptest-back.stl` are a slice of wall and the matching
slice of lid — a few grams, about fifteen minutes. They answer the one question
the arithmetic cannot: does the snap actually grip on *your* printer, and can you
get it apart again.

Press them together, then lever them apart. If it grips too hard or not at all,
`snap_depth` in the source is the number to change. Only then commit to the real
parts.

They are two separate files on purpose — two disconnected shells in one STL is
the sort of thing a slicer is entitled to make a mess of.

### Assemble it

1. Screw the back plate to the wall through its keyhole slots.
2. Drop the board onto the four pegs; the spigots enter its mounting holes and
   locate it.
3. Press the front on, square. All four tabs deflect and click home.

The board ends up trapped between the pegs behind and the four stops inside the
bezel. Nothing can be assembled the wrong way round.

Mind the **connector angle** rather than the cable: a straight USB-C plug adds
about 20 mm to the depth. A right-angle plug matters more than a flat cable if
you want the panel close to the wall.

### It is parametric

The source is a single OpenSCAD file with every dimension as a named parameter at
the top. If your printer runs tight or loose, `snap_depth` and `lip_fit` are the
two numbers to touch — and `lip_fit` only affects the lid, so the front does not
need reprinting.

### The firmware

A complete ESPHome configuration for this board is on GitHub, along with the case
source: **https://github.com/jvduuren/esphome-es3c28p-light-panel**

Six lights in a grid, tap to toggle, long press for a dimmer, and a flip-clock
screensaver. The repo also documents the board's quirks, which cost real
debugging time: PSRAM is mandatory, the touchscreen does not follow the display
rotation, and SPI tops out at 40 MHz. If you fit the cable on the left, the
picture and the touch have to turn 180 degrees with the board — the config
carries both sets of values and switching is four lines.

---

## Tags

esphome, home assistant, esp32, esp32s3, es3c28p, lcdwiki, ili9341, touchscreen,
wall mount, enclosure, case, smart home, light switch, no supports, snap fit,
parametric, openscad

---

## Files to upload

| File | |
|---|---|
| `front.stl` | required — cable out to the right |
| `front-usb-left.stl` | required — cable out to the left |
| `back.stl` | required — fits either front |
| `cliptest-front.stl` | recommended |
| `cliptest-back.stl` | recommended |
| `es3c28p-case.scad` | optional, but it is what makes the model parametric |

Leave out `test-frame.stl`. It was a fit check during development and only
confuses a listing.

---

## Notes on the two platforms

**MakerWorld** wants a `.3mf` project with a print profile, not only STLs — that
is what its rewards scheme counts, and it means people can print it without
touching settings. Arrange both parts on one plate in Bambu Studio with print
sequence *by layer*, then **File → Export → Export Project** and upload that
alongside the STLs.

**Printables** is happy with STLs and will show the `.scad` as a source file.

Both ask for a licence. This repo is MIT, which does not map onto their Creative
Commons list — pick one deliberately. **CC BY** is the usual choice for something
you want people to build on; **CC BY-NC** if you would rather it were not sold.

Photographs do more for a listing than anything written here. One of the finished
panel on the wall, one of the two parts apart with the board visible, and one of
a screwdriver in a pry slot would cover it.
