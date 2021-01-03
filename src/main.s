		.include "c64Defines.s"
		.include "debug.s"
		.include "vars.s"
		.include "constants.s"
		.include "characters.s"
		.include "tiles.s"
		.include "walls.s"
		.include "levels.s"
		.include "tables.s"
		.include "interruptTables.s"
		.include "hud.s"
		.include "sprites.s"
		.include "sprites2.s"
		.include "frames.s"
		.include "lineTable.s"
		.include "textScreens.s"
		.include "textCharacters.s"
		.include "interrupts.s"

		.segment "SEG_MAIN"

		;These NOPs balance out some weirdness in exomizer I don't have time
		;to understand.
		NOP
		NOP

VAR_FOR_NTSC_DETECTION = 4

.macro playSfx SoundAddress
		LDA #.LOBYTE(SoundAddress)
		LDY #.HIBYTE(SoundAddress)
		LDX #SOUND_EFFECTS_CHANNEL
		JSR PLAY_EFFECT
.endmacro

music:
PLAY_MUSIC = * + 3
PLAY_EFFECT = * + 6
		.incbin "../Music/music.bin"

wobble0Sound:
		.incbin "sfx_wobble0.bin"

wobble1Sound:
		.incbin "sfx_wobble1.bin"

playerBounceSound:
		.incbin "sfx_playerBounce.bin"

rotorSound:
		.incbin "sfx_rotorTurn.bin"

takeKeySound:
		.incbin "sfx_takeKey.bin"

teleportSound:
		.incbin "sfx_teleport.bin"

openDoorSound:
		.incbin "sfx_openDoor.bin"

switchSound:
		.incbin "sfx_switch.bin"

laugh0Sound:
		.incbin "sfx_laugh0.bin"

laugh1Sound:
		.incbin "sfx_laugh1.bin"

laugh2Sound:
		.incbin "sfx_laugh2.bin"

laugh3Sound:
		.incbin "sfx_laugh3.bin"

completionSound:
		.incbin "sfx_completion.bin"

spikeDeathSound:
		.incbin "sfx_spikeDeath.bin"

electrocutionSound:
		.incbin "sfx_electrocution.bin"

silentSound:
		.incbin "sfx_silence.bin"

initialization:
		LDA #BORDER_COLOUR
		STA VIC_II_BORDER_COLOUR
		;Border initially covers screen.
		LDA #%01000011
		STA VIC_II_SCREEN_CONTROL_REG

		;Detect PAL/NTSC (using an unreliable technique).
		LDA #0
		LDX VAR_FOR_NTSC_DETECTION
		BNE @pal

		LDX #REGION_VARS_END - REGION_VARS
	@region_loop:
		LDA NTSC_VARS - 1, X
		STA REGION_VARS - 1, X
		DEX
		BNE @region_loop

		LDA #SPEEDS_NTSC_OFFSET 

	@pal:
		STA var::region_speed_offset

		;Set up the ports for keyboard joystick access.
		LDA #$FF
		STA CIA1_PORT_A_DDR
		LDA #0
		STA CIA1_PORT_B_DDR

		LDA #FLOOR_COLOUR
		STA VIC_II_BACKGROUND_COLOUR_0

		LDA #%00000000
		STA VIC_II_SPRITE_DOUBLE_HEIGHT
		STA VIC_II_SPRITE_DOUBLE_WIDTH
		STA VIC_II_SPRITE_PRIORITY
		STA VIC_II_SPRITE_MULTICOLOUR

		LDA #JUST_IO_VISIBLE
		STA C64_PROCESSOR_PORTS

		;We don't want CIA interrupts.
		LDA #%01111111
		STA CIA1_INTERRUPT_CONTROL
		STA CIA2_INTERRUPT_CONTROL

		;Negate pending CIA interrupts.
		LDA CIA1_INTERRUPT_CONTROL
		LDA CIA2_INTERRUPT_CONTROL

		LDA #%00000001
		STA VIC_II_INTERRUPT_CONTROL

		JSR initializeCharacterGraphics
		LDA #0
		STA var::memcopy_target_offset_hi
		JSR initializeSpriteGraphics
		LDA #$40
		STA var::memcopy_target_offset_hi
		JSR initializeSpriteGraphics

		LDA #0
		STA var::text_settings_music
		STA var::text_settings_speed
		STA var::text_settings_colours
		STA var::text_settings_rotors

		JSR setNormalColourScheme
		JSR setSpeed

		JSR initializeHud

		JSR drawKeys

		;Copy the interrupt table to the end of the zero page.
		LDA #.hibyte(LUT_INTERRUPT_ROUTINES_END - LUT_INTERRUPT_ROUTINES)
		STA var::memcopy_num_bytes_hi
		LDA #.lobyte(LUT_INTERRUPT_ROUTINES_END - LUT_INTERRUPT_ROUTINES)
		STA var::memcopy_num_bytes
		LDA #.hibyte(LUT_INTERRUPT_ROUTINES)
		STA var::memcopy_source_ptr_hi
		LDA #.lobyte(LUT_INTERRUPT_ROUTINES)
		STA var::memcopy_source_ptr
		LDA #0
		STA var::memcopy_target_ptr_hi
		LDA #ZP_LUT_INTERRUPT_ROUTINES
		STA var::memcopy_target_ptr
		JSR memcopy

		LDX #SOME_CART_AND_CHAR_ROM_VISIBLE 
		STX C64_PROCESSOR_PORTS

		;Copy chars from charrom for the text screens
		LDA #.HIBYTE(TEXT_EXTRA_CHAR_SOURCE_0)
		STA var::charblock_source_ptr_hi
		LDA #.LOBYTE(TEXT_EXTRA_CHAR_SOURCE_0)
		STA var::charblock_source_ptr
		LDA #0 
		STA var::memcopy_target_offset_hi
		LDA #4
		STA var::charBlock_temp

	@textBlockLoop:
		JSR textCharacterBlockCopy
		CLC
		LDA var::memcopy_target_offset_hi
		ADC #8
		STA var::memcopy_target_offset_hi
		CLC
		LDA var::charblock_source_ptr
		ADC #TEXT_EXTRA_CHAR_SOURCE_0_END - TEXT_EXTRA_CHAR_SOURCE_0
		STA var::charblock_source_ptr
		LDA var::charblock_source_ptr_hi
		ADC #0
		STA var::charblock_source_ptr_hi

		DEC var::charBlock_temp
		BNE @textBlockLoop

		LDA #JUST_IO_VISIBLE
		STA C64_PROCESSOR_PORTS

		;Start at instructions the first time.
		LDA #1
		STA var::text_current_option
		JSR initTitleScreenAtOption

		LDA #255
		STA var::rotors_direction

		LDA BOTTOM_OF_SCREEN_RASTER
		STA VIC_II_RASTER_LINE

		;The bottom interrupt is the one we trigger first, but when it is finished, it should
		;set up the top interrupt.
		LDX #ZP_LUT_INTERRUPT_ROUTINES
		STX var::interrupt_routine_index

		;The kernal is banked out here, so we can set up the interrupt vector.
		LDA #.HIBYTE(interrupt)
		STA INTERRUPT_PTR_HI
		LDA #.LOBYTE(interrupt)
		STA INTERRUPT_PTR

		; Default to subtune 0 = music on.
		LDA #0
		JSR music

		LDA #.LOBYTE(nmiInterrupt)
		STA NMI_INTERRUPT_PTR
		LDA #.HIBYTE(nmiInterrupt)
		STA NMI_INTERRUPT_PTR_HI

		;Restore interrupt handling.
		CLI

		;Initialization over. Everything else done using interrupt handlers.
		;This must have no interresting code in it, because the interrupts do
		;not restore registers.
	@stop:
		JMP @stop

textCharacterBlockCopy:
		;Copy chars from charrom for the text screens
		CLC
		LDA #.HIBYTE(TEXT_CHAR_ADDRESS)
		ADC var::memcopy_target_offset_hi
		STA var::memcopy_target_ptr_hi
		LDA #.LOBYTE(TEXT_CHAR_ADDRESS)
		STA var::memcopy_target_ptr

		LDX #0
	@textBlockLoop:
		LDA LUT_TEXT_CHARBLOCKS, X
		STA var::memcopy_source_ptr
		INX
		LDA LUT_TEXT_CHARBLOCKS, X
		STA var::memcopy_source_ptr_hi
		BEQ @finishTextCopy
		INX
		LDA LUT_TEXT_CHARBLOCKS, X
		STA var::memcopy_num_bytes
		LDA #0
		STA var::memcopy_num_bytes_hi
		TXA
		PHA
		JSR memcopy
		PLA
		TAX
		INX
		JMP @textBlockLoop
	@finishTextCopy:

		;Add extra chars not taken from character ROM.
		LDY #TEXT_EXTRA_CHAR_SOURCE_END - TEXT_EXTRA_CHAR_SOURCE - 1
	@extraCharSourceLoop:
		LDA TEXT_EXTRA_CHAR_SOURCE, Y
		STA (var::memcopy_target_ptr), Y
		DEY
		CPY #$FF
		BNE @extraCharSourceLoop

		CLC
		LDA var::memcopy_target_ptr
		ADC #TEXT_EXTRA_CHAR_SOURCE_END - TEXT_EXTRA_CHAR_SOURCE
		STA var::memcopy_target_ptr
		LDA var::memcopy_target_ptr_hi
		ADC #0
		STA var::memcopy_target_ptr_hi

		LDA var::charblock_source_ptr
		STA var::memcopy_source_ptr
		LDA var::charblock_source_ptr_hi
		STA var::memcopy_source_ptr_hi

		;Add extra chars not taken from character ROM.
		LDY #TEXT_EXTRA_CHAR_SOURCE_0_END - TEXT_EXTRA_CHAR_SOURCE_0 - 1
	@extraCharSourceLoop2:
		LDA (var::memcopy_source_ptr), Y
		STA (var::memcopy_target_ptr), Y
		DEY
		CPY #$FF
		BNE @extraCharSourceLoop2

		RTS

startStateTransition:
		;Silence any outstanding sound-effects.
		playSfx silentSound
		SEI
		;Border covers screen
		LDA #%01000011
		STA VIC_II_SCREEN_CONTROL_REG

		LDA BOTTOM_OF_SCREEN_RASTER
		STA VIC_II_RASTER_LINE

		LDA #.HIBYTE(transitionalInterrupt)
		STA INTERRUPT_PTR_HI
		LDA #.LOBYTE(transitionalInterrupt)
		STA INTERRUPT_PTR

		CLI

		RTS

endStateTransition:
		SEI
		LDA BOTTOM_OF_SCREEN_RASTER
		STA VIC_II_RASTER_LINE

		LDX #ZP_LUT_INTERRUPT_ROUTINES
		STX var::interrupt_routine_index

		LDA #.HIBYTE(interrupt)
		STA INTERRUPT_PTR_HI
		LDA #.LOBYTE(interrupt)
		STA INTERRUPT_PTR

		;The end of this interrupt will now reset the main interrupt as the next one to run.
		LDX #ZP_LUT_INTERRUPT_ROUTINES + (BOTTOM_OF_SCREEN_RASTER - LUT_INTERRUPT_ROUTINES)
		STX var::interrupt_routine_index

		CLI
		RTS

initGame:
		; Set the Vic Bank
		LDA CIA2_PORT_A_VIC_BANK	
		AND #%11111100
		ORA #(3 - VIC_BANK)
		STA CIA2_PORT_A_VIC_BANK

		LDA #%11000100
		STA VIC_II_SCREEN_CONTROL_REG2

		LDA #(SCREEN_MEMORY << 4)
		STA var::memory_pointers_top
		STA var::memory_pointers_bottom
		STA VIC_II_MEMORY_POINTERS

		LDA var::colour_wall_top
		STA VIC_II_BACKGROUND_COLOUR_1
		LDA var::colour_wall_edge
		STA VIC_II_BACKGROUND_COLOUR_2
		LDA #DOOR_TOP_COLOUR
		STA VIC_II_BACKGROUND_COLOUR_3

		JSR clearScreen
		JSR drawHeartBar
		JSR drawLives

		LDA #0
		STA var::level_num
		STA var::has_cheated
		LDA #.LOBYTE(level_0)
		STA var::level_data_ptr
		LDA #.HIBYTE(level_0)
		STA var::level_data_ptr_hi

		LDA #TOTAL_NUM_LIVES
		STA var::num_lives

		JSR initLevel
		RTS

initLevel:
		LDA #GAME_STATE_PLAYING_LEVEL
		STA var::game_state

		LDA #0
		STA var::animation_countdown
		STA var::animation_counter
		LDA #(SCREEN_MEMORY << 4)
		STA var::memory_pointers_top
		STA var::memory_pointers_bottom

		LDA #0
		STA var::num_keys
		STA var::num_teleports
		STA var::num_switches
		STA var::key_state
		STA var::key_event
		STA var::player_z_pxl
		STA var::player_x_subpxl
		STA var::player_y_subpxl
		STA var::num_baddies
		STA var::static_subpxl
		STA var::static_pxl	
		STA var::were_colliding
		STA var::is_cheating

		LDA #3
		STA var::old_sound
		LDA #BADDY_COLOUR
		STA var::baddy_colour

		LDA var::colour_dont
		STA var::player_colour
		LDA #PLAYER_STATE_START
		STA var::player_state
		LDA #BADDY_STATE_NORMAL
		STA var::baddy_state

		LDA #FRAME_PLAYER_MED_L
		STA var::player_frame

		LDA #TIMEBAR_COLOUR
		STA var::timebar_colour
		JSR drawTimeBar

		LDA #NO_KEY_COLOUR
		STA var::key_colour_0
		STA var::key_colour_1
		STA var::key_colour_2
		STA var::key_colour_3

		LDA #NO_LIFE_COLOUR
		STA var::life_colour_0
		STA var::life_colour_1
		STA var::life_colour_2
		STA var::life_colour_3
	
		LDY var::num_lives
		DEY
		BEQ @afterLives
		LDA var::colour_dont
		STA var::life_colour_0
		DEY
		BEQ @afterLives
		LDA var::colour_do
		STA var::life_colour_1
		DEY
		BEQ @afterLives
		LDA var::colour_do
		STA var::life_colour_2
		DEY
		BEQ @afterLives
		LDA var::colour_dont
		STA var::life_colour_3
	@afterLives:
		
		JSR resetSwitchTables
		JSR drawLevel
		JSR setupSpikeOverlaps
		JSR buildBarrierPrograms

		LDA var::text_settings_colours
		BEQ @normalColours
		JSR mapScreenToAlternativeColours
	@normalColours:

		LDA var::num_baddies
		BEQ @noBaddies
		LDA #%11111111
		STA var::sprite_enable
		JMP @afterEnable

	@noBaddies:
		LDA #%11000111
		STA var::sprite_enable
	@afterEnable:

		LDA #.hibyte(SPRITE_0_INDEX)
		STA INTERRUPT_UPDATE_ADDRESS_0
		STA INTERRUPT_UPDATE_ADDRESS_1
		STA INTERRUPT_UPDATE_ADDRESS_2
		STA INTERRUPT_UPDATE_ADDRESS_3
		STA INTERRUPT_UPDATE_ADDRESS_4
		STA INTERRUPT_UPDATE_ADDRESS_5
		STA INTERRUPT_UPDATE_ADDRESS_6
		STA INTERRUPT_UPDATE_ADDRESS_7

		RTS

stepGame:
		debug DEBUG_MUSIC
		JSR PLAY_MUSIC

		debug DEBUG_MAIN
		LDA var::game_state
		CMP #GAME_STATE_PLAYING_LEVEL
		BNE @notPlaying
		JMP stepPlayingLevel
	@notPlaying:
		CMP #GAME_STATE_LEVEL_ENDING
		BEQ @ending
		CMP #GAME_STATE_LEVEL_COMPLETE
		BEQ @complete
		CMP #GAME_STATE_LEVEL_FAILED
		BEQ @failed
		CMP #GAME_STATE_TITLE_SCREEN
		BEQ @titleScreen
		CMP #GAME_STATE_INSTRUCTIONS
		BEQ @instructions
		CMP #GAME_STATE_SETTINGS
		BEQ @settings
		CMP #GAME_STATE_GOOD_LUCK
		BEQ @goodLuck
		CMP #GAME_STATE_GAME_OVER
		BEQ @gameOver
		CMP #GAME_STATE_CONGRATULATIONS
		BEQ @congratulations
		CMP #GAME_STATE_CREDITS
		BEQ @credits
		JMP stepCheat

	@credits:
		JMP stepCredits
	@congratulations:
		JMP stepCongratulations

		;Only update the timebar when playing.
	@ending:
		debug DEBUG_ANIMATIONS
		JSR updateAnimations
		debug DEBUG_MAIN
		JSR updateEntities
		JSR updateEntityInterrupts
		JSR resetHud
		RTS

	@gameOver:
		JMP stepGameOver
	@goodLuck:
		JMP stepGoodLuck

	@settings:
		JMP stepSettings

	@instructions:
		JMP stepInstructions
		
	@titleScreen:
		JMP stepTitleScreen

	@failed:
		JSR startStateTransition
		LDX var::num_lives
		BNE @restartLevel
	
	@noLives:
		JSR startStateTransition
		JSR initGameOver
		JSR endStateTransition
		RTS

	@restartLevel:
		JSR initLevel
		JSR endStateTransition
		RTS

	@complete:
		JSR startStateTransition
		JSR advanceLevel
		LDA var::level_num
		CMP #NUM_LEVELS
		BEQ finishedGame
		JSR initLevel
		JSR endStateTransition
		RTS

stepPlayingLevel:
		LDA var::is_cheating
		BNE @cheating

		JSR checkKeyboard
		debug DEBUG_ANIMATIONS
		JSR updateAnimations
		debug DEBUG_MAIN
		JSR updateEntities
		JSR updateEntityInterrupts
		JSR updateTimebar
		JSR resetHud
		RTS

	@cheating:
		JSR startStateTransition
		LDA #1
		STA var::has_cheated
		LDA var::level_num
		JSR mulABy10
		STA var::finishing_tmp
		LDA #HEARTBAR_Y + ((HUD_SYMBOL_HEIGHT + 1) * (NUM_LEVELS - 1)) 
		SEC
		SBC var::finishing_tmp
		STA var::hud_row
		LDA #HUD_HEART_BROKEN_SYMBOL
		STA var::hud_source_index
		JSR drawHudSymbolLeft
		JSR advanceLevel
		LDA var::level_num
		CMP #NUM_LEVELS
		BEQ finishedGame
		JSR initLevel
		JSR endStateTransition
		RTS

finishedGame:
		JSR startStateTransition
		LDA var::has_cheated
		BNE @hasCheated
		JSR initCongratulations
		JSR endStateTransition
		RTS
	@hasCheated:
		JSR initCheat
		JSR endStateTransition
		RTS

advanceLevel:
		;Start one after the level data
		INC var::level_num
		LDY #NUM_GAME_COLUMNS * NUM_GAME_ROWS - 1
	@barrierLoop:
		INY
		LDA (var::level_data_ptr), Y
		CMP #BARRIER_TERMINATOR
		BCC @barrierLoop
		INY
		TYA
		CLC
		ADC var::num_baddies
		ADC var::level_data_ptr
		STA var::level_data_ptr
		LDA #0
		ADC var::level_data_ptr_hi
		STA var::level_data_ptr_hi
		RTS

checkFirstDyingFrame:
		LDA var::is_dying
		BNE @haveToRemoveLife
		RTS
	@haveToRemoveLife:
		LDA #0
		STA var::is_dying
		;Fall through

loseLife:
		LDX var::num_lives
		DEX
		STX var::num_lives
		BEQ @noLives

		LDA LUT_DEAD_Y - 1, X
		STA var::hud_row
		LDA #HUD_DEAD_SYMBOL + (HUD_DEAD_SYMBOL_OFFSET * 3)
		STA var::hud_source_index

		LDA #0
		STA var::hud_counter
	@rowLoop:
		JSR drawHudRowLeft
		INC var::hud_source_index
		INC var::hud_source_index
		INC var::hud_source_index
		INC var::hud_row

		INC var::hud_counter
		LDA var::hud_counter
		CMP #HUD_DEAD_SYMBOL_COUNT
		BNE @rowLoop

	@noLives:
		RTS

checkKeyboard:
		;If there is a keyboard event which has not yet been processed, nothing to do.
		LDY var::key_event
		BNE @return 

		LDA #%11111111
		STA CIA1_PORT_A

		LDY #0

		;Check either port for an event.
		LDA CIA1_PORT_A
		ORA #%11100000
		LDX #%00000000
		STX CIA1_PORT_A
		AND CIA1_PORT_B
		CMP #$FF
		BEQ @noKeysAreDown

	@someKeyIsDown:
		;Some key is down, so Y goes from 0 to 1.
		INY
		LDA var::key_state
		BNE @notANewEvent
		STY var::key_event

	@noKeysAreDown:
	@notANewEvent:
		STY var::key_state

	@return:
		RTS


handleKeyboardMoving:
		LDA var::key_event
		BEQ @noEvent
		LDA #0
		STA var::key_event
		LDA var::player_state
		AND #%00000010
		BEQ @playerWasDo

		LDA #PLAYER_STATE_TO_DO
		STA var::player_state
		LDA var::colour_do
		STA var::player_colour
		RTS
	@playerWasDo:
		LDA #PLAYER_STATE_TO_DONT
		STA var::player_state
		LDA var::colour_dont
		STA var::player_colour
	@noEvent:
		RTS

updateBaddy:
		LDA var::baddy_state
		BEQ @normal
		JMP updateBaddyTouched

	@normal:
		JMP updateBaddyNormal

updateBaddyNormal:
	;Perform updates
		LDA var::baddy_dir
		AND #%00000010
		ORA var::baddy_axis
		STA var::baddy_dirax

	;Perform updates
		LDX var::baddy_axis
		LDA var::baddy_dir
		ASL
		BCS @backwards

	@forwards:
		LDA var::baddy_x_subpxl, X
		CLC
		ADC var::baddy_speed_subpxl, X
		STA var::baddy_x_subpxl, X
		LDA var::baddy_x_pxl, X
		ADC var::baddy_speed_pxl, X
		STA var::baddy_x_pxl, X
		JMP @noOverflow

	@backwards:
		LDA var::baddy_x_subpxl, X
		SEC
		SBC var::baddy_speed_subpxl, X
		STA var::baddy_x_subpxl, X
		LDA var::baddy_x_pxl, X
		SBC var::baddy_speed_pxl, X
		STA var::baddy_x_pxl, X

		BCS @noOverflow
		LDA #0
		STA var::baddy_x_pxl, X
		STA var::baddy_x_subpxl, X
	@noOverflow:
		LDX #var::baddy_x_pxl
		STX var::entity_0ptr

		JSR entityCoordsToFloorCoords
		JSR getSpriteModFloor
		JSR clampToFloor

		JSR setBaddyFrame

		LDA var::entity_pxl_remainder
		ORA var::baddy_x_subpxl
		ORA var::baddy_y_subpxl
		BEQ @baddyLogic
		RTS

	@baddyLogic:
		LDX var::baddy_axis
		LDA var::floor_x, X
		CMP var::baddy_floor_upper
		BEQ @atUpperLimit
		CMP var::baddy_floor_lower
		BNE @notAtLowerLimit
	@atUpperLimit:
		JSR changeEntityDirection
	@notAtLowerLimit:
	@dontCheckLimits:
		RTS

updateEntities:
		LDX #0
		STX var::player_sprite_index
		LDX #NUM_ENTITY_SPRITES
		STX var::baddy_sprite_index
		LDA var::num_baddies
		BEQ @updatePlayer

		LDA var::player_y_pxl
		CMP var::baddy_y_pxl
		BCS @player_in_front
		LDX #NUM_ENTITY_SPRITES
		STX var::player_sprite_index
		LDA #0
		STA var::baddy_sprite_index

	@player_in_front:
		debug DEBUG_BADDY
		JSR updateBaddy
		JSR drawEntity
		debug DEBUG_MAIN
		JSR collisionDetection

	@updatePlayer:
		debug DEBUG_PLAYER
		JSR updatePlayer
		JSR drawEntity
		debug DEBUG_MAIN
		RTS

collisionDetection:
		SEC
		LDA var::player_y_pxl
		SBC var::baddy_y_pxl
		BCS @noInvert
		EOR #%11111111
		ADC #1
	@noInvert:
		CMP #ENTITY_COLLISION_HEIGHT
		BCS @noCollision

		SEC
		LDA var::player_x_pxl
		SBC var::baddy_x_pxl
		BCS @noInvert2
		EOR #%11111111
		ADC #1
	@noInvert2:
		CMP #ENTITY_COLLISION_WIDTH
		BCS @noCollision

		LDA var::game_state
		CMP #GAME_STATE_PLAYING_LEVEL
		BEQ @collisionIsDeath

		;The level is ending already, so bounce the baddy off the player.
		;But only bounce if not colliding last frame.
		LDA var::were_colliding
		BNE @wereColliding

		LDA #var::baddy_x_pxl
		STA var::entity_0ptr
		JSR changeEntityDirection
		JMP @wereColliding

	@collisionIsDeath:
		LDA #1
		STA var::is_dying
		LDA #PLAYER_STATE_BADDY_TOUCH
		STA var::player_state
		LDA #BADDY_STATE_TOUCHED
		STA var::baddy_state
		LDA #GAME_STATE_LEVEL_ENDING
		STA var::game_state
		LDA #FRAME_BADDY_D_0
		STA var::player_frame
		LDA #PLAYER_BADDY_TOUCH_COLOUR
		STA var::player_colour
		LDA DYING_TOTAL_FRAME_COUNT
		STA var::ending_frame_countdown

	@wereColliding:
		LDA #1
		STA var::were_colliding
		RTS

	@noCollision:
		LDA #0
		STA var::were_colliding
		RTS

updatePlayer:
		LDA var::player_dir
		AND #%00000010
		ORA var::player_axis
		STA var::player_dirax

		LDA var::player_state
		CMP #PLAYER_STATE_START
		BNE @notStart
		JMP updateStartingPlayer

	@notStart:
		CMP #PLAYER_STATE_FINISH
		BNE @notFinished		
		JMP updateFinishingPlayer

	@notFinished:
		CMP #PLAYER_STATE_EXPLODING
		BNE @notExploding
		JMP updateExplodingPlayer

	@notExploding:
		CMP #PLAYER_STATE_BADDY_TOUCH
		BNE @notTouched
		JMP updateTouchedPlayer

	@notTouched:
		CMP #PLAYER_STATE_ELECTRIFIED_DO
		BEQ @electrified
		CMP #PLAYER_STATE_ELECTRIFIED_DONT
		BNE @notElectrified
	@electrified:
		JMP updateElectrifiedPlayer

	@notElectrified:
		JMP updateMovingPlayer
		RTS

staticPlayerUpdate:
		LDA var::static_subpxl
		CLC
		ADC var::player_speed_subpxl
		STA var::static_subpxl
		LDA var::static_pxl
		ADC var::player_speed_pxl
		STA var::static_pxl
		CMP #TILE_HORIZ_INCREMENT * 8
		BCC @noReset
		LDA #0
		STA var::static_subpxl
		STA var::static_pxl
	@noReset:
		RTS

updateWobblingPlayer:
		JSR staticPlayerUpdate
		LDA #0
		STA var::player_z_pxl

		LDA var::static_pxl
		;Divide by 20.
		LSR
		LSR
		JSR divABy5
		;EOR var::player_dir
		;EOR var::player_axis
		AND #%00000001
		STA var::frame_tmp
		LDA var::player_dirax
		ASL
		ORA var::frame_tmp
		STA var::player_frame

		LDX #var::player_x_pxl
		STX var::entity_0ptr
		
		RTS

updateBouncingPlayer:
		JSR staticPlayerUpdate
		LDY var::static_pxl
		LDA LUT_PLAYER_Z_OFFSETS_STARTING, Y
		STA var::player_z_pxl

		LDA var::player_dirax
		JSR mulABy40
		CLC
		ADC var::static_pxl
		LSR
		TAX
		LDA LUT_FRAME_STARTING_BOUNCE, X
		STA var::player_frame

		LDX #var::player_x_pxl
		STX var::entity_0ptr

		RTS

updateStartingPlayer:
		JSR playerSound_preUpdate
		JSR updateBouncingPlayer
		JSR playerSound_postUpdate

		LDA var::key_event
		BEQ @noEvent
		LDA #0
		STA var::key_event
		LDA #PLAYER_STATE_TO_DO
		STA var::player_state
		LDA var::colour_do
		STA var::player_colour
	@noEvent:
		RTS

updateFinishingPlayer:
		JSR playerSound_preUpdate
		JSR staticPlayerUpdate
		LDY var::static_pxl
		LDA LUT_PLAYER_Z_OFFSETS_STARTING, Y
		STA var::player_z_pxl

		JSR playerSound_postUpdate

		LDX var::finishing_rotation_index
		LDA LUT_FINISH_ROTATION_INDEX, X
		JSR mulABy40
		CLC
		ADC var::static_pxl
		LSR

		TAX
		LDA LUT_FRAME_STARTING_BOUNCE, X
		STA var::player_frame

		LDA var::static_pxl
		AND #%00000111
		BNE @noRotate
		INC var::finishing_rotation_index
		LDA var::finishing_rotation_index
		CMP #6
		BNE @noReset
		LDA #0
		STA var::finishing_rotation_index
	@noRotate:
	@noReset:

		LDX #var::player_x_pxl
		STX var::entity_0ptr

		JSR entityCoordsToFloorCoords
		JSR getSpriteModFloor
		
		;Draw heart slowly.

		DEC var::ending_frame_countdown
		LDA var::ending_frame_countdown
		AND #%00000111
		BNE @noHeartRow

		DEC var::finishing_heart_index
		BNE @keepGoing
		INC var::finishing_heart_index

	@keepGoing:
		LDA var::level_num
		JSR mulABy10
		STA var::finishing_tmp
		LDA #HEARTBAR_Y + ((HUD_SYMBOL_HEIGHT + 1) * (NUM_LEVELS - 1)) 
		SEC
		SBC var::finishing_tmp
		CLC
		ADC var::finishing_heart_index
		STA var::hud_row
		LDA var::finishing_heart_index
		JSR mulABy3
		CLC
		ADC #HUD_HEART_FULL_SYMBOL
		STA var::hud_source_index
		JSR drawHudRowLeft

	@noHeartRow:
		LDA var::ending_frame_countdown
		BNE @continueFinishing

		LDA #GAME_STATE_LEVEL_COMPLETE
		STA var::game_state

	@continueFinishing:
		RTS


updateExplodingPlayer:
		JSR checkFirstDyingFrame

		;Fix a bug when a baddy passes the y of an exploded player
		LDA var::num_baddies
		BEQ @noBaddies
		LDX var::baddy_sprite_index
		LDA var::sprite_enable
		ORA LUT_BADDY_BITS, X
		STA var::sprite_enable
	@noBaddies:

		LDX #var::player_x_pxl
		STX var::entity_0ptr

		DEC var::ending_frame_countdown
		BNE @notFinished

		LDA #GAME_STATE_LEVEL_FAILED
		STA var::game_state
		RTS

	@notFinished:
		DEC var::exploding_transition_countdown
		BNE @justDraw

		LDA EXPLODING_TRANSITION_FRAME_COUNT
		STA var::exploding_transition_countdown

		LDA var::player_frame
		CMP #FRAME_EXPLODING_3
		BNE @notVanished

		JSR hideSprite
		RTS

	@notVanished:
		CMP #FRAME_EXPLODING_1
		BCS @notFrame0
		LDA #FRAME_EXPLODING_1 - 1
		STA var::player_frame

		LDA #SMOKE_COLOUR
		STA var::player_colour

		;Disable the face sprite.
		LDY var::entity_0ptr
		LDX ENTITY_SPRITE_INDEX, Y
		LDA var::sprite_enable
		AND LUT_MASK, X
		STA var::sprite_enable

	@notFrame0:
		INC var::player_frame
	@justDraw:
	@return:
		RTS

hideSprite:
		LDY var::entity_0ptr
		LDX ENTITY_SPRITE_INDEX, Y
		
		LDA var::sprite_enable
		AND LUT_MASK, X
		INX
		AND LUT_MASK, X
		INX
		AND LUT_MASK, X
		STA var::sprite_enable
		RTS

updateTouchedPlayer:
		JSR checkFirstDyingFrame
		LDA var::player_z_pxl
		STA var::old_player_z_pxl

		LDA var::static_pxl
		CLC
		ADC #20
		CMP #40
		BCC @justStore
		SEC
		SBC #40
	@justStore:
		PHA
		TAY
		LDA LUT_PLAYER_Z_OFFSETS_STARTING, Y
		STA var::player_z_pxl

		LDA var::old_player_z_pxl
		BEQ @noSound
		LDA var::player_z_pxl
		BEQ @sound
		LDA var::old_baddy_z_pxl
		BEQ @noSound
		LDA var::baddy_z_pxl
		BNE @noSound

	@sound:
		INC var::old_sound
		LDA var::old_sound
		AND #3
		TAX
		BEQ @laugh0
		DEX
		BEQ @laugh1
		DEX
		BEQ @laugh2
	@laugh3:
		playSfx laugh3Sound
		JMP @common

	@laugh2:
		playSfx laugh2Sound
		JMP @common

	@laugh1:
		playSfx laugh1Sound
		JMP @common

	@laugh0:
		playSfx laugh0Sound
	@noSound:
	@common:

		LDX #var::player_x_pxl
		STX var::entity_0ptr

		PLA
		JSR divABy10
		AND #%00000001
		CLC
		ADC #FRAME_BADDY_D_0
		STA var::player_frame
			
		DEC var::ending_frame_countdown
		BNE @stillAnimating
		
		LDA #GAME_STATE_LEVEL_FAILED
		STA var::game_state

	@stillAnimating:
		RTS

updateBaddyTouched:
		LDA var::baddy_z_pxl
		STA var::old_baddy_z_pxl
		JSR staticPlayerUpdate
		LDA var::static_pxl
		TAY
		LDA LUT_PLAYER_Z_OFFSETS_STARTING, Y
		STA var::baddy_z_pxl

		LDX #var::baddy_x_pxl
		STX var::entity_0ptr

		LDA var::static_pxl
		JSR divABy10
		AND #%00000001
		CLC
		ADC #FRAME_BADDY_D_0
		STA var::baddy_frame
			
		RTS

updateElectrifiedPlayer:
		JSR checkFirstDyingFrame
		LDX #var::player_x_pxl
		STX var::entity_0ptr

		DEC var::ending_frame_countdown
		BNE @stillBeingElectrocuted
		LDA #GAME_STATE_LEVEL_FAILED
		STA var::game_state

	@stillBeingElectrocuted:
		;Access local code memory to generate a randomish index into a colour table.
		;Also use the low bit of the state to pick between do and dont colours.
		LDA var::ending_frame_countdown
		LSR
		TAX
		LDA var::player_state
		LSR
		LDA *, X
		ROL
		AND #%00001111
		TAY
		LDX LUT_ELECTRIFICATION_COLOURS, Y
		LDA var::colour_table, X
		STA var::player_colour
		CMP var::colours_player_white
		BNE @noSound
		playSfx electrocutionSound
	@noSound:
		RTS

updateMovingPlayer:
		JSR playerSound_preUpdate
		JSR handleKeyboardMoving

	;Perform updates
		LDX var::player_axis
		LDA var::player_dir
		ASL
		BCS @backwards

	@forwards:
		LDA var::player_x_subpxl, X
		CLC
		ADC var::player_speed_subpxl, X
		STA var::player_x_subpxl, X
		LDA var::player_x_pxl, X
		ADC var::player_speed_pxl, X
		STA var::player_x_pxl, X
		JMP @noOverflow

	@backwards:
		LDA var::player_x_subpxl, X
		SEC
		SBC var::player_speed_subpxl, X
		STA var::player_x_subpxl, X
		LDA var::player_x_pxl, X
		SBC var::player_speed_pxl, X
		STA var::player_x_pxl, X

		BCS @noOverflow
		LDA #0
		STA var::player_x_pxl, X
		STA var::player_x_subpxl, X
	@noOverflow:

		LDX #var::player_x_pxl
		STX var::entity_0ptr

		JSR entityCoordsToFloorCoords
		JSR getSpriteModFloor
		JSR clampToFloor

		JSR playerBounce
		JSR setPlayerFrame
		JSR playerSound_postUpdate

		LDA var::entity_pxl_remainder
		ORA var::player_x_subpxl
		ORA var::player_y_subpxl
		BEQ @playerLogic
		RTS

	@playerLogic:
		;Ensure the screen pointers are set
		JSR floorToScreenAndLevelCoords
		JSR screenCoordsToScreenPtrs

		JSR getFloorData
		LDA var::floor_tile

		AND #%00001100
		BNE @notCorner
		;playSfx wallBounceSound
		JSR changeEntityAxis
		LDA var::floor_data
		AND #%00000010
		BEQ @handleWalls
		JSR changeEntityDirection
	@notCorner:

		LDA var::player_state
		AND #%00000010
		BNE @handleWalls

		;Handle rotors
		LDA var::floor_data
		AND #%00001010
		BNE @notRotor
		playSfx rotorSound
		JSR changeEntityAxis
		LDA var::floor_data
		AND #%00000001
		EOR var::player_axis
		BEQ @handleWalls
		JSR changeEntityDirection
	@notRotor:

		;Handle keys
		LDA var::floor_tile
		CMP #TILE_KEY
		BNE @notKey
		
		JSR handleKey
		JMP @handleWalls
	@notKey:

		CMP #TILE_SWITCH
		BNE @notSwitch

		LDA var::switch_state
		EOR #%00000001
		STA var::switch_state

		JSR swapBarriers

	@notSwitch:
		CMP #TILE_TELEPORT
		BNE @notTeleport
		JSR handleTeleport
	
	@notTeleport:
		CMP #TILE_HEART
		BNE @notHeart
		JSR handleHeart
		RTS
	@notHeart:
	
	@handleWalls:
		LDA var::player_dir
		AND #%00000010
		ORA var::player_axis
		STA var::player_dirax

		LDX var::player_dirax
		LDY LUT_WALL_PROBES, X
		LDA (var::colour_ptr), Y
		AND #%00001111
		STA var::probed_colour
		
		CMP #LOCK_TOP_COLOUR
		BNE @notDoor
	@door:
		;See if we can unlock the door
		LDA var::num_keys
		BEQ @wallBounce
		JSR removeDoor
		LDX var::num_keys
		DEX
		STX var::num_keys
		LDA #NO_KEY_COLOUR
		STA var::key_colour_0, X
		RTS

	@notDoor:
		LDX var::player_dirax
		LDY LUT_WALL_PROBES, X
		LDA (var::screen_ptr), Y
		AND #%00111111

		CMP #CHR_BLOCK
		BNE @notBlock
		
		LDA var::probed_colour
		CMP var::colour_wall_top
		BEQ @wallBounce
		RTS
		
	@notBlock:
		CMP #CHR_BARRIER_ELECTRIFIED
		BNE @notElectrified
		JSR handleElectrifiedBarrier
		RTS

	@notElectrified:
		CMP #CHR_BARRIER_CLOSED
		BEQ @wallBounce

	@notBarrier:
		SEC
		SBC #CHR_FIRST_SPIKE
		CMP #4
		BCS @notSpike
		;Handle spikes
		CMP var::player_dirax
		BNE @wallBounce

		JSR handleSpikes
		RTS
	
	@wallBounce:
		JSR changeEntityDirection

		;playSfx wallBounceSound
	@notSpike:
		RTS

handleElectrifiedBarrier:
		LDA #1
		STA var::is_dying

		LDA var::player_frame
		CLC
		ADC #FRAME_ELECTRIFIED_OFFSET - FRAME_PLAYER_OFFSET
		STA var::player_frame

		LDA var::player_state
		LSR
		CLC
		ADC #PLAYER_STATE_ELECTRIFIED_DO
		STA var::player_state
		LDA #GAME_STATE_LEVEL_ENDING
		STA var::game_state
		LDA DYING_TOTAL_FRAME_COUNT
		STA var::ending_frame_countdown
		LDA #VIC_II_COLOUR_LIGHT_GREEN
		STA var::player_colour
		RTS

handleSpikes:
handleTimeout:
		playSfx spikeDeathSound
		LDA #1
		STA var::is_dying
		LDA #PLAYER_STATE_EXPLODING
		STA var::player_state
		LDA #GAME_STATE_LEVEL_ENDING
		STA var::game_state
		LDA EXPLODING_TRANSITION_FRAME_COUNT
		STA var::exploding_transition_countdown
		LDA DYING_TOTAL_FRAME_COUNT
		STA var::ending_frame_countdown
		LDA #0
		LDA var::player_dirax
		CLC
		ADC #FRAME_EXPLODING_0_R
		STA var::player_frame
		RTS

handleKey:
		LDY #KEY_PROBE
		LDA (var::colour_ptr), Y
		AND #%00001111
		CMP #KEY_COLOUR
		BNE @return

		playSfx takeKeySound

		LDY #KEY_PROBE
		LDA #FLOOR_COLOUR
		STA (var::colour_ptr), Y
		INY
		STA (var::colour_ptr), Y
		
		LDX var::num_keys
		LDA #KEY_COLOUR
		STA var::key_colour_0, X
		INX
		STX var::num_keys
	@return:
		RTS

handleTeleport:
		playSfx teleportSound
		LDA var::teleport_0_x
		CMP var::floor_x
		BNE @atTeleport1

		LDA var::teleport_0_y
		CMP var::floor_y
		BNE @atTeleport1
	@atTeleport0:
		LDX var::teleport_1_x
		LDY var::teleport_1_y
		JMP @teleportCommon

	@atTeleport1:
		LDX var::teleport_0_x
		LDY var::teleport_0_y

	@teleportCommon:
		STX var::floor_x
		STY var::floor_y

		LDX #var::player_x_pxl
		STX var::entity_0ptr
		JSR floorCoordsToEntityCoords
		JSR floorToScreenAndLevelCoords
		JSR screenCoordsToScreenPtrs
		RTS

handleHeart:
		playSfx completionSound
		LDA #PLAYER_STATE_FINISH
		STA var::player_state
		LDA #HUD_SYMBOL_HEIGHT - 1
		STA var::finishing_heart_index
		LDA FINISHING_TOTAL_FRAME_COUNT
		STA var::ending_frame_countdown
		LDA #GAME_STATE_LEVEL_ENDING
		STA var::game_state
		LDX var::player_dirax
		LDA LUT_FINISH_ROTATION_INDEX, X
		STA var::finishing_rotation_index
		RTS

swapBarriers:
		playSfx switchSound
		LDA var::switch_state
		BNE @program_1
	@program_0:
		JSR var::barrier_program_char_0
		JSR var::barrier_program_colour_0
		RTS
	@program_1:
		JSR var::barrier_program_char_1
		JSR var::barrier_program_colour_1
		RTS

resetSwitchTables:
		LDX #(SIZE_OF_SWITCH_TABLE * 2)
		LDA #0
	@loop:
		STA var::switch_colour_ptr - 1, X
		DEX
		BNE @loop
		RTS

resetBarrierTable:
		LDX #(SIZE_OF_BARRIER_TABLE / 5)
		LDY #0
	@loop:
		LDA #OPCODE_LDA_IMMEDIATE
		STA (var::barrier_program_ptr), Y
		STA (var::barrier_program_ptr2), Y
		LDA #OPCODE_STA_ABSOLUTE
		INY
		INY
		STA (var::barrier_program_ptr), Y
		STA (var::barrier_program_ptr2), Y
		INY
		INY
		INY

		DEX
		BNE @loop
		RTS

buildBarrierPrograms:
	;Reset the program memory so LDAs and STAs are in the right place.
		;Swap the draw callbacks for the capture versions
		LDA #.LOBYTE(barrierDrawCallback_captureChar)
		STA drawCharIndirection + 1
		LDA #.HIBYTE(barrierDrawCallback_captureChar)
		STA drawCharIndirection + 2

		LDA #.LOBYTE(var::barrier_program_char_0)
		STA var::barrier_program_ptr
		LDA #.HIBYTE(var::barrier_program_char_0)
		STA var::barrier_program_ptr_hi
		LDA #.LOBYTE(var::barrier_program_colour_0)
		STA var::barrier_program_ptr2
		LDA #.HIBYTE(var::barrier_program_colour_0)
		STA var::barrier_program_ptr2_hi

		JSR resetBarrierTable

		LDA #0
		STA var::switch_state
		JSR drawBarriers

		LDY #0
		LDA #OPCODE_RTS
		STA (var::barrier_program_ptr), Y
		STA (var::barrier_program_ptr2), Y

		LDA #.LOBYTE(var::barrier_program_char_1)
		STA var::barrier_program_ptr
		LDA #.HIBYTE(var::barrier_program_char_1)
		STA var::barrier_program_ptr_hi
		LDA #.LOBYTE(var::barrier_program_colour_1)
		STA var::barrier_program_ptr2
		LDA #.HIBYTE(var::barrier_program_colour_1)
		STA var::barrier_program_ptr2_hi

		JSR resetBarrierTable

		LDA #1
		STA var::switch_state
		JSR drawBarriers

		LDY #0
		LDA #OPCODE_RTS
		STA (var::barrier_program_ptr), Y
		STA (var::barrier_program_ptr2), Y

		;Swap the draw callbacks back
		LDA #.LOBYTE(barrierDrawCallback_drawChar)
		STA drawCharIndirection + 1
		LDA #.HIBYTE(barrierDrawCallback_drawChar)
		STA drawCharIndirection + 2

		LDA #0
		STA var::switch_state
		JSR drawBarriers

		;Optimize the barrier colour table, by removing entries where the
		;colours do not change.
		LDX #0 ;Source
		LDY #0 ;Target
	@compressLoop:
		LDA var::barrier_program_colour_0, X
		CMP #OPCODE_RTS
		BEQ @finished
		LDA var::barrier_program_colour_0 + 1, X
		CMP var::barrier_program_colour_1 + 1, X
		BEQ @skip
		LDA var::barrier_program_colour_0 + 1, X
		STA var::barrier_program_colour_0 + 1, Y
		LDA var::barrier_program_colour_0 + 3, X
		STA var::barrier_program_colour_0 + 3, Y
		LDA var::barrier_program_colour_0 + 4, X
		STA var::barrier_program_colour_0 + 4, Y
		LDA var::barrier_program_colour_1 + 1, X
		STA var::barrier_program_colour_1 + 1, Y
		LDA var::barrier_program_colour_1 + 3, X
		STA var::barrier_program_colour_1 + 3, Y
		LDA var::barrier_program_colour_1 + 4, X
		STA var::barrier_program_colour_1 + 4, Y
		INY
		INY
		INY
		INY
		INY
	@skip:
		INX
		INX
		INX
		INX
		INX
		JMP @compressLoop
	@finished:

		;Transfer switch info to barrier_colour table
		LDX #0
		;Y is the current index in the barrier colour table
	@switchLoop:
		LDA var::switch_colour_ptr_hi, X
		BEQ @finishedSwitches
		
		LDA #OPCODE_LDA_IMMEDIATE
		STA var::barrier_program_colour_0, Y
		STA var::barrier_program_colour_1, Y

		LDA #LEVER_COLOUR
		STA var::barrier_program_colour_0 + 1, Y
		LDA #FLOOR_COLOUR
		STA var::barrier_program_colour_1 + 1, Y

		LDA var::switch_colour_ptr, X
		CLC
		ADC #(SCREEN_WIDTH * 2) + 2
		STA var::barrier_program_colour_0 + 3, Y
		STA var::barrier_program_colour_1 + 3, Y
		LDA var::switch_colour_ptr_hi, X
		ADC #0
		STA var::barrier_program_colour_0 + 4, Y
		STA var::barrier_program_colour_1 + 4, Y

		INY
		INY
		INY
		INY
		INY

		LDA #OPCODE_LDA_IMMEDIATE
		STA var::barrier_program_colour_0, Y
		STA var::barrier_program_colour_1, Y

		LDA #FLOOR_COLOUR
		STA var::barrier_program_colour_0 + 1, Y
		LDA #LEVER_COLOUR
		STA var::barrier_program_colour_1 + 1, Y

		LDA var::switch_colour_ptr, X
		CLC
		ADC #(SCREEN_WIDTH * 2) + 3
		STA var::barrier_program_colour_0 + 3, Y
		STA var::barrier_program_colour_1 + 3, Y
		LDA var::switch_colour_ptr_hi, X
		ADC #0
		STA var::barrier_program_colour_0 + 4, Y
		STA var::barrier_program_colour_1 + 4, Y
		
		INX
		INY
		INY
		INY
		INY
		INY
		JMP @switchLoop

	@finishedSwitches:
		;Ensure the barrier table has a 0
		LDA #OPCODE_RTS
		STA var::barrier_program_colour_0, Y
		STA var::barrier_program_colour_1, Y

		RTS

		RTS


drawBarriers:
		;Start one after the level data
		LDY #NUM_GAME_COLUMNS * NUM_GAME_ROWS - 1
		STY var::barrier_index

	@barrierLoop:
		INC var::barrier_index
		LDY var::barrier_index
		LDA (var::level_data_ptr), Y
		STA var::barrier_data

		;Finish if a door or terminator.
		CMP #BARRIER_TERMINATOR
		BCS @noBarrier

		TAX
		AND #%00000011
		CMP #BARRIER_DOOR
		BEQ @noBarrier

		CLC
		ADC var::switch_state
		TAY
		LDA LUT_BARRIER_SWITCH, Y
		STA var::barrier_tmp

		TXA
		AND #%11111100
		ORA var::barrier_tmp
		STA var::barrier_data

		JSR getBarrierData
		JSR floorToScreenAndLevelCoords
		JSR screenCoordsToScreenPtrs

		JSR drawWall
		JMP @barrierLoop

	@noBarrier:
		RTS

barrierDrawCallback_captureChar:
		PHP
		PHA
		TXA
		PHA
		TYA
		PHA

		TYA
		TAX

		CLC
		ADC var::screen_ptr
		LDY #3
		STA (var::barrier_program_ptr), Y
		STA (var::barrier_program_ptr2), Y
		LDA #0
		ADC var::screen_ptr_hi
		LDY #4
		STA (var::barrier_program_ptr), Y

		TXA
		CLC
		ADC var::colour_ptr
		LDA #0
		ADC var::colour_ptr_hi
		LDY #4
		STA (var::barrier_program_ptr2), Y

		LDA var::char_to_draw
		LDY #1
		STA (var::barrier_program_ptr), Y
		LDA var::colour_to_draw
		STA (var::barrier_program_ptr2), Y
	
		;Bump the barrier_ptr by 5.
		LDA var::barrier_program_ptr
		CLC
		ADC #5
		STA var::barrier_program_ptr
		LDA #0
		ADC var::barrier_program_ptr_hi
		STA var::barrier_program_ptr_hi

		;Bump the barrier_ptr2 by 5.
		LDA var::barrier_program_ptr2
		CLC
		ADC #5
		STA var::barrier_program_ptr2
		LDA #0
		ADC var::barrier_program_ptr2_hi
		STA var::barrier_program_ptr2_hi

		PLA
		TAY
		PLA
		TAX
		PLA
		PLP
		RTS

drawCharIndirection:
		JMP barrierDrawCallback_drawChar

barrierDrawCallback_drawChar:
		LDA var::char_to_draw
		STA (var::screen_ptr), Y
		LDA var::colour_to_draw
		STA (var::colour_ptr), Y
		RTS

removeDoor:
		playSfx openDoorSound
		LDA var::player_axis
		STA var::wall_axis
		
		LDA var::player_dir
		CMP #DIR_FORWARD
		BNE @drawWall
		LDX var::player_axis
		CLC
		LDA var::screen_ptr
		ADC LUT_DOOR_ADJUST, X
		STA var::screen_ptr
		LDA var::screen_ptr_hi
		ADC #0
		STA var::screen_ptr_hi
		;CLC
		LDA var::colour_ptr
		ADC LUT_DOOR_ADJUST, X
		STA var::colour_ptr
		LDA var::colour_ptr_hi
		ADC #0
		STA var::colour_ptr_hi

		INC var::floor_x, X
	@drawWall:
		LDA #0
		STA var::wall_type
		JSR drawWall

		;Hack
		LDA var::text_settings_colours
		BEQ @notAltColours
		LDY #SCREEN_WIDTH
		LDA (var::colour_ptr), Y
		AND #%00001111
		CMP #WALL_EDGE_COLOUR
		BNE @notWallEdge
		LDA #ALT_WALL_EDGE_COLOUR
		STA (var::colour_ptr), Y
	@notWallEdge:
	@notAltColours:
		RTS

;;drawTileBottomIfHWall:
;		LDA var::wall_axis
;		BEQ @return
;
;		;Draw the lowest row of the tile above.
;		DEC var::floor_y
;		JSR getFloorData
;		JSR floorTileToTileDataIndex
;
;		LDA var::tiledata_index
;		CLC
;		ADC #(TILE_WIDTH * (TILE_HEIGHT - 1))
;		STA var::tiledata_index
;
;		LDY #1
;		STY var::screen_offset
;	
;		JSR drawTileCharAndAdvance
;		JSR drawTileCharAndAdvance
;		JSR drawTileCharAndAdvance
;		JSR drawTileCharAndAdvance
;
;	@return
;		RTS

drawWall:
		LDA var::wall_axis
		BNE @horizontal

		JSR wallTypeToVWallOffset
		JSR drawVWall
		RTS

	@horizontal:
		;Draw the lowest row of the tile above.
		DEC var::floor_y
		JSR getFloorData
		JSR floorTileToTileDataIndex

		LDA var::tiledata_index
		CLC
		ADC #(TILE_WIDTH * (TILE_HEIGHT - 1))
		STA var::tiledata_index

		LDY #1
		STY var::screen_offset
	
		JSR drawTileCharAndAdvance
		JSR drawTileCharAndAdvance
		JSR drawTileCharAndAdvance
		JSR drawTileCharAndAdvance

		;No hwall override needed for barriers.
		JSR wallTypeToHWallOffset
		JSR drawHWallTop
		JSR drawHWallEdge
		RTS

drawEntity:
		;Draw player in new position.
		LDA #FACE_COLOUR
		STA var::sprite_colour

		LDX var::entity_0ptr
		LDA ENTITY_SPRITE_INDEX, X
		STA var::sprite_index
		LDA ENTITY_SPRITE_FRAME, X
		JSR mulABy6
		TAY

		LDA FRAME_SOURCE, Y
		STA var::frame_sprite_index
		INY
		LDA FRAME_SOURCE, Y
		STA var::frame_x_pxl
		INY
		LDA FRAME_SOURCE, Y
		STA var::frame_y_pxl
		JSR setSpriteRegisters
		
		LDX var::entity_0ptr
		LDA ENTITY_COLOUR, X
		STA var::sprite_colour

		INC var::sprite_index
		INY
		LDA FRAME_SOURCE, Y
		STA var::frame_sprite_index
		INY
		LDA FRAME_SOURCE, Y
		STA var::frame_x_pxl
		INY
		LDA FRAME_SOURCE, Y
		STA var::frame_y_pxl
		JSR setSpriteRegisters
	
		INC var::sprite_index
		INC var::frame_sprite_index
		INC var::frame_sprite_index
		INC var::frame_sprite_index
		LDA var::frame_x_pxl
		CLC
		ADC #24
		STA var::frame_x_pxl
		JSR setSpriteRegisters

		RTS

updateEntityInterrupts:
		debug DEBUG_ENTITY_INTERRUPTS
		LDA #var::player_x_pxl
		STA var::entity_0ptr
		JSR findEntityInterruptCounters

		LDA #var::baddy_x_pxl
		STA var::entity_0ptr

		LDA var::num_baddies
		BEQ @noBaddies

		JSR findEntityInterruptCounters
		RTS

	@noBaddies:
		LDA #100
		JSR setEntityInterruptCounters

		RTS
		
findEntityInterruptCounters:
		LDX var::entity_0ptr
		LDY ENTITY_SPRITE_INDEX, X
		TYA
		ASL
		TAY
		LDX VIC_II_SPRITE_1_Y, Y
		LDA LUT_INTERRUPT_RASTER_TABLE, X

setEntityInterruptCounters:
		LDX var::entity_0ptr
		LDY ENTITY_SPRITE_INDEX, X
		STA var::sprite_1_interrupt_counter_0, Y
		CLC
		ADC #2
		STA var::sprite_1_interrupt_counter_1, Y
		RTS

changeEntityAxis:
		LDX var::entity_0ptr
		LDA #1
		EOR ENTITY_AXIS, X
		STA ENTITY_AXIS, X
		RTS

changeEntityDirection:
		LDX var::entity_0ptr
		LDA #$FE
		EOR ENTITY_DIR, X
		STA ENTITY_DIR, X
		RTS

floorCoordsToEntityCoords:
	;Given floor_x and floor_y, set the sprite_x and _y
		LDX var::entity_0ptr
		LDA var::floor_x
		JSR mulABy5
		ASL
		ASL
		ASL
		STA ENTITY_X_PXL, X
		LDA var::floor_y
		ASL
		ASL
		ASL
		ASL
		ASL
		STA ENTITY_Y_PXL, X
		RTS

entityCoordsToFloorCoords:
	;Given sprite coords, find the floor position.
		LDX var::entity_0ptr
		LDA ENTITY_X_PXL, X
		LSR
		LSR
		LSR
		JSR divABy5
		STA var::floor_x
		;Div Y by 32
		LDX var::entity_0ptr
		LDA ENTITY_Y_PXL, X
		LSR
		LSR
		LSR
		LSR
		LSR
		STA var::floor_y
		RTS

getSpriteModFloor:
		LDX var::entity_0ptr

		LDA ENTITY_AXIS, X
		BEQ @horizontal
	@vertical:
		LDA var::floor_y
		ASL
		ASL
		ASL
		ASL
		ASL
		STA var::entity_pxl_clamped
		SEC
		LDA ENTITY_Y_PXL, X

		JMP @after

	@horizontal:
		LDA var::floor_x
		JSR mulABy5
		ASL
		ASL
		ASL
		STA var::entity_pxl_clamped
		SEC
		LDA ENTITY_X_PXL, X

	@after:
		SBC var::entity_pxl_clamped
		STA var::entity_pxl_remainder
		RTS

clampToFloor:
		LDX var::entity_0ptr

		LDA ENTITY_AXIS, X
		BNE clampVertical

clampHorizontal:
	;If the entity is within half-a-speed of a frame, clamp it.
		LDA ENTITY_HORIZ_SPEED_PXL, X
		LSR
		STA var::half_speed_pxl
		LDA ENTITY_HORIZ_SPEED_SUBPXL, X
		ROR
		STA var::half_speed_subpxl
		
		LDA var::entity_pxl_remainder
		CMP var::half_speed_pxl
		BCC @startClamp
		BNE @noStartClamp

		LDA ENTITY_X_SUBPXL, X
		CMP var::half_speed_subpxl
		BCS @noClamp

	@startClamp:
		LDA var::entity_pxl_clamped
		STA ENTITY_X_PXL, X
		LDA #0
		STA var::entity_pxl_remainder
		STA ENTITY_X_SUBPXL, X
		RTS
	
	@noStartClamp:
		SEC
		LDA #0
		SBC var::half_speed_subpxl
		TAY
		LDA #(TILE_HORIZ_INCREMENT * 8)
		SBC var::half_speed_pxl

		CMP var::entity_pxl_remainder
		BCC @endClamp
		BNE @noClamp

		TYA
		CMP ENTITY_X_SUBPXL, X
		BCS @noClamp

	@endClamp:
		INC var::floor_x
		CLC
		LDA var::entity_pxl_clamped
		ADC #(TILE_HORIZ_INCREMENT * 8)
		STA ENTITY_X_PXL, X
		LDA #0
		STA var::entity_pxl_remainder
		STA ENTITY_X_SUBPXL, X

	@noClamp:
		RTS

clampVertical:
	;If the entity is within half-a-speed of a frame, clamp it.
		LDA ENTITY_VERT_SPEED_PXL, X
		LSR
		STA var::half_speed_pxl
		LDA ENTITY_VERT_SPEED_SUBPXL, X
		ROR
		STA var::half_speed_subpxl
		
		LDA var::entity_pxl_remainder
		CMP var::half_speed_pxl
		BCC @startClamp
		BNE @noStartClamp

		LDA ENTITY_Y_SUBPXL, X
		CMP var::half_speed_subpxl
		BCS @noClamp

	@startClamp:
		LDA var::entity_pxl_clamped
		STA ENTITY_Y_PXL, X
		LDA #0
		STA var::entity_pxl_remainder
		STA ENTITY_Y_SUBPXL, X
		RTS
	
	@noStartClamp:
		SEC
		LDA #0
		SBC var::half_speed_subpxl
		TAY
		LDA #(TILE_VERT_INCREMENT * 8)
		SBC var::half_speed_pxl

		CMP var::entity_pxl_remainder
		BCC @endClamp
		BNE @noClamp

		TYA
		CMP ENTITY_Y_SUBPXL, X
		BCS @noClamp

	@endClamp:
		INC var::floor_y
		CLC
		LDA var::entity_pxl_clamped
		ADC #(TILE_VERT_INCREMENT * 8)
		STA ENTITY_Y_PXL, X
		LDA #0
		STA var::entity_pxl_remainder
		STA ENTITY_Y_SUBPXL, X

	@noClamp:
		RTS

playerBounce:
		LDA #0
		LDX var::player_state
		CPX #PLAYER_STATE_DO
		BEQ @setBounce
		;Set Z
	@Bouncing:
		LDA var::player_axis	
		BNE @vert 
		LDX var::entity_pxl_remainder
		LDA LUT_PLAYER_Z_OFFSETS_HORIZONTAL,X
		JMP @setBounce
	@vert:
		LDX var::entity_pxl_remainder
		LDA LUT_PLAYER_Z_OFFSETS_VERTICAL,X
	@setBounce:
		STA var::bounce_pxl

		;Skip straight to setZ for DO and DONT states.
		LDA var::player_state
		LSR
		BCS @setZ

		;Set the average.
		LDA var::player_z_pxl
		CLC
		ADC var::bounce_pxl
		LSR
		STA var::bounce_pxl
		CMP var::player_z_pxl
		BNE @setZ

		;We've reached the target state.
		LDX var::player_state
		INX
		TXA
		AND #%00000011
		STA var::player_state

	@setZ:
		LDA var::bounce_pxl
		STA var::player_z_pxl

		RTS

playerSound_preUpdate:
		LDA var::player_z_pxl
		STA var::old_player_z_pxl
		LDA var::player_frame
		STA var::old_player_frame
		RTS

playerSound_postUpdate:
		LDA var::player_state
		CMP #PLAYER_STATE_DO
		BEQ @do
		CMP #PLAYER_STATE_TO_DO
		BEQ @do

	@dont:
		LDA var::old_player_z_pxl
		BEQ @noSound
		LDA var::player_z_pxl
		BNE @noSound
		playSfx playerBounceSound
	@noSound:
		RTS

	@do:
		LDA var::old_player_frame
		CMP var::player_frame
		BEQ @return
		LDX var::player_frame
		LDA LUT_WOBBLE_FROM_FRAME, X
		BEQ @wobble1
		playSfx wobble0Sound
		RTS
	@wobble1:
		playSfx wobble1Sound
	@afterSound:
	@return:
		RTS		

setPlayerFrame:
		LDA var::player_state
		AND #%00000010
		BNE @dont
		
	@do:
		LDA var::player_axis	
		BNE @vert 
		LDA var::entity_pxl_remainder
		;Divide by 20.
		LSR
		LSR
		JSR divABy5
		JMP @setBounce
	@vert:
		LDA var::entity_pxl_remainder
		;Divide by 16
		LSR
		LSR
		LSR
		LSR
	@setBounce:
		EOR var::player_dir
		EOR var::player_axis
		AND #%00000001
		STA var::frame_tmp
		LDA var::player_dirax
		ASL
		ORA var::frame_tmp
		STA var::player_frame
		RTS

	@dont:
		LDX var::player_axis
		LDA var::entity_pxl_remainder
		LSR
		ASL
		ASL
		ORA var::player_dirax
		TAX
		LDA LUT_FRAME_BOUNCE, X
		STA var::player_frame
		RTS

setBaddyFrame:
		LDA var::entity_pxl_remainder
		;Divide by 16
		EOR var::baddy_dir
		AND #%00000100
		LSR
		LSR
	@setBounce:
		CLC
		ADC #FRAME_BADDY_D_0
		STA var::baddy_frame
		RTS

setSpriteRegisters:
	;Assume player_sprite_x, player_sprite_y and player_sprite_index is set.
		; Set sprite graphic
		LDX var::sprite_index
		LDA var::frame_sprite_index
		STA SPRITE_0_INDEX, X
		STA TEXT_SPRITE_0_INDEX, X

		LDA var::sprite_colour
		STA VIC_II_SPRITE_0_COLOUR, X

		; Push X coord
		CLC
		LDX var::entity_0ptr
		LDA ENTITY_X_PXL, X
		ADC var::frame_x_pxl
		ADC #SPRITE_X_LEVEL_OFFSET
		LDX var::sprite_index
		PHA
		LDA #0
		BCC @noCarry
		LDA LUT_BIT, X
	@noCarry:
		STA var::overflow
		LDA VIC_II_SPRITES_X_BIT7
		AND LUT_MASK, X
		ORA var::overflow
		STA VIC_II_SPRITES_X_BIT7

		; Push Y coord.
		CLC
		LDX var::entity_0ptr
		LDA ENTITY_Y_PXL, X
		; Add Z
		SEC
		SBC ENTITY_Z_PXL, X
		CLC
		ADC var::frame_y_pxl
		ADC #SPRITE_Y_LEVEL_OFFSET - SPRITE_Y_ADJUST
		PHA

		; Double X and set the coords.
		LDA var::sprite_index
		ASL
		TAX
		PLA
		STA VIC_II_SPRITE_0_Y, X
		PLA
		STA VIC_II_SPRITE_0_X, X

		RTS


updateAnimations:
		CLC
		LDA VAR_ANIMATION_ADVANCE
		ADC var::animation_countdown
		STA var::animation_countdown
		BCC @return

		CLC
		LDA var::animation_counter
		ADC var::rotors_direction
		STA var::animation_counter
		AND #%00000111
		
		TAY

		TAX
		ASL
		ORA #(SCREEN_MEMORY << 4)
		STA var::memory_pointers_top
		STA var::memory_pointers_bottom
		;Ensure lever graphics is in the correct position

		LDA #CHR_LEVER_T * 8
		STA var::memcopy_target_ptr
		TYA
		ASL
		ASL
		ASL
		ORA #.HIBYTE(VIC_BASE)
		STA var::memcopy_target_ptr_hi

		LDA var::switch_state
		ASL
		ASL
		ASL
		TAX
		LDY #0
		
	@leverLoop:
		LDA CHAR_SWAPPED, X
		STA (var::memcopy_target_ptr), Y
		INX
		INY
		CPY #8
		BNE @leverLoop

		JSR handleSpikeOverlaps

	@return:
		RTS

updateTimebar:
		LDA var::timebar_subpxl
		CLC
		ADC TIMEBAR_SUBPXLS_PER_FRAME
		STA var::timebar_subpxl
		BCC @noOverflow
		LDA #TIMEBAR_COLOUR
		STA var::timebar_colour
		INC var::timebar_hud_row
		LDA var::timebar_hud_row
		CMP #TIMEBAR_WARNING_ROW
		BCC @noWarning
		;Warn
		LDA var::timebar_hud_row
		LSR
		BCC @noWarning
		LDA #TIMEBAR_COLOUR_WARNING
		STA var::timebar_colour
	@noWarning:
		LDA var::timebar_hud_row
		CMP #TIMEBAR_LAST_ROW
		BNE @noDeath
		JSR handleTimeout
	@noDeath:
		LDA var::timebar_hud_row
		STA var::hud_row
		LDA #HUD_TIMEBAR_EMPTY_ROW
		STA var::hud_source_index
		JSR drawHudRowRight
	@noOverflow:
		RTS

handleSpikeOverlaps:
		debug DEBUG_OVERLAPS
		LDA var::rotors_direction
		LSR
		EOR var::animation_counter
		LSR
		BCS @noOverlapChange

		LSR
		BCS @overlapList1

	@overlapList0:
		LDX #0
		BCC @swapNextRotorOverlap
	@overlapList1:
		LDX #SIZE_OF_SPIKE_OVERLAP_LIST

	@swapNextRotorOverlap:
		LDA var::spike_overlap_list_0, X
		;No overlap could have hi_byte 0
		BNE @notFinished
	@noOverlapChange:
		RTS
	@notFinished:
		STA var::colour_ptr_hi
		INX
		LDA var::spike_overlap_list_0, X
		STA var::colour_ptr
		INX
		LDA var::spike_overlap_list_0, X
		;swap the screen colour with the one in the list
		PHA
		LDY #0
		LDA (var::colour_ptr), Y
		STA var::spike_overlap_list_0, X
		PLA
		STA (var::colour_ptr), Y
		
		INX
		JMP @swapNextRotorOverlap

initializeHud:
		LDA VIC_II_SPRITES_X_BIT7 
		AND #%00111111
		ORA #%10000000
		STA VIC_II_SPRITES_X_BIT7 
		
		LDA #.hibyte(HUD_LEFT_ADDRESS)
		STA var::memcopy_target_ptr_hi
		LDA #.lobyte(HUD_LEFT_ADDRESS)
		STA var::memcopy_target_ptr
		LDA #.hibyte(HUD_MEMORY_SIZE)
		STA var::memcopy_num_bytes_hi
		LDA #.lobyte(HUD_MEMORY_SIZE)
		STA var::memcopy_num_bytes
		JSR memclear

		LDA #.hibyte(HUD_RIGHT_ADDRESS)
		STA var::memcopy_target_ptr_hi
		LDA #.lobyte(HUD_RIGHT_ADDRESS)
		STA var::memcopy_target_ptr
		LDA #.hibyte(HUD_MEMORY_SIZE)
		STA var::memcopy_num_bytes_hi
		LDA #.lobyte(HUD_MEMORY_SIZE)
		STA var::memcopy_num_bytes
		JSR memclear

		JSR resetHud
		RTS

resetHud:
		LDA #SPRITE_Y_OFFSET 
		STA VIC_II_SPRITE_6_Y
		LDA #SPRITE_Y_OFFSET
		STA VIC_II_SPRITE_7_Y
		LDA #HUD_LEFT_SPRITE_INDEX + 1
		STA SPRITE_6_INDEX
		LDA #HUD_RIGHT_SPRITE_INDEX + 1
		STA SPRITE_7_INDEX
		LDA var::life_colour_0
		STA VIC_II_SPRITE_6_COLOUR
		LDA var::key_colour_0
		STA VIC_II_SPRITE_7_COLOUR

	@cont:
		RTS

drawHudSymbolLeft:
		LDA #0
		STA var::hud_counter
	@rowLoop:
		JSR drawHudRowLeft
		INC var::hud_source_index
		INC var::hud_source_index
		INC var::hud_source_index
		INC var::hud_row

		INC var::hud_counter
		LDA var::hud_counter
		CMP #HUD_SYMBOL_HEIGHT
		BNE @rowLoop
		RTS

drawHudSymbolRight:
		LDA #0
		STA var::hud_counter
	@rowLoop:
		JSR drawHudRowRight
		INC var::hud_source_index
		INC var::hud_source_index
		INC var::hud_source_index
		INC var::hud_row

		INC var::hud_counter
		LDA var::hud_counter
		CMP #HUD_SYMBOL_HEIGHT
		BNE @rowLoop
		RTS

drawHudRowLeft:
		LDX var::hud_row
		LDA LUT_LINE_TABLE_LO, X
		STA var::hud_row_ptr
		LDA LUT_LINE_TABLE_HI, X
		CLC
		ADC #.hibyte(HUD_LEFT_ADDRESS - HUD_RIGHT_ADDRESS)
		STA var::hud_row_ptr_hi
		JMP drawHudRowCommon

drawHudRowRight:
		LDX var::hud_row
		LDA LUT_LINE_TABLE_LO, X
		STA var::hud_row_ptr
		LDA LUT_LINE_TABLE_HI, X
		STA var::hud_row_ptr_hi
		;Fall through

drawHudRowCommon:
		LDX var::hud_source_index
		LDA HUD_SOURCE, X
		LDY #0
		STA (var::hud_row_ptr), Y
		LDY #64
		STA (var::hud_row_ptr), Y

		INX
		LDA HUD_SOURCE, X
		LDY #1
		STA (var::hud_row_ptr), Y
		LDY #65
		STA (var::hud_row_ptr), Y

		INX
		LDA HUD_SOURCE, X
		LDY #2
		STA (var::hud_row_ptr), Y
		LDY #66
		STA (var::hud_row_ptr), Y
		RTS

drawHeartBar:
		LDA #HEARTBAR_Y - 1
		STA var::hud_row
		LDA #NUM_LEVELS
		STA var::draw_hud_counter

	@loop:
		INC var::hud_row
		LDA #HUD_HEART_HOLLOW_SYMBOL
		STA var::hud_source_index
		JSR drawHudSymbolLeft

		DEC var::draw_hud_counter
		LDA var::draw_hud_counter
		BNE @loop
		
		RTS

drawTimeBar:
		LDA #HUD_TIMEBAR_END_ROW
		STA var::hud_source_index
		LDA #TIMEBAR_Y
		STA var::hud_row
		JSR drawHudRowRight
		LDA #TIMEBAR_Y + TIMEBAR_HEIGHT
		STA var::hud_row
		JSR drawHudRowRight
		LDA #HUD_TIMEBAR_EMPTY_ROW
		STA var::hud_source_index
		LDA #TIMEBAR_Y + 1
		STA var::hud_row
		JSR drawHudRowRight
		LDA #TIMEBAR_Y + TIMEBAR_HEIGHT - 1
		STA var::hud_row
		JSR drawHudRowRight
	
		LDA #HUD_TIMEBAR_FULL_ROW
		STA var::hud_source_index
		LDA #TIMEBAR_HEIGHT - 3
		STA var::draw_hud_counter
		LDA #TIMEBAR_Y + 1
		STA var::hud_row
	@loop:
		LDA #HUD_TIMEBAR_FULL_ROW
		STA var::hud_source_index
		INC var::hud_row
		JSR drawHudRowRight

		DEC var::draw_hud_counter
		LDA var::draw_hud_counter
		BNE @loop

		LDA #TIMEBAR_FIRST_ROW
		STA var::timebar_hud_row
		LDA #0
		STA var::timebar_subpxl

		RTS

drawLives:
		LDA #0
		STA var::draw_hud_counter
	@loop:
		TAX
		LDA LUT_LIFE_Y, X
		STA var::hud_row
		LDA #HUD_LIFE_SYMBOL
		STA var::hud_source_index
		JSR drawHudSymbolLeft
		
		INC var::draw_hud_counter
		LDA var::draw_hud_counter
		CMP #TOTAL_NUM_SPARE_LIVES
		BNE @loop
		
		RTS

drawKeys:
		LDA #0
		STA var::draw_hud_counter
	@loop:
		TAX
		LDA LUT_LIFE_Y, X
		STA var::hud_row
		LDA #HUD_KEY_SYMBOL
		STA var::hud_source_index
		JSR drawHudSymbolRight
		
		INC var::draw_hud_counter
		LDA var::draw_hud_counter
		CMP #TOTAL_NUM_SPARE_LIVES
		BNE @loop
			
		RTS

setupSpikeOverlaps:
		LDX #(SIZE_OF_SPIKE_OVERLAP_LIST * 2) + 1
		LDA #0
	@clearloop:
		STA var::spike_overlap_list_0 - 1, X
		DEX
		BNE @clearloop
		LDA #0
		STA var::spike_overlap_index_0
		LDA #SIZE_OF_SPIKE_OVERLAP_LIST
		STA var::spike_overlap_index_1

		;Skip first row
		LDA #1
		STA var::floor_y

	@rowLoop:
		LDA #0
		STA var::floor_x

	@tileLoop:
		JSR getFloorData
		JSR floorDataToHWallType
		LDA var::wall_type
		CMP #HWALL_SPIKE_UP / 8
		BNE @notSpikes

		DEC var::floor_y
		JSR getFloorData
		JSR floorToScreenAndLevelCoords
		JSR screenCoordsToScreenPtrs

		LDA var::floor_tile
		CMP #TILE_TELEPORT
		BNE @notTeleport
		JSR teleportOverlap
		JMP @skip
	@notTeleport:
		CMP #TILE_CLOCKWISE
		BNE @notClockwiseRotor
		JSR clockwiseRotorOverlap
		JMP @skip
	@notClockwiseRotor:
		CMP #TILE_ANTICLOCKWISE
		BNE @notAnticlockwiseRotor
		JSR anticlockwiseRotorOverlap
	@notAnticlockwiseRotor:
		CMP #TILE_HEART
		BNE @notHeart
		JSR heartOverlap
	@notHeart:

	@skip:
		INC var::floor_y
	@notSpikes:
		INC var::floor_x
		LDA var::floor_x
		CMP #NUM_GAME_COLUMNS
		BEQ @finishedRow
		JMP @tileLoop

	@finishedRow:
		INC var::floor_y
		LDA var::floor_y
		CMP #NUM_GAME_ROWS + 1
		BEQ @return
		JMP @rowLoop
		
	@return:
		RTS

heartOverlap:
		LDA #FLOOR_COLOUR
		LDY #1 + (SCREEN_WIDTH * (TILE_HEIGHT + 1))
		STA (var::colour_ptr), Y
		LDY #4 + (SCREEN_WIDTH * (TILE_HEIGHT + 1))
		STA (var::colour_ptr), Y
		RTS

anticlockwiseRotorOverlap:
		LDA var::spike_overlap_index_0
		STA var::overlap_index_A
		LDA var::spike_overlap_index_1
		STA var::overlap_index_B
		LDX #ROTOR_COLOUR
		LDY #FLOOR_COLOUR
		JMP commonRotorOverlap

clockwiseRotorOverlap:
		LDA var::spike_overlap_index_1
		STA var::overlap_index_A
		LDA var::spike_overlap_index_0
		STA var::overlap_index_B
		LDX #FLOOR_COLOUR
		LDY #ROTOR_COLOUR

commonRotorOverlap:
		STX var::overlap_colour_A
		STY var::overlap_colour_B

		;Blank the corners.
		LDA #FLOOR_COLOUR
		LDY #1 + (SCREEN_WIDTH * (TILE_HEIGHT + 1))
		STA (var::colour_ptr), Y
		LDY #4 + (SCREEN_WIDTH * (TILE_HEIGHT + 1))
		STA (var::colour_ptr), Y

		LDX var::overlap_index_A
		CLC
		LDA var::colour_ptr
		ADC #2 + (SCREEN_WIDTH * (TILE_HEIGHT + 1))
		STA var::spike_overlap_list_0 + 1, X
		LDA var::colour_ptr_hi
		ADC #0
		STA var::spike_overlap_list_0, X
		LDY #2 + (SCREEN_WIDTH * (TILE_HEIGHT + 1))
		LDA var::overlap_colour_A
		STA (var::colour_ptr), Y
		LDA var::overlap_colour_B
		STA var::spike_overlap_list_0 + 2, X

		LDX var::overlap_index_B
		CLC
		LDA var::colour_ptr
		ADC #3 + (SCREEN_WIDTH * (TILE_HEIGHT + 1))
		STA var::spike_overlap_list_0 + 1, X
		LDA var::colour_ptr_hi
		ADC #0
		STA var::spike_overlap_list_0, X
		LDY #3 + (SCREEN_WIDTH * (TILE_HEIGHT + 1))
		LDA var::overlap_colour_B
		STA (var::colour_ptr), Y
		LDA var::overlap_colour_A
		STA var::spike_overlap_list_0 + 2, X

		INC var::spike_overlap_index_0
		INC var::spike_overlap_index_0
		INC var::spike_overlap_index_0
		INC var::spike_overlap_index_1
		INC var::spike_overlap_index_1
		INC var::spike_overlap_index_1
		RTS

teleportOverlap:
		LDA var::spike_overlap_index_0
		STA var::overlap_index_B
		LDA var::spike_overlap_index_1
		STA var::overlap_index_A

		LDX #TELEPORT_COLOUR
		LDY #TELEPORT_COLOUR_2
		STX var::overlap_colour_A
		STY var::overlap_colour_B

		LDX var::overlap_index_A
		CLC
		LDA var::colour_ptr
		ADC #1 + (SCREEN_WIDTH * (TILE_HEIGHT + 1))
		STA var::spike_overlap_list_0 + 1, X
		LDA var::colour_ptr_hi
		ADC #0
		STA var::spike_overlap_list_0 + 0, X
		LDY #2 + (SCREEN_WIDTH * (TILE_HEIGHT + 1))
		LDA var::overlap_colour_A
		STA (var::colour_ptr), Y
		LDA var::overlap_colour_B
		STA var::spike_overlap_list_0 + 2, X

		LDX var::overlap_index_B
		CLC
		LDA var::colour_ptr
		ADC #2 + (SCREEN_WIDTH * (TILE_HEIGHT + 1))
		STA var::spike_overlap_list_0 + 1, X
		LDA var::colour_ptr_hi
		ADC #0
		STA var::spike_overlap_list_0 + 0, X
		LDY #2 + (SCREEN_WIDTH * (TILE_HEIGHT + 1))
		LDA var::overlap_colour_B
		STA (var::colour_ptr), Y
		LDA var::overlap_colour_A
		STA var::spike_overlap_list_0 + 2, X

		LDX var::overlap_index_B
		CLC
		LDA var::colour_ptr
		ADC #3 + (SCREEN_WIDTH * (TILE_HEIGHT + 1))
		STA var::spike_overlap_list_0 + 4, X
		LDA var::colour_ptr_hi
		ADC #0
		STA var::spike_overlap_list_0 + 3, X
		LDY #3 + (SCREEN_WIDTH * (TILE_HEIGHT + 1))
		LDA var::overlap_colour_B
		STA (var::colour_ptr), Y
		LDA var::overlap_colour_A
		STA var::spike_overlap_list_0 + 5, X

		LDX var::overlap_index_A
		CLC
		LDA var::colour_ptr
		ADC #4 + (SCREEN_WIDTH * (TILE_HEIGHT + 1))
		STA var::spike_overlap_list_0 + 4, X
		LDA var::colour_ptr_hi
		ADC #0
		STA var::spike_overlap_list_0 + 3, X
		LDY #4 + (SCREEN_WIDTH * (TILE_HEIGHT + 1))
		LDA var::overlap_colour_A
		STA (var::colour_ptr), Y
		LDA var::overlap_colour_B
		STA var::spike_overlap_list_0 + 5, X

		INC var::spike_overlap_index_0
		INC var::spike_overlap_index_0
		INC var::spike_overlap_index_0
		INC var::spike_overlap_index_1
		INC var::spike_overlap_index_1
		INC var::spike_overlap_index_1

		INC var::spike_overlap_index_0
		INC var::spike_overlap_index_0
		INC var::spike_overlap_index_0
		INC var::spike_overlap_index_1
		INC var::spike_overlap_index_1
		INC var::spike_overlap_index_1

		RTS

drawLevel:
		LDA #0
		STA var::floor_y

	@rowLoop:
		LDA #0
		STA var::floor_x

	@tileLoop:
		JSR floorToScreenAndLevelCoords
		JSR screenCoordsToScreenPtrs

		;Draw top-level corner
		LDA #CHR_BLOCK
		LDY #0
		STA (var::screen_ptr), Y
		LDA #WALL_TOP_COLOUR
		STA (var::colour_ptr),Y

		JSR getFloorData

		LDA var::floor_x
		CMP #NUM_GAME_COLUMNS
		BEQ @skipLastColumn

		JSR floorDataToHWallType
		JSR wallTypeToHWallOffset
		JSR drawHWallTop
		
		LDA var::floor_y
		CMP #NUM_GAME_ROWS
		BEQ @skipLastRow

		JSR hWallEdgeOverride
		JSR drawHWallEdge
		JSR drawTile

		LDA var::floor_tile

		CMP #TILE_PLAYER
		BNE @notPlayer

		LDA #var::player_x_pxl
		STA var::entity_0ptr
		JSR floorCoordsToEntityCoords
		LDA #0
		STA var::player_x_subpxl
		STA var::player_y_subpxl
		STA var::player_z_pxl
		JMP @common

	@notPlayer:
		CMP #TILE_BADDY
		BNE @notBaddy
		LDA #var::baddy_x_pxl
		STA var::entity_0ptr
		JSR floorCoordsToEntityCoords
		LDA #0
		STA var::baddy_x_subpxl
		STA var::baddy_y_subpxl
		STA var::baddy_z_pxl
		INC var::num_baddies
		JMP @common

	@notBaddy:
		;If it's a teleport, store its coords
		CMP #TILE_TELEPORT
		BNE @notTeleport

		LDA var::num_teleports
		ASL
		ADC #var::teleport_0_x
		TAY
		LDA var::floor_x
		STA 0, Y
		LDA var::floor_y
		STA 1, Y
		INC var::num_teleports

	@notTeleport:
		;If it's a switch, store its colour_coords.
		CMP #TILE_SWITCH
		BNE @notSwitch
		LDX var::num_switches
		LDA var::colour_ptr
		STA var::switch_colour_ptr, X
		LDA var::colour_ptr_hi
		STA var::switch_colour_ptr_hi, X
		INC var::num_switches

	@notSwitch:
	@common:
	@skipLastColumn:
	@skipLastRow:

		LDA var::floor_y
		CMP #NUM_GAME_ROWS
		BEQ @skipLastRow2

		JSR floorDataToVWallType
		JSR wallTypeToVWallOffset
		JSR hWallEdgeOverride
		JSR drawVWall
	@skipLastRow2:

		INC var::floor_x
		LDA var::floor_x
		CMP #NUM_GAME_COLUMNS + 1
		BEQ @nextRow
		JMP @tileLoop

	@nextRow:
		INC var::floor_y
		LDA var::floor_y
		CMP #NUM_GAME_ROWS + 1
		BEQ @roundedCorners
		JMP @rowLoop

	@roundedCorners:
		;Round level corners
		LDA #LEVEL_HORIZ_OFFSET + 1
		STA var::screen_x
		LDA #0
		STA var::screen_y
		JSR screenCoordsToScreenPtrs
		LDA #CHR_CORNER_TL
		LDY #0
		STA (var::screen_ptr), Y
		LDA #CHR_CORNER_TR
		LDY #LEVEL_WIDTH
		STA (var::screen_ptr), Y
		LDA #LEVEL_HEIGHT
		STA var::screen_y
		JSR screenCoordsToScreenPtrs
		LDA #CHR_CORNER_BL
		LDY #0
		STA (var::screen_ptr), Y
		LDA #CHR_CORNER_BR
		LDY #LEVEL_WIDTH
		STA (var::screen_ptr), Y
		
	@handleBarriers:

		;Handle barriers (including doors)
		LDY #NUM_GAME_COLUMNS * NUM_GAME_ROWS - 1
		STY var::barrier_index

	@barrierLoop:
		INC var::barrier_index
		LDY var::barrier_index
		LDA (var::level_data_ptr), Y
		STA var::barrier_data
		CMP #BARRIER_TERMINATOR
		BCS @noBarrier
		JSR getBarrierData

		JSR floorToScreenAndLevelCoords
		JSR screenCoordsToScreenPtrs

		LDA var::wall_axis
		BNE @horizontal
		JSR wallTypeToVWallOffset
		JSR drawVWall
		JMP @barrierLoop

	@horizontal:
		JSR wallTypeToHWallOffset
		JSR drawHWallTop
		JSR drawHWallEdge
		JMP @barrierLoop

	@noBarrier:
		;Parse playermetadata
		TAX
		AND #%00000001
		STA var::player_axis
		TXA
		AND #%00000010
		SEC
		SBC #1
		STA var::player_dir
	
	;Parse baddy metadata
		LDA var::num_baddies
		BEQ @noBaddies
		INC var::barrier_index
		LDY var::barrier_index
		LDA (var::level_data_ptr), Y
	
		TAX
		AND #%00000001
		STA var::baddy_axis
		TXA
		AND #%00000010
		SEC
		SBC #1
		STA var::baddy_dir
		TXA 
		AND #%00011100
		LSR
		LSR
		STA var::baddy_floor_lower
		TXA
		CLC
		AND #%11100000
		ROL
		ROL
		ROL
		ROL
		STA var::baddy_floor_upper
	@noBaddies:
	
		RTS

clearScreen:
		LDA #0
		STA var::screen_x
		LDA #0
		STA var::screen_y
	@rowLoop:
		JSR screenCoordsToScreenPtrs
		LDY #0
	@columnLoop:
		LDA #CHR_BLOCK
		STA (var::screen_ptr), Y
		LDA #BORDER_COLOUR
		STA (var::colour_ptr), Y
		INY
		CPY #SCREEN_WIDTH
		BNE @columnLoop
		
		INC var::screen_y
		LDA var::screen_y
		CMP #SCREEN_HEIGHT
		BNE @rowLoop
		RTS

;Put the floor data at (var::floor_x, var::floor_y) in var::floor_data
;and var::floor_tile
getFloorData:
		LDX var::floor_x
		LDY var::floor_y
		;A is a mask which is used to handle the outer walls
		LDA #%00000000
	
		;Handle top and bottom outer walls
		CPY #0
		BNE @yNot0
		ORA #%10000000
	@yNot0:
		CPY #NUM_GAME_ROWS
		BNE @yNot7
		ORA #%01000000
		LDY #0	; Y is mod 6
	@yNot7:

		;Handle left and right outer walls
		CPX #0
		BNE @xNot0
		ORA #%00100000
	@xNot0:
		CPX #NUM_GAME_COLUMNS
		BNE @xNot7
		ORA #%00010000
		LDX #0	; X is mod 6
	@xNot7:
		PHA
	
		;Use the coords to construct an offset in the level data
		TXA
		CLC
		ADC LUT_MUL_BY_6, Y
		TAY
	
		;Look-up the floor tile and combine it with the mask constructed above
		PLA
		ORA (var::level_data_ptr),Y
		STA var::floor_data
		AND #%00001111
		STA var::floor_tile
		RTS

;Move the screen and colour pointer to the position described by the screen
;coords
screenCoordsToScreenPtrs:
		; Multiply y by 40
		LDA var::screen_y
		JSR mulABy10
		STA var::screen_ptr
		LDA #0
		ASL var::screen_ptr
		ROL
		ASL var::screen_ptr
		ROL	
		STA var::screen_ptr_hi
		; Add x
		LDA var::screen_x
		CLC
		ADC var::screen_ptr
		STA var::screen_ptr
		STA var::colour_ptr
		LDA var::screen_ptr_hi
		ADC #.HIBYTE(SCREEN_ADDRESS)
		STA var::screen_ptr_hi
		;TODO Probably not needed.
		CLC
		ADC #.HIBYTE(COLOUR_RAM) - .HIBYTE(SCREEN_ADDRESS)
		STA var::colour_ptr_hi
		RTS



floorToScreenAndLevelCoords:
		LDA var::floor_x
		JSR mulABy5
		ADC #LEVEL_HORIZ_OFFSET + 1
		STA var::screen_x
		LDA var::floor_y
		ASL
		ASL
		STA var::screen_y
		RTS

floorTileToTileDataIndex:
		;Set the tile ptr
		LDA var::floor_tile
		;Safe (16 * 12 = 192)
		JSR mulABy12
		STA var::tiledata_index
		RTS

	;Assume floor_tile, screen_ptr, colour_ptr set
drawTile:
		JSR floorTileToTileDataIndex
		
		LDA #((SCREEN_WIDTH * 2) + 1)
		STA var::screen_offset
		LDX #0
		
	@loop:
		JSR drawTileCharAndAdvance
		INX

		CPX #TILE_WIDTH
		BEQ @newRow
		CPX #(2 * TILE_WIDTH)
		BEQ @newRow
		CPX #(3 * TILE_WIDTH)
		BNE @loop
		RTS

	@newRow:
		LDA var::screen_offset
		ADC #(SCREEN_WIDTH - TILE_WIDTH - 1)
		STA var::screen_offset
		JMP @loop

drawTileCharAndAdvance:
		LDY var::tiledata_index
		LDA TILE_SOURCE, Y
		LDY var::screen_offset
		STA (var::screen_ptr), Y

		LDY var::tiledata_index
		LDA TILE_COLOUR_SOURCE, Y
		LDY var::screen_offset
		STA (var::colour_ptr), Y
	
		INC var::screen_offset
		INC var::tiledata_index
		RTS

floorDataToHWallType:
		LDA var::floor_data	
		ROL
		ROL
		ROL
		AND #%00000011
		STA var::wall_type
		RTS

wallTypeToHWallOffset:
		LDA var::wall_type
		ASL
		ASL
		ASL
		STA var::walldata_top_index
		CLC
		ADC #TILE_WIDTH
		STA var::walldata_edge_index
		RTS

hWallEdgeOverride:
		;Check if the wall edge should be overridden.
		LDA var::floor_data	
		AND #%00001111
		CMP #TILE_CORNER_TL
		BNE @notTL
		LDA #HWALL_CORNER_TL + TILE_WIDTH
		STA var::walldata_edge_index
		RTS
	@notTL:
		CMP #TILE_CORNER_TR
		BNE @notTR
		LDA #HWALL_CORNER_TR + TILE_WIDTH
		STA var::walldata_edge_index
		RTS
	@notTR:
		CMP #TILE_BLOCK
		BNE @notBlock
		LDA #HWALL_BLOCK + TILE_WIDTH
		STA var::walldata_edge_index
		RTS
	@notBlock:
		RTS

drawHWallTop:
		LDA #1
		STA var::screen_offset
		LDX #0

	@loop:
		LDY var::walldata_top_index
		LDA HWALL_SOURCE, Y
		CMP #CHR_GAP
		BNE @setChar
		LDY var::screen_offset
		LDA (var::screen_ptr), Y
	@setChar:
		STA var::char_to_draw

		LDY var::walldata_top_index
		LDA HWALL_COLOUR_SOURCE, Y
		CMP #TRANSPARENT_COLOUR
		BNE @setColour
		;Use existing colour
		LDY var::screen_offset
		LDA (var::colour_ptr), Y
	@setColour:
		STA var::colour_to_draw
		LDY var::screen_offset
		JSR drawCharIndirection

		INC var::screen_offset
		INC var::walldata_top_index
		INX

		CPX #TILE_WIDTH
		BNE @loop
	@gap:
		RTS

drawHWallEdge:
		LDA #SCREEN_WIDTH + 1
		STA var::screen_offset
		LDX #0

	@loop:
		LDY var::walldata_edge_index
		LDA HWALL_SOURCE, Y
		STA var::char_to_draw
		LDY var::walldata_edge_index
		LDA HWALL_COLOUR_SOURCE, Y
		STA var::colour_to_draw
		LDY var::screen_offset
		JSR drawCharIndirection

		INC var::screen_offset
		INC var::walldata_edge_index
		INX

		CPX #TILE_WIDTH
		BNE @loop
	@gap:
		RTS

floorDataToVWallType:
		LDA var::floor_data	
		AND #%00110000
		LSR
		LSR
		LSR
		LSR
		STA var::wall_type
		RTS

wallTypeToVWallOffset:
		LDA var::wall_type
		JSR mulABy3
		STA var::walldata_top_index
		RTS

drawVWall:
		LDA #SCREEN_WIDTH
		STA var::screen_offset
		LDX #3
	@loop:	
		LDY var::walldata_top_index
		LDA VWALL_SOURCE, Y
		STA var::char_to_draw

		LDY var::walldata_top_index
		LDA VWALL_COLOUR_SOURCE, Y
		
		;Hack
		LDY var::text_settings_colours
		BEQ @normalColours
		CMP #WALL_EDGE_COLOUR
		BNE @notWallEdge
		LDA #ALT_WALL_EDGE_COLOUR
	@notWallEdge:
	@normalColours:
		STA var::colour_to_draw
		LDY var::screen_offset
		JSR drawCharIndirection

		INC var::walldata_top_index
		LDA var::screen_offset
		CLC
		ADC #SCREEN_WIDTH
		STA var::screen_offset
		DEX
		BNE @loop
		RTS

getBarrierData:
		;Decode a barrierdata
		LDA var::barrier_data
		AND #%00000011
		;Add 4 for the four basic wall types
		ORA #%00000100
		STA var::wall_type
		LDA var::barrier_data
		LSR
		LSR
		LSR
		TAY
		LDA LUT_DIV_MOD_6, Y
		TAX
		AND #%00000111
		PHA
		TXA
		LSR
		LSR
		LSR
		CLC
		ADC #1
		PHA

		LDA var::barrier_data
		LSR
		LSR
		AND #%00000001
		STA var::wall_axis
		BNE @horizontal
		PLA
		STA var::floor_x
		PLA
		STA var::floor_y
		RTS

	@horizontal:
		PLA
		STA var::floor_y
		PLA
		STA var::floor_x
		RTS

initializeCharacterGraphics:
		LDY #$FF

	@loop:
		INY
		LDA LUT_CHARBLOCKS, Y
		STA var::charblock_source_ptr
		INY
		LDA LUT_CHARBLOCKS, Y
		BNE @moreData
		RTS
	@moreData:
		STA var::charblock_source_ptr_hi
		INY
		LDA LUT_CHARBLOCKS, Y
		STA var::charblock_num_chars
		INY
		LDA LUT_CHARBLOCKS, Y
		STA var::charblock_target_char
		INY
		LDA LUT_CHARBLOCKS, Y
		STA var::charblock_filter

		TYA
		PHA
		JSR copyCharacterBlock
		PLA
		TAY

		JMP @loop

copyCharacterBlock:
		LDA #9
		STA var::counter
		
		;Initialize the target ptrs.
		LDA #.HIBYTE(VIC_BASE)
		STA var::memcopy_target_ptr_hi

	@loop:
		ASL var::charblock_filter		
		BCC @advance

		;Set up the source ptrs
		LDA var::charblock_source_ptr_hi
		STA var::memcopy_source_ptr_hi
		LDA var::charblock_source_ptr
		STA var::memcopy_source_ptr

		LDA var::charblock_target_char
		ASL
		ASL
		ASL
		STA var::memcopy_target_ptr
		;Capture the carry (there can be only one, since target_char < 64)
		LDA var::memcopy_target_ptr_hi
		ADC #0
		STA var::memcopy_target_ptr_hi

		LDA var::charblock_num_chars
		ASL
		ASL
		ASL
		STA var::memcopy_num_bytes
		;Capture the carry (there can be only one, since num_chars < 64)
		LDA #0
		ADC #0
		STA var::memcopy_num_bytes_hi

		JSR memcopy

	@advance:
		LDA var::memcopy_target_ptr_hi
		AND #%11111000
		CLC
		ADC #%00001000
		STA var::memcopy_target_ptr_hi
		DEC var::counter
		BNE @loop
		RTS

copyQuadSpriteSection:
		STY var::sprite_source_index
	@loop:
		LDY var::sprite_source_index
		LDA (var::memcopy_source_ptr), Y
		LDY #0
		STA (var::memcopy_target_ptr), Y

	@incTarget:
		CLC
		LDA var::memcopy_target_ptr
		ADC #1
		STA var::memcopy_target_ptr
		LDA var::memcopy_target_ptr_hi
		ADC #0
		STA var::memcopy_target_ptr_hi

		;Skip bytes at 63 mod 64.
		LDA var::memcopy_target_ptr
		AND #%00111111
		CMP #%00111111
		BEQ @incTarget
		
		INC var::sprite_source_index
		DEX
		BNE @loop

		RTS

copyQuadSprite:
	;Arrange the two quad-sprites in the target memory.
		LDY #0
		LDX #63 + 33
		JSR copyQuadSpriteSection
		LDY #33
		LDX #30 + 63 + 63 + 33
		JSR copyQuadSpriteSection
		LDY #63 + 63 + 33
		LDX #30  + 63
		JSR copyQuadSpriteSection
		RTS

copyBlockOfQuadSprites:
	;The number of quad sprites is in memcopy_num_bytes
	@quadSpriteLoop:
		JSR copyQuadSprite

		CLC
		LDA var::memcopy_source_ptr
		ADC #63 * 4
		STA var::memcopy_source_ptr
		LDA var::memcopy_source_ptr_hi
		ADC #0
		STA var::memcopy_source_ptr_hi
		DEC var::memcopy_num_bytes
		BNE @quadSpriteLoop
		RTS

initializeSpriteGraphics:
		SEC
		LDA #.hibyte(SPRITE_ADDRESS_0)
		SBC var::memcopy_target_offset_hi
		STA var::memcopy_target_ptr_hi
		LDA #.lobyte(SPRITE_ADDRESS_0)
		STA var::memcopy_target_ptr
		LDA #.hibyte(SPRITE_SOURCE_BEGIN)
		STA var::memcopy_source_ptr_hi
		LDA #.lobyte(SPRITE_SOURCE_BEGIN)
		STA var::memcopy_source_ptr
		LDA #.hibyte(SPRITE_SOURCE_END - SPRITE_SOURCE_BEGIN)
		STA var::memcopy_num_bytes_hi
		LDA #.lobyte(SPRITE_SOURCE_END - SPRITE_SOURCE_BEGIN)
		STA var::memcopy_num_bytes
		JSR memcopy

		SEC
		LDA #.hibyte(SPRITE_ADDRESS_1)
		SBC var::memcopy_target_offset_hi
		STA var::memcopy_target_ptr_hi
		LDA #.lobyte(SPRITE_ADDRESS_1)
		STA var::memcopy_target_ptr
		LDA #.hibyte(SPRITE_SOURCE_2_BEGIN)
		STA var::memcopy_source_ptr_hi
		LDA #.lobyte(SPRITE_SOURCE_2_BEGIN)
		STA var::memcopy_source_ptr
		LDA #.hibyte(SPRITE_SOURCE_2_END - SPRITE_SOURCE_2_BEGIN)
		STA var::memcopy_num_bytes_hi
		LDA #.lobyte(SPRITE_SOURCE_2_END - SPRITE_SOURCE_2_BEGIN)
		STA var::memcopy_num_bytes
		JSR memcopy

		SEC
		LDA #.hibyte(SPRITE_ADDRESS_2)
		SBC var::memcopy_target_offset_hi
		STA var::memcopy_target_ptr_hi
		LDA #.lobyte(SPRITE_ADDRESS_2)
		STA var::memcopy_target_ptr
		LDA #.hibyte(QSPRITE_SOURCE)
		STA var::memcopy_source_ptr_hi
		LDA #.lobyte(QSPRITE_SOURCE)
		STA var::memcopy_source_ptr
		LDA #(QSPRITE_SOURCE_END - QSPRITE_SOURCE) / (63 * 4)
		STA var::memcopy_num_bytes
		JSR copyBlockOfQuadSprites

		SEC
		LDA #.hibyte(SPRITE_ADDRESS_3)
		SBC var::memcopy_target_offset_hi
		STA var::memcopy_target_ptr_hi
		LDA #.lobyte(SPRITE_ADDRESS_3)
		STA var::memcopy_target_ptr
		LDA #.hibyte(QSPRITE_SOURCE_2)
		STA var::memcopy_source_ptr_hi
		LDA #.lobyte(QSPRITE_SOURCE_2)
		STA var::memcopy_source_ptr
		LDA #(QSPRITE_SOURCE_2_END - QSPRITE_SOURCE_2) / (63 * 4)
		STA var::memcopy_num_bytes
		JSR copyBlockOfQuadSprites

		SEC
		LDA #.hibyte(SPRITE_ADDRESS_4)
		SBC var::memcopy_target_offset_hi
		STA var::memcopy_target_ptr_hi
		LDA #.lobyte(SPRITE_ADDRESS_4)
		STA var::memcopy_target_ptr
		LDA #.hibyte(QSPRITE_SOURCE_3)
		STA var::memcopy_source_ptr_hi
		LDA #.lobyte(QSPRITE_SOURCE_3)
		STA var::memcopy_source_ptr
		LDA #(QSPRITE_SOURCE_3_END - QSPRITE_SOURCE_3) / (63 * 2)
		STA var::memcopy_num_bytes
		JSR copyBlockOfQuadSprites

		RTS

setNormalColourScheme:
		LDX #LUT_COLOURS_END - LUT_COLOURS + 1
	@loop:
		LDA LUT_COLOURS - 1, X
		STA var::colour_table - 1, X
		DEX
		BNE @loop
		RTS

setAlternativeColourScheme:
		LDX #LUT_ALT_COLOURS_END - LUT_ALT_COLOURS + 1
	@loop:
		LDA LUT_ALT_COLOURS - 1, X
		STA var::colour_table - 1, X
		DEX
		BNE @loop
		RTS

setSpeed:
		LDA var::text_settings_speed
		ASL
		ASL
		ASL
		CLC
		ADC var::region_speed_offset
		TAX
		LDY #0
	@playerLoop:
		LDA LUT_SPEEDS_PXL, X
		STA var::player_speed_pxl, Y
		INX
		INY
		CPY #4
		BNE @playerLoop

		LDY #0
	@baddyLoop:
		LDA LUT_SPEEDS_PXL, X
		STA var::baddy_speed_pxl, Y
		INX
		INY
		CPY #4
		BNE @baddyLoop
		RTS

mapScreenToAlternativeColours:
		LDA #0
		STA var::screen_x
		LDA #SCREEN_HEIGHT
		STA var::screen_y
	@rowLoop:
		DEC var::screen_y
		JSR screenCoordsToScreenPtrs
		LDY #SCREEN_WIDTH	
	@charLoop:
		LDA (var::colour_ptr), Y
		AND #%00001111
		CMP #WALL_TOP_COLOUR
		BNE @notWallTop
		LDA #ALT_WALL_TOP_COLOUR
		STA (var::colour_ptr), Y
		JMP @continue
	@notWallTop:
		CMP #WALL_EDGE_COLOUR
		BNE @notWallEdge
		LDA #ALT_WALL_EDGE_COLOUR
		STA (var::colour_ptr), Y
	@notWallEdge:
	@continue:
		DEY
		BNE @charLoop

		LDA var::screen_y
		BNE @rowLoop
		RTS

nmiInterrupt:
		PHA
		LDA #1
		STA var::is_cheating
		PLA
		RTI

transitionalInterrupt:
		PHA
		TXA
		PHA
		TYA
		PHA

		debug DEBUG_MUSIC
		JSR PLAY_MUSIC
		enddebug

		;Re-enable this interrupt.
		LDA #%11111111
		STA VIC_II_INTERRUPT_STATUS

		PLA
		TAY
		PLA
		TAX
		PLA
		RTI

; Utilities

divABy10:
		LSR
divABy5:
		TAX	
		LDA LUT_DIV_MOD_5, X
;		TAY
;		AND #%00000111
;		STA var::mod_result
;		TYA
;		LSR
;		LSR
;		LSR
		RTS

mulABy40:
		ASL
mulABy20:
		ASL
mulABy10:
		ASL
mulABy5:
		STA var::multTemp
		ASL
		ASL
		ADC var::multTemp
		RTS

mulABy12:
		ASL
mulABy6:
		ASL
mulABy3:
		STA var::multTemp
		ASL
		;TODO think this CLC isn't needed?
		CLC
		ADC var::multTemp
		RTS

memclear:
		LDY #0
		INC var::memcopy_num_bytes_hi
		INC var::memcopy_num_bytes
	@loop:
		LDA #0
		STA (var::memcopy_target_ptr),Y
		INC var::memcopy_target_ptr
		BNE @neq
		INC var::memcopy_target_ptr_hi
	@neq:
		DEC var::memcopy_num_bytes
		BNE @loop
		DEC var::memcopy_num_bytes_hi
		BNE @loop
	@ret:
		RTS

	;Assumes at least one byte must be copied.
	;Always copies to RAM, but can see Character ROM.
	;Quite slow, so only intended for use during initialization.
memcopy:
		LDY #0
		INC var::memcopy_num_bytes_hi
		;INC var::memcopy_num_bytes
	@loop:
		LDA (var::memcopy_source_ptr),Y
		STA (var::memcopy_target_ptr),Y
		INC var::memcopy_target_ptr
		BNE @neq
		INC var::memcopy_target_ptr_hi
	@neq:
		INC var::memcopy_source_ptr
		BNE @neq2
		INC var::memcopy_source_ptr_hi
	@neq2:
		DEC var::memcopy_num_bytes
		BNE @loop
		DEC var::memcopy_num_bytes_hi
		BNE @loop
	@ret:
		RTS



