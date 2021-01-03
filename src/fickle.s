.charmap 'A',  1
.charmap 'B',  2
.charmap 'C',  3
.charmap 'D',  4
.charmap 'E',  5
.charmap 'F',  6
.charmap 'G',  7
.charmap 'H',  8
.charmap 'I',  9
.charmap 'J', 10
.charmap 'K', 11
.charmap 'L', 12
.charmap 'M', 13
.charmap 'N', 14
.charmap 'O', 15
.charmap 'P', 16
.charmap 'Q', 17
.charmap 'R', 18
.charmap 'S', 19
.charmap 'T', 20
.charmap 'U', 21
.charmap 'V', 22
.charmap 'W', 23
.charmap 'X', 24
.charmap 'Y', 25
.charmap 'Z', 26
.charmap ' ', 32
.charmap 'h', 83

TEXT_SPACE = 26
.include "c64Defines.s"
		.include "debug.s"

		.segment "SEG_MAIN"

;Put non-cart code after the stack
NON_CART_CODE_ADDRESS = $200

TEXT_LENGTH = initializationMessage_end - initializationMessage
TEXT_OFFSET = (40 * 9) + 20 - (TEXT_LENGTH / 2)
TEXT_LOCATION = $400  + TEXT_OFFSET
COLOUR_LOCATION = $D800 + TEXT_OFFSET

TEXT_LENGTH2 = initializationMessage2_end - initializationMessage2
TEXT_OFFSET2 = (40 * 15) + 20 - (TEXT_LENGTH2 / 2)
TEXT_LOCATION2 = $400  + TEXT_OFFSET2
COLOUR_LOCATION2 = $D800 + TEXT_OFFSET2

VAR_FOR_NTSC_DETECTION = 4

initialization2:
	;This is also where the decruncher puts the main code in RAM.

cartInitialization:
		.word @coldStart
		.word @warmStart
		.byte (67 | 128 ), (66 | 128), (77 | 128), 56, 48 

	@coldStart:
		STX VIC_II_MEMORY_SETUP_REG
		JSR ROM_INITIALIZE_IO_DEVICES
		JSR ROM_INITIALIZE_MEMORY_POINTERS
		JSR ROM_RESTORE_IO_VECTORS
		JSR ROM_ADDITION_TO_IO_DEVICE_INIT

	@warmStart:

initialization:
		;Disable interrupts, because we'll be writing over system memory
		;and changing the interrupt vectors.
		SEI

		;Detect PAL/NTSC (using an unreliable technique).
		LDA ROM_VARIABLES_PAL_NTSC
		STA VAR_FOR_NTSC_DETECTION

		;Copy some initialization code into RAM, including memcopy.
		LDY #$FF
	@loop:
		LDA NON_CART_CODE_SOURCE, Y
		STA NON_CART_CODE_ADDRESS, Y
		DEY
		CPY #$FF
		BNE @loop

		;Copy some initialization code into RAM, including memcopy.
		LDY #.LOBYTE(NON_CART_CODE_END - NON_CART_CODE_START)
	@loop2:
		LDA NON_CART_CODE_SOURCE + $FF, Y
		STA NON_CART_CODE_ADDRESS + $FF, Y
		DEY
		CPY #$FF
		BNE @loop2

		LDA #VIC_II_COLOUR_BLACK
		STA VIC_II_BORDER_COLOUR
		STA VIC_II_BACKGROUND_COLOUR_0

		LDY #TEXT_LENGTH
	@loop3:
		LDA initializationMessage - 1, Y
		STA TEXT_LOCATION - 1, Y
		LDA #VIC_II_COLOUR_WHITE
		STA COLOUR_LOCATION - 1, Y
		DEY
		BNE @loop3

   		LDY #TEXT_LENGTH2
	@loop4:
		LDA initializationMessage2 - 1, Y
		STA TEXT_LOCATION2 - 1, Y
		LDA #VIC_II_COLOUR_WHITE
		STA COLOUR_LOCATION2 - 1, Y
		DEY
		BNE @loop4

		LDA #VIC_II_COLOUR_PINK
		STA COLOUR_LOCATION + TEXT_LENGTH - 1

		JMP decompress

initializationMessage:
		.byte "FICKLEh"
initializationMessage_end:

initializationMessage2:
		.byte "A ONE-BUTTON REAL-TIME PUZZLE GAME"
initializationMessage2_end:

start_of_main_exo:
		.incbin "main.exo"
end_of_main_exo:
		.incbin "interrupts.exo"
end_of_interrupts_exo:

;*****************************************************************************
;* OTHER MEMORY AREAS
;*****************************************************************************

NON_CART_CODE_SOURCE:
	;Use an org rather than a segment, because .include interacts weirdly
	;with segments.
	.org NON_CART_CODE_ADDRESS
NON_CART_CODE_START:

get_crunched_byte:
		; Load from cart memory
		LDA #CART_CHAR_AND_KERNEL_VISIBLE
		STA C64_PROCESSOR_PORTS

        LDA _byte_lo
        BNE @byte_skip_hi
        DEC _byte_hi
@byte_skip_hi:
        DEC _byte_lo
_byte_lo = * + 1
_byte_hi = * + 2
        LDA end_of_interrupts_exo

		PHA
		LDA #JUST_IO_VISIBLE
		STA C64_PROCESSOR_PORTS
		PLA

        RTS

	decompress:
		;Decrunch interrupts.exo
		JSR decrunch
		
		LDA #.HIBYTE(end_of_main_exo)
        STA _byte_hi
        LDA #.LOBYTE(end_of_main_exo)
        STA _byte_lo

		JSR decrunch
		JMP knownStartAddress

	;Decrunch goes here.
		.include "../exomizer/exomizer2/exodecrs/exodecrunch.s"

NON_CART_CODE_END:
	.reloc

;*****************************************************************************
;* OTHER MEMORY AREAS
;*****************************************************************************

		.segment "DECRUNCHTABLE"
decrunch_table:

		.segment "SEG_INTERRUPT"
knownStartAddress:
