		.segment "SEG_INTERRUPT"

		NOP
		NOP

knownStartAddress:
		JMP initialization

interrupt:
		debug DEBUG_MAIN

		;Switch off HUD sprites, because their bottom will be visible.
		LDA #255
		STA VIC_II_SPRITE_7_X
		LDA #0
		STA VIC_II_SPRITE_6_X
		LDA #0
		STA VIC_II_SPRITE_ENABLE
		
		;Disable top/bottom border
		LDA #%01010011
		STA VIC_II_SCREEN_CONTROL_REG

		;This is always the last interrupt.
		LDX #ZP_LUT_INTERRUPT_ROUTINES
		LDA 0, X
		STA VIC_II_RASTER_LINE
		INX
		LDA 0, X
		STA INTERRUPT_PTR
		INX
.assert .HIBYTE(entitySpriteInterrupt) = .HIBYTE(interrupt), error, "Need words in interrupt table"
		;LDA 0, X
		;STA INTERRUPT_PTR_HI
		;INX

		STX var::interrupt_routine_index

		;We allow the main interrupt to be interrupted.
		LDA #%11111111
		STA VIC_II_INTERRUPT_STATUS

		JSR stepGame

		;Disable top/bottom border
		LDA #%01011011
		STA VIC_II_SCREEN_CONTROL_REG

		enddebug
		RTI

reenableSpritesInterrupt:
	;Because we disable the top/bottom borders, the VIC would redraw sprites
	;when it passes raster 255. Instead we disable them at the beginning of
	;the main interrupt and reenable them here.
		debug DEBUG_REENABLE_SPRITES

		LDA var::sprite_enable
		STA VIC_II_SPRITE_ENABLE
		LDA #HUD_LEFT_X_POS
		STA VIC_II_SPRITE_6_X
		LDA #HUD_RIGHT_X_POS
		STA VIC_II_SPRITE_7_X
		LDA var::memory_pointers_top
		STA VIC_II_MEMORY_POINTERS

		JMP return_to_interrupt

hudBumpGraphicsRoutine:
		debug DEBUG_BUMP_GRAPHICS

		INC SPRITE_6_INDEX
		INC SPRITE_7_INDEX

		CLC
		LDA VIC_II_SPRITE_6_Y
		ADC #21
		STA VIC_II_SPRITE_6_Y
		STA VIC_II_SPRITE_7_Y

		JMP entitySpriteCommon

hudBumpGraphicsRoutineAndColour0:
		debug DEBUG_GRAPHICS_AND_COLOUR_0

		LDA var::life_colour_2
		STA VIC_II_SPRITE_6_COLOUR
		LDA var::key_colour_2
		STA VIC_II_SPRITE_7_COLOUR

commonBumpGraphicsRoutine:
		INC SPRITE_6_INDEX
		INC SPRITE_7_INDEX

		CLC
		LDA VIC_II_SPRITE_6_Y
		ADC #21
		STA VIC_II_SPRITE_6_Y
		STA VIC_II_SPRITE_7_Y

		JMP entitySpriteCommon

hudBumpGraphicsRoutineAndColour2:
		debug DEBUG_GRAPHICS_AND_COLOUR_2

		LDA var::life_colour_3
		STA VIC_II_SPRITE_6_COLOUR
		LDA var::key_colour_3
		STA VIC_II_SPRITE_7_COLOUR

		JMP commonBumpGraphicsRoutine

hudBumpGraphicsRoutine2AndColour1:
		debug DEBUG_GRAPHICS_AND_COLOUR_1

		LDA #HEART_COLOUR
		STA VIC_II_SPRITE_6_COLOUR
		LDA var::timebar_colour
		STA VIC_II_SPRITE_7_COLOUR

		INC SPRITE_6_INDEX
		INC SPRITE_7_INDEX

		JMP entitySpriteCommon

hudBumpGraphicsRoutine2:
		debug DEBUG_BUMP_GRAPHICS_2

		INC SPRITE_6_INDEX
		INC SPRITE_7_INDEX

		JMP entitySpriteCommon

hudChangeColourRoutine3:
		debug DEBUG_CHANGE_COLOUR_3
		
		LDA var::life_colour_1
		STA VIC_II_SPRITE_6_COLOUR
		LDA var::key_colour_1
		STA VIC_II_SPRITE_7_COLOUR

		JMP entitySpriteCommon

setMemoryPointersBottom:
		;This is used in the instructions to allow different animations
		;for the rotors and hilight.
		LDA var::memory_pointers_bottom
		STA VIC_II_MEMORY_POINTERS

entitySpriteInterrupt:
		debug DEBUG_ENTITY_SPRITE

entitySpriteCommon:
		DEC var::sprite_1_interrupt_counter_0
		BNE notSprite1_First

INTERRUPT_UPDATE_ADDRESS_0 = * + 2
		INC SPRITE_1_INDEX
INTERRUPT_UPDATE_ADDRESS_1 = * + 2
		INC SPRITE_2_INDEX

		CLC
		LDA VIC_II_SPRITE_1_Y
		ADC #21
		STA VIC_II_SPRITE_1_Y
		STA VIC_II_SPRITE_2_Y

	notSprite1_First:
		DEC var::sprite_1_interrupt_counter_1
		BNE notSprite1_Second

INTERRUPT_UPDATE_ADDRESS_2 = * + 2
		INC SPRITE_1_INDEX
INTERRUPT_UPDATE_ADDRESS_3 = * + 2
		INC SPRITE_2_INDEX

	notSprite1_Second:

		DEC var::sprite_4_interrupt_counter_0
		BNE notSprite4_First

INTERRUPT_UPDATE_ADDRESS_4 = * + 2
		INC SPRITE_4_INDEX
INTERRUPT_UPDATE_ADDRESS_5 = * + 2
		INC SPRITE_5_INDEX

		CLC
		LDA VIC_II_SPRITE_4_Y
		ADC #21
		STA VIC_II_SPRITE_4_Y
		STA VIC_II_SPRITE_5_Y
	
	notSprite4_First:

		DEC var::sprite_4_interrupt_counter_1
		BNE notSprite4_Second
INTERRUPT_UPDATE_ADDRESS_6 = * + 2
		INC SPRITE_4_INDEX
INTERRUPT_UPDATE_ADDRESS_7 = * + 2
		INC SPRITE_5_INDEX

	notSprite4_Second:

		;Fall through

return_to_interrupt:
		LDX var::interrupt_routine_index
		LDA 0, X
		STA VIC_II_RASTER_LINE
		INX
		LDA 0, X
		STA INTERRUPT_PTR
		INX
.assert .HIBYTE(entitySpriteInterrupt) = .HIBYTE(interrupt), error, "Need words in interrupt table"
		;LDA 0, X
		;STA INTERRUPT_PTR_HI
		;INX
		STX var::interrupt_routine_index

		enddebug

		LDA #%11111111
		STA VIC_II_INTERRUPT_STATUS

		RTI

