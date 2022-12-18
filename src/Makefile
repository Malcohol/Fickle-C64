all: fickle.crt

CA65 = ca65
LD65 = ld65
PYTHON = python3
# Part of the Vice emulator project.
CARTCONV = cartconv
# This is part of the GoatTracker2 project.
INS2SND2 = ins2snd2
# This is slightly customized, so I put it in a submodule.
EXOMIZER = ../exomizer/exomizer2/src/exomizer

SOURCE_FILES = main.s c64Defines.s vars.s main.s constants.s characters.s tiles.s tables.s levels.s walls.s sprites.s hud.s sprites2.s frames.s debug.s textScreens.s interrupts.s textCharacters.s 

GEN_SOURCE_FILES = interruptTables.s lineTable.s

SOUND_EFFECTS = sfx_wallBounce.bin sfx_rotorTurn.bin sfx_spikeDeath.bin sfx_takeKey.bin sfx_playerBounce.bin sfx_wobble0.bin sfx_wobble1.bin sfx_teleport.bin sfx_completion.bin sfx_laugh0.bin sfx_laugh1.bin sfx_laugh2.bin sfx_laugh3.bin sfx_electrocution.bin sfx_openDoor.bin sfx_switch.bin sfx_silence.bin


# Phase 1: Build main.bin

main.bin interrupts.bin: main.o linker.cfg
	$(LD65) -o $@ -C linker.cfg -Ln main.labels $<

main.o:	$(SOURCE_FILES) $(GEN_SOURCE_FILES) $(SOUND_EFFECTS) ../Music/music.bin
	$(CA65) --cpu 6502X -g $<

lineTable.s: buildLineTable.py
	$(PYTHON) buildLineTable.py -o lineTable.s

interruptTables.s: buildInterruptTables.py
	$(PYTHON) buildInterruptTables.py -o interruptTables.s

sfx_%.bin: ../Music/sfx_%.ins
	$(INS2SND2) $< $@ -b

# Phase 2: Build fickle.crt

main.exo: main.bin
	$(EXOMIZER) mem -o $@ $<,32768 | grep "The load address\|Literal sequences"

interrupts.exo: interrupts.bin
	$(EXOMIZER) mem -o $@ $<,52736 | grep "The load address\|Literal sequences"

fickle.o: fickle.s main.exo interrupts.exo debug.s ../exomizer/exomizer2/exodecrs/exodecrunch.s
	$(CA65) -o $@ --cpu 6502X -g $<

fickle.bin: fickle.o fickle.cfg
	$(LD65) -o $@ -C fickle.cfg -Ln fickle.labels $<

fickle.crt: fickle.bin
	$(CARTCONV) -t normal -i fickle.bin -o fickle.crt

clean:
	rm -f *.o *.bin main.labels fickle.crt lineTable.s viclog fickle.labels *.exo $(GEN_SOURCE_FILES)
