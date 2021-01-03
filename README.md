# Fickle-C64
A one-button real-time puzzle game for the Commodore 64

Fickle: a one-button real-time puzzle game for the Commodore 64

(C)2014 Malcolm Tyrrell

Thank you for playing Fickle. The original game was released in 2011 for the
unexpanded Commodore Vic-20. I hope you enjoy this new version.

## Advice
The timer gives you a lot more time than it will take for Fickle to reach the
heart, so I recommend you try to plan a route through the level before you
start.

## Rotor behaviour
In the original releases, clockwise rotors would fling Fickle to the left and
anticlockwise rotors would fling Fickle to the right. The reviewers of the C64
version suggested that this was counterintuitive. I tried the alternative, and
although it took a few moments to get used to it, I now feel that they are
correct. From now on, clockwise rotors will twist Fickle to the right and
anticlockwise rotors will twist Fickle to the left. If you prefer the original
behaviour, there is a rotor option in the settings menu.

## Cheating
You can skip levels with the Restore key, but this will cause the game to
withhold its love.

## Compatibility
Fickle is compatible with both PAL and NTSC C64s. The music is faster on NTSC
machines, but aside from that the two versions should be identical.

## Credits
Fickle was made with tools from the cc65 compiler suite (http://www.cc65.org/),
the Exomizer 2 compressor (http://hem.bredband.net/magli143/exo/), and the
Goattracker2 sid tracker software (http://covertbitops.c64.org/).

Thanks to all those responsible for the above.

## Building Fickle

Fickle was developed on a Debian GNU/Linux environment. It shouldn't be
difficult to build it on other operating systems, but it will require a
little adjustment.

Required tools:
* ca65 and ld65 (from the cc65 compiler suite)
* exomizer (from Exomizer 2 - I use a slightly customized version, which is in a git submodule of this repo)
* ins2snd2 (from Goattracker 2)
* cartconv (from VICE)
* Make (e.g. from the GNU project)
* Python (e.g. version 2.7)

You'll need to update git submodules to get the exomizer submodule.

## How Fickle is built

Fickle is built in a few phases. 
* First, we take all the important source, and build main.bin and
  interrupts.bin.
* Next, we compress those into main.exo and interrupts.exo.
* We then build fickle.bin, a program which contains the logic to decompresses
  the content of the .exo files from cart memory into RAM.
* Finally, we convert fickle.bin into fickle.crt, the final product.

## Debug mode

Edit debug.s so DEBUG is set to 1. This will add debug colours to the border.

## About Graphics

Most of the code is done in the expected way and is mostly kludgy. Perhaps the
one feature worth noting is how the hi-resolution level graphics are done.

I used extended colour mode for the level body. This allows the use of four
background colours without needing blocky pixels. However, it limits you to
64 character codes. The latter restriction is very painful, even for a game as
constrained as Fickle. To free up more characters I used two additional
techniques:
* The status bars (called the Heads-Up Display, or HUD, in the source) actually
  reside in sprites, which are multiplexed all the way down the screen.
* The graphics for the left and right switch handle share the same character
  code. I swap their graphics memory after the switch is thrown.

Level elements which can be partially hidden by sprites (rotors, teleports and
the heart), were carefully designed so the upward spike exposes a contiguous
block of colour. I modify the colour attributes of the screen to update
partially hidden animations.

## Heads-Up Display

All sprite multiplexing in Fickle is done using the half-sprite technique (see
web for details). Since the HUD is multiplexed all the way down the screen, it
requires a raster interrupt approximately every 11 lines.

The half-sprite technique requires one additional sprite graphic for every pair
of sprite graphics which are vertically contiguous. I always put the extra
graphics in between the other two, and this makes the layout of the graphics
memory very complicated. For this reason, I build a 400-byte look-up table
(lineTable.s, built by the python program buildLineTable.py), which stores the
address of the first byte which must be updated when drawing to a given row.
Because every row gets duplicated in a half-sprite, both the address and the
address plus 64 must be updated.

## Multiplexing Fickle and the Skull

Fickle and the skull consist of one 2*2 sprite (I call this a quad sprite) and
one normal sprite each. The quad sprite is made up of two sprites, multiplexed
using the half-sprite technique.

As far as I know, the usual way to do sprite multiplexing is to have one or
more raster interrupts set near the line you want the sprites swapped. This
requires that the interrupt table be prepared at the end of each frame.

Since the HUD already requires an interrupt every 11 lines, and since the main
end-of-frame interrupt was pretty tight for time (on NTSC machines), I decided
to multiplex the game sprites with a fixed set of interrupts interleaved with
the HUD ones for the whole screen. There is no time spent at the end of each
frame preparing the interrupt table, because it's always the same. On the other
hand, there is now a raster interrupt every 6 lines (approx.), so the work you
can do in an interrupt is limited. To maximize the time available for those
interrupts, I don't bother storing and restoring registers (possible because
the game's main loop is just a JMP to itself).

The logic which lays out the interrupt table is pretty complicated, so the
python program buildInterruptTables.py is used to create the file
interruptTables.s

## License

You may use or distribute Fickle and its source code under the terms of the
AGPL version 3 or later. See the file agpl-3.0.txt in this folder.

The license for the exodecrunch.s code is slightly different, and is described
at the top of that file.

## Contact
If you make any use out of this code, I'd love to hear from you. Contact me
at: Malcolm.R.Tyrrell@gmail.com.
