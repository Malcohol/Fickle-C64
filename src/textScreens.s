.charmap 'A',  0
.charmap 'B',  1
.charmap 'C',  2
.charmap 'D',  3
.charmap 'E',  4
.charmap 'F',  5
.charmap 'G',  6
.charmap 'H',  7
.charmap 'I',  8
.charmap 'J',  9
.charmap 'K', 10
.charmap 'L', 11
.charmap 'M', 12
.charmap 'N', 13
.charmap 'O', 14
.charmap 'P', 15
.charmap 'Q', 16
.charmap 'R', 17
.charmap 'S', 18
.charmap 'T', 19
.charmap 'U', 20
.charmap 'V', 21
.charmap 'W', 22
.charmap 'X', 23
.charmap 'Y', 24
.charmap 'Z', 25
TEXT_SPACE = 26
.charmap ' ', 26
.charmap '!', 27
.charmap ''', 28
.charmap '(', 29
.charmap ')', 30
.charmap ',', 31
.charmap '-', 32
.charmap '.', 33
.charmap '/', 34
.charmap '0', 35
.charmap '1', 36
.charmap '2', 37
.charmap '4', 38
.charmap '5', 39
.charmap '6', 40
.charmap ':', 41
TEXT_HEART = 42
.charmap 'h', 42 ; Heart
.charmap 'o', 43 ; Hollow heart
.charmap 'c', 44 ; Copyright L
.charmap 'r', 45 ; Copyright R
.charmap 'u', 46 ; rotor TL
.charmap 'v', 47 ; rotor TR
.charmap 'w', 48 ; rotor BL
.charmap 'x', 49 ; rotor BR
.charmap '{', 50 ; Hilight top left
.charmap '_', 51 ; Hilight top
.charmap '}', 52 ; Hilight top right
.charmap '[', 53 ; Hilight left
.charmap ']', 54 ; Hilight right
.charmap '%', 55 ; Hilight bottom left
.charmap '^', 56 ; Hilight bottom
.charmap '|', 57 ; Hilight bottom right
.charmap '8', 58 ; Clockwise rotor Left
.charmap '9', 59 ; Clockwise rotor Right
.charmap '3', 60 ; Anticlockwise rotor Left
.charmap '7', 61 ; Anticlockwise rotor Right

;BB is background colour 0..3, and has no memory cost.
.macro textString YY, XX, BB, SS
	.byte YY, XX, .strlen(SS)
.if BB = 0
	.byte SS
.else
.repeat .strlen(SS), I
    .byte .strat(SS,I) | (64 * BB)
.endrep
.endif
.endmacro

.macro textStringCentred YY, BB, SS
	textString YY, ((SCREEN_WIDTH - .strlen(SS)) - ((SCREEN_WIDTH - .strlen(SS)) .mod 2)) / 2 - 1, BB, SS
.endmacro
	

TEXT_TITLES:
	textStringCentred 2, 0, "FICKLEh"
TEXT_OPTION_NEW_GAME:
	textString (SCREEN_HEIGHT / 2) - 4, 13, 0, "START GAME"
TEXT_OPTION_INSTRUCTIONS:
	textString (SCREEN_HEIGHT / 2) - 1, 13, 0, "INSTRUCTIONS"
TEXT_OPTION_SETTINGS:
	textString (SCREEN_HEIGHT / 2) + 2, 13, 0, "SETTINGS"
TEXT_OPTION_CREDITS:
	textString (SCREEN_HEIGHT / 2) + 5, 13, 0, "CREDITS"
	textStringCentred SCREEN_HEIGHT - 2, 0, "cr2014 MALCOLM TYRRELL"
	.byte 0

TEXT_TITLES_OPTIONS:
	.byte 4
	.word TEXT_OPTION_NEW_GAME, 0, TEXT_OPTION_INSTRUCTIONS, 0, TEXT_OPTION_SETTINGS, 0, TEXT_OPTION_CREDITS, 0

TEXT_SETTINGS:
	textString 1, 1, 0, "SETTINGS"
TEXT_OPTION_BACK_TO_MENU:
	textString 6, 3, 0, "BACK"
TEXT_OPTION_MUSIC:
	textString 10, 3, 0, "MUSIC"
TEXT_OPTION_MUSIC_ON:
	textString 10, 12, 0, "ON"
TEXT_OPTION_MUSIC_OFF:
	textString 10, 19, 0, "OFF"
TEXT_OPTION_SPEED:
	textString 14, 3, 0, "SPEED"
TEXT_OPTION_SPEED_SLOW:
	textString 14, 12, 0, "SLOW"
TEXT_OPTION_SPEED_NORMAL:
	textString 14, 19, 0, "MEDIUM"
TEXT_OPTION_SPEED_FAST:
	textString 14, 28, 0, "FAST"
TEXT_OPTION_ACCESSIBILITY:
	textString 18, 3, 0, "COLOURS"
TEXT_OPTION_ACCESSIBILITY_REDGREEN:
	textString 18, 12, 0, "GREEN/RED"
TEXT_OPTION_ACCESSIBILITY_BLUEYELLOW:
	textString 18, 24, 0, "BLUE/RED"
TEXT_OPTION_ROTORS:
	textString 22, 3, 0, "ROTORS"
TEXT_OPTION_ROTORS_TWIST:
	textString 22, 12, 0, "TWIST"
TEXT_OPTION_ROTORS_PUSH:
	textString 22, 19, 0, "FLING"
	.byte 0

	.byte 0

TEXT_SETTINGS_OPTIONS:
	.byte 5
	.word TEXT_OPTION_BACK_TO_MENU, 0
	.word TEXT_OPTION_MUSIC, TEXT_MUSIC_SUBOPTIONS
	.word TEXT_OPTION_SPEED, TEXT_SPEED_SUBOPTIONS
	.word TEXT_OPTION_ACCESSIBILITY, TEXT_ACCESSIBILITY_SUBOPTIONS
	.word TEXT_OPTION_ROTORS, TEXT_ROTORS_SUBOPTIONS

TEXT_MUSIC_SUBOPTIONS:
	.byte 2
	.word TEXT_OPTION_MUSIC_ON, TEXT_OPTION_MUSIC_OFF

TEXT_SPEED_SUBOPTIONS:
	.byte 3
	.word TEXT_OPTION_SPEED_SLOW, TEXT_OPTION_SPEED_NORMAL, TEXT_OPTION_SPEED_FAST

TEXT_ACCESSIBILITY_SUBOPTIONS:
	.byte 2
	.word TEXT_OPTION_ACCESSIBILITY_REDGREEN, TEXT_OPTION_ACCESSIBILITY_BLUEYELLOW

TEXT_ROTORS_SUBOPTIONS:
	.byte 2
	.word TEXT_OPTION_ROTORS_TWIST, TEXT_OPTION_ROTORS_PUSH 

TEXT_GOOD_LUCK:
	textStringCentred (SCREEN_HEIGHT / 2), 0, "GOOD LUCK, FICKLE!"
	.byte 0

TEXT_GAME_OVER:
	textStringCentred (SCREEN_HEIGHT / 2) - 3, 0, "GAME OVER, FICKLE."
	textStringCentred (SCREEN_HEIGHT / 2) + 1, 0, "TAKE h"
	textStringCentred (SCREEN_HEIGHT / 2) + 3, 0, "AND TRY AGAIN."
	.byte 0

TEXT_CONGRATULATIONS:
	textStringCentred (SCREEN_HEIGHT / 2) - 6, 0, "WELL DONE, FICKLE."
	textStringCentred (SCREEN_HEIGHT / 2) + 6, 0, "YOU WON MY h!"
	.byte 0

TEXT_CHEAT:
	textStringCentred (SCREEN_HEIGHT / 2) - 1, 0, "YOU CANNOT WIN MY"
	textStringCentred (SCREEN_HEIGHT / 2) + 1, 0, "h BY CHEATING!"
	.byte 0

TEXT_INSTRUCTIONS_1:
	textString 1, 1, 0, "INSTRUCTIONS (hooooo)"
	textString 5 + 1, 1, 0, "FICKLE IS A VERY UNRELIABLE SORT,"
	textString 5 + 3, 1, 0, "ALWAYS FLITTING AROUND AFTER NEW"
	textString 5 + 5, 1, 0, "AND DIFFERENT THINGS."
	textString 5 + 9, 1, 0, "THIS GAME HAS DECIDED TO TEACH"
	textString 5 + 11, 1, 0, "FICKLE TO BE STEADFAST BY PLAYING"
	textString 5 + 13, 1, 0, "HARD-TO-GET."
TEXT_INSTRUCTIONS_1_0:
TEXT_INSTRUCTIONS_1_0_ALT:
	.byte 0

TEXT_INSTRUCTIONS_2:
	textString 1, 1, 0, "INSTRUCTIONS (hhoooo)"
	textString 5 + 1, 1, 0, "FICKLE HAS TWO MOODS,"
	textString 5 + 3, 1, 0, "RED, WHICH CAN BE TOGGLED BY"
	textString 5 + 5, 1, 0, "PRESSING ANY KEY EXCEPT RESTORE."
	textString 5 + 9, 1, 0, "THAT'S ALL THE CONTROL YOU HAVE,"
	textString 5 + 11, 1, 0, "BUT IT'S JUST ENOUGH TO HELP"
	textString 5 + 13, 1, 0, "FICKLE WIN THE GAME'S h."
	.byte 0

TEXT_INSTRUCTIONS_2_0:
	textString 5 + 1, 23, 0, "GREEN AND"
	.byte 0

TEXT_INSTRUCTIONS_2_0_ALT:
	textString 5 + 1, 23, 0, "BLUE AND"
	.byte 0

TEXT_INSTRUCTIONS_3:
	textString 1, 1, 0, "INSTRUCTIONS (hhhooo)"
	textString 5 + 3, 1, 0, "WOBBLES ALONG, INTERACTING"
	textString 5 + 5, 1, 0, "WITH THINGS ON THE FLOOR." 
	textString 5 + 11, 1, 0, "THROW A SWITCH OR USE A"
	textString 5 + 13, 1, 0, "TELEPORTER."
	.byte 0

TEXT_INSTRUCTIONS_3_0:
	textString 5 + 1, 1, 0, "IN A GREEN MOOD, FICKLE"
	textString 5 + 9, 1, 0, "GREEN FICKLE WILL PICK UP A KEY"
	.byte 0

TEXT_INSTRUCTIONS_3_0_ALT:
	textString 5 + 1, 1, 0, "IN A BLUE MOOD, FICKLE"
	textString 5 + 9, 1, 0, "BLUE FICKLE WILL PICK UP A KEY"
	.byte 0

TEXT_INSTRUCTIONS_4:
	textString 1, 1, 0, "INSTRUCTIONS (hhhhoo)"
	textString 5 + 1, 1, 0, "MOST IMPORTANTLY:"
	textString 5 + 4, 19, 0, "uv"
	textString 5 + 5, 1, 0, "CLOCKWISE ROTORS (89)"
	textString 5 + 6, 19, 0, "wx"
	textString 5 + 10, 23, 0, "uv"
	textString 5 + 11, 1, 0, "ANTICLOCKWISE ROTORS (37)"
	textString 5 + 12, 23, 0, "wx"
	.byte 0

TEXT_INSTRUCTIONS_4_0:
	textString 5 + 5, 23, 0, "FLING"
	textString 5 + 7, 1, 0, "GREEN FICKLE TO THE LEFT."
	textString 5 + 11, 27, 0, "FLING"
	textString 5 + 13, 1, 0, "GREEN FICKLE TO THE RIGHT."
	.byte 0

TEXT_INSTRUCTIONS_4_0_ALT0:
	textString 5 + 5, 23, 0, "TWIST"
	textString 5 + 7, 1, 0, "GREEN FICKLE TO THE RIGHT."
	textString 5 + 11, 27, 0, "TWIST"
	textString 5 + 13, 1, 0, "GREEN FICKLE TO THE LEFT."
	.byte 0

TEXT_INSTRUCTIONS_4_0_ALT1:
	textString 5 + 5, 23, 0, "FLING"
	textString 5 + 7, 1, 0, "BLUE FICKLE TO THE LEFT."
	textString 5 + 11, 27, 0, "FLING"
	textString 5 + 13, 1, 0, "BLUE FICKLE TO THE RIGHT."
	.byte 0

TEXT_INSTRUCTIONS_4_0_ALT2:
	textString 5 + 5, 23, 0, "TWIST"
	textString 5 + 7, 1, 0, "BLUE FICKLE TO THE RIGHT."
	textString 5 + 11, 27, 0, "TWIST"
	textString 5 + 13, 1, 0, "BLUE FICKLE TO THE LEFT."
	.byte 0


TEXT_INSTRUCTIONS_5:
	textString 1, 1, 0, "INSTRUCTIONS (hhhhho)"
	textString 5 + 1, 1, 0, "IN A RED MOOD, FICKLE"
	textString 5 + 3, 1, 0, "BOUNCES ALONG, IGNORING"
	textString 5 + 5, 1, 0, "THINGS ON THE FLOOR." 
	;textString 5 + 7, 1, 0, "AND IGNORING THEM."
	textString 5 + 9, 1, 0, "HOWEVER, RED FICKLE CAN'T IGNORE"
	textString 5 + 11, 1, 0, "WALLS, DOORS OR OTHER BARRIERS."
	textString 5 + 13, 1, 0, "THEY'RE TOO HIGH."
TEXT_INSTRUCTIONS_5_0:
TEXT_INSTRUCTIONS_5_0_ALT:
	.byte 0

TEXT_INSTRUCTIONS_6:
	textString 1, 1, 0, "INSTRUCTIONS (hhhhhh)"
	textString 5 + 1, 1, 0, "LASTLY:"
	textString 5 + 5, 1, 0, "IN EITHER MOOD, FICKLE WILL"
	textString 5 + 7, 1, 0, "USE A KEY TO OPEN A DOOR."
	textString 5 + 11, 1, 0, "(NO ONE LIKES TO BUMP INTO A"
	textString 5 + 13, 1, 0, "DOOR IF THEY DON'T HAVE TO.)"
TEXT_INSTRUCTIONS_6_0:
TEXT_INSTRUCTIONS_6_0_ALT:
	.byte 0

;TEXT_INSTRUCTIONS_7:
;	textString 1, 1, 0, "INSTRUCTIONS (hhhhhhh)"
;	textString 5 + 1, 1, 0, "LASTLY:"
;	textString 5 + 5, 1, 0, "YOU CAN USE THE RESTORE KEY TO"
;	textString 5 + 7, 1, 0, "SKIP A LEVEL."
;	textString 5 + 11, 1, 0, "HOWEVER, THAT WILL CAUSE THE"
;	textString 5 + 13, 1, 0, "GAME TO WITHHOLD ITS LOVE."
;TEXT_INSTRUCTIONS_7_0:
;TEXT_INSTRUCTIONS_7_0_ALT:
;	.byte 0

TEXT_INSTRUCTIONS_NAVIGATION:
TEXT_OPTION_BACK:
	textString SCREEN_HEIGHT - 2, 1, 0, "BACK"
TEXT_OPTION_NEXT:
	textString SCREEN_HEIGHT - 2, SCREEN_WIDTH - 10, 0, "NEXT"
	.byte 0

TEXT_INSTRUCTIONS_SUBOPTIONS:
	.byte 2
	.word TEXT_OPTION_BACK, TEXT_OPTION_NEXT

TEXT_INSTRUCTIONS_PAGES:
	.byte 5
	.word TEXT_INSTRUCTIONS_1, TEXT_INSTRUCTIONS_SUBOPTIONS
	.word TEXT_INSTRUCTIONS_2, TEXT_INSTRUCTIONS_SUBOPTIONS
	.word TEXT_INSTRUCTIONS_3, TEXT_INSTRUCTIONS_SUBOPTIONS
	.word TEXT_INSTRUCTIONS_4, TEXT_INSTRUCTIONS_SUBOPTIONS
	.word TEXT_INSTRUCTIONS_5, TEXT_INSTRUCTIONS_SUBOPTIONS
	.word TEXT_INSTRUCTIONS_6, TEXT_INSTRUCTIONS_SUBOPTIONS

TEXT_INSTRUCTIONS_ALT:
	.word TEXT_INSTRUCTIONS_1_0, TEXT_INSTRUCTIONS_1_0
	.word TEXT_INSTRUCTIONS_1_0, TEXT_INSTRUCTIONS_1_0

	.word TEXT_INSTRUCTIONS_2_0, TEXT_INSTRUCTIONS_2_0_ALT
	.word TEXT_INSTRUCTIONS_2_0, TEXT_INSTRUCTIONS_2_0_ALT

	.word TEXT_INSTRUCTIONS_3_0, TEXT_INSTRUCTIONS_3_0_ALT
	.word TEXT_INSTRUCTIONS_3_0, TEXT_INSTRUCTIONS_3_0_ALT

	.word TEXT_INSTRUCTIONS_4_0, TEXT_INSTRUCTIONS_4_0_ALT0
	.word TEXT_INSTRUCTIONS_4_0_ALT1, TEXT_INSTRUCTIONS_4_0_ALT2

	.word TEXT_INSTRUCTIONS_5_0, TEXT_INSTRUCTIONS_5_0_ALT
	.word TEXT_INSTRUCTIONS_5_0, TEXT_INSTRUCTIONS_5_0_ALT

	.word TEXT_INSTRUCTIONS_6_0, TEXT_INSTRUCTIONS_6_0_ALT
	.word TEXT_INSTRUCTIONS_6_0, TEXT_INSTRUCTIONS_6_0_ALT

TEXT_CREDITS:
	textString 1, 1, 0, "CREDITS"
	textString 5 + 1, 3, 0, "DESIGN/CODE"
	textString 5 + 1, 17, 0, "MALCOLM TYRRELL"
	textString 5 + 4, 3, 0, "MUSIC"
	textString 5 + 4, 18, 0, "NICOLE TYRRELL"
	textString 5 + 6, 17, 0, "MALCOLM TYRRELL"
	textString 5 + 9, 3, 0, "TOOLS"
	textString 5 + 9, 23, 0,  "CA65/LD65"
	textString 5 + 11, 23, 0, "EXOMIZER2"
	textString 5 + 13, 20, 0, "GOATTRACKER2"
TEXT_CREDITS_BACK:
	textString SCREEN_HEIGHT - 2, SCREEN_WIDTH - 10, 0, "BACK"
	.byte 0

processOptions:
		LDA var::key_event
		AND #JOYSTICK_BIT_DOWN | JOYSTICK_BIT_UP
		BEQ @notUpOrDown
		;Blank the old hilight.
		JSR setTextPtrFromOption
		LDA #BG_NOHILIGHT
		STA var::text_hilight_colour
		JSR textHilight

		LDA var::key_event
		CMP #JOYSTICK_BIT_DOWN
		BEQ @nextOption

	@prevOption:
		LDX var::text_current_option
		DEX
		CPX #$FF
		BNE @notFirstOption
		LDX var::text_num_options
		DEX
	@notFirstOption:
		STX var::text_current_option
		JMP @upOrDown

	@nextOption:
		LDX var::text_current_option
		INX
		CPX var::text_num_options
		BNE @notLastOption
		LDX #0
	@notLastOption:
		STX var::text_current_option

	@upOrDown:
		JSR setTextPtrFromOption
		LDA #BG_HILIGHT
		STA var::text_hilight_colour
		JSR textHilight
		
		STA var::key_event
		RTS
	
	@notUpOrDown:
		RTS

processSuboptions:
		LDA var::key_event
		AND #JOYSTICK_BIT_LEFT | JOYSTICK_BIT_RIGHT
		BEQ @notLeftOrRight

		;Blank the old hilight.
		JSR setTextPtrFromSuboption
		LDA #BG_NOHILIGHT
		STA var::text_hilight_colour
		JSR textHilight
		
		LDA var::key_event
		CMP #JOYSTICK_BIT_RIGHT
		BEQ @nextOption

	@prevOption:
		LDX var::text_current_suboption
		DEX
		CPX #$FF
		BNE @notFirstOption
		LDX var::text_num_suboptions
		DEX
	@notFirstOption:
		STX var::text_current_suboption
		JMP @leftOrRight

	@nextOption:
		LDX var::text_current_suboption
		INX
		CPX var::text_num_suboptions
		BNE @notLastOption
		LDX #0
	@notLastOption:
		STX var::text_current_suboption

	@leftOrRight:
		JSR setTextPtrFromSuboption
		LDA var::text_suboption_hilight
		STA var::text_hilight_colour
		JSR textHilight
		RTS
	
	@notLeftOrRight:
		RTS


initOptions:
		LDA var::text_current_option

		LDY #0
		LDA (var::text_option_ptr), Y
		STA var::text_num_options

		JSR setTextPtrFromOption
		LDA #BG_HILIGHT
		STA var::text_hilight_colour
		JSR textHilight
		RTS

setTextPtrFromOption:
		;Move textptr
		LDA var::text_current_option
		ASL
		ASL
		TAY
		INY
		LDA (var::text_option_ptr), Y
		STA var::text_ptr
		INY
		LDA (var::text_option_ptr), Y
		STA var::text_ptr_hi
		RTS

setTextPtrFromSuboption:
		LDA var::text_current_suboption
		ASL
		TAY
		INY
		LDA (var::text_suboption_ptr), Y
		STA var::text_ptr
		INY
		LDA (var::text_suboption_ptr), Y
		STA var::text_ptr_hi
		RTS

setSuboptionFromOption:
		;Move textptr
		LDA var::text_current_option
		ASL
		ASL
		TAY
		INY
		INY
		INY
		LDA (var::text_option_ptr), Y
		STA var::text_suboption_ptr
		INY
		LDA (var::text_option_ptr), Y
		STA var::text_suboption_ptr_hi
		LDY #0
		LDA (var::text_suboption_ptr), Y
		STA var::text_num_suboptions
		RTS

initTextScreen:
		; Set the Vic Bank
		LDA CIA2_PORT_A_VIC_BANK	
		AND #%11111100
		ORA #(3 - TEXT_VIC_BANK)
		STA CIA2_PORT_A_VIC_BANK

		LDA #%11000100
		STA VIC_II_SCREEN_CONTROL_REG2
		LDA #(TEXT_SCREEN_MEMORY << 4) | (TEXT_CHAR_MEMORY << 1)
		STA var::memory_pointers_top
		STA var::memory_pointers_bottom
		STA VIC_II_MEMORY_POINTERS

		LDA #TEXT_BACKGROUND_1
		STA VIC_II_BACKGROUND_COLOUR_1
		LDA #TEXT_BACKGROUND_2
		STA VIC_II_BACKGROUND_COLOUR_2
		LDA #TEXT_BACKGROUND_3
		STA VIC_II_BACKGROUND_COLOUR_3

		LDA #%00000000
		STA var::sprite_enable

		LDA #0	
		STA var::static_subpxl
		STA var::static_pxl	

		LDA #0
		STA var::animation_countdown
		STA var::animation_counter

		JSR clearTextScreen

		LDA #.hibyte(TEXT_SPRITE_0_INDEX)
		STA INTERRUPT_UPDATE_ADDRESS_0
		STA INTERRUPT_UPDATE_ADDRESS_1
		STA INTERRUPT_UPDATE_ADDRESS_2
		STA INTERRUPT_UPDATE_ADDRESS_3
		STA INTERRUPT_UPDATE_ADDRESS_4
		STA INTERRUPT_UPDATE_ADDRESS_5
		STA INTERRUPT_UPDATE_ADDRESS_6
		STA INTERRUPT_UPDATE_ADDRESS_7

		RTS

initTitleScreen:
		LDA #0
		STA var::text_current_option

initTitleScreenAtOption:
		JSR initTextScreen

		LDA #.LOBYTE(TEXT_TITLES)
		STA var::text_ptr
		LDA #.HIBYTE(TEXT_TITLES)
		STA var::text_ptr_hi
		JSR printLines

		LDA #.LOBYTE(TEXT_TITLES_OPTIONS)
		STA var::text_option_ptr
		LDA #.HIBYTE(TEXT_TITLES_OPTIONS)
		STA var::text_option_ptr_hi
		JSR initOptions

;		LDA #0
;		STA var::player_x_pxl
;		STA var::player_y_pxl
;
;		LDA #%00000111
;		STA var::sprite_enable
;		LDA var::colour_do
;		STA var::player_colour
;		LDA #0
;		STA var::num_baddies
;		LDX #0
;		STX var::player_sprite_index
;		LDX #NUM_ENTITY_SPRITES
;		STX var::baddy_sprite_index

		LDA #GAME_STATE_TITLE_SCREEN
		STA var::game_state

		RTS

initInstructions:
		LDA #0
		STA var::text_current_option
		LDA #BG_HILIGHT
		STA var::text_suboption_hilight

initInstructionsAgain:
	;option variables reused for instruction page.
		JSR initTextScreen

		LDA #.LOBYTE(TEXT_INSTRUCTIONS_PAGES)
		STA var::text_option_ptr
		LDA #.HIBYTE(TEXT_INSTRUCTIONS_PAGES)
		STA var::text_option_ptr_hi
		JSR setTextPtrFromOption
		JSR printLines

		LDA var::text_current_option
		ASL
		ORA var::text_settings_colours
		ASL
		ORA var::text_settings_rotors
		EOR #1
		ASL
		TAX

		LDA TEXT_INSTRUCTIONS_ALT, X
		STA var::text_ptr
		LDA TEXT_INSTRUCTIONS_ALT + 1, X
		STA var::text_ptr_hi
		JSR printLines
	
		LDA #.LOBYTE(TEXT_INSTRUCTIONS_NAVIGATION)
		STA var::text_ptr
		LDA #.HIBYTE(TEXT_INSTRUCTIONS_NAVIGATION)
		STA var::text_ptr_hi
		JSR printLines
		
		LDA #1
		STA var::text_current_suboption

		JSR setSuboptionFromOption
		JSR setTextPtrFromSuboption
		JSR textHilight

		LDA #GAME_STATE_INSTRUCTIONS
		STA var::game_state

		LDA var::text_current_option
		CMP #5 
		BEQ @noSprite
		LSR
		CMP #1 
		BCS @sprite
	@noSprite:
		LDA #%00000000
		STA var::sprite_enable
		RTS

	@sprite:
		LDA #25 * 8
		STA var::player_x_pxl
		LDA #6 * 8
		STA var::player_y_pxl

		LDA #%00000010
		STA var::player_dirax
		LDA #%00000111
		STA var::sprite_enable
		LDA #0
		STA var::num_baddies
		LDX #0
		STX var::player_sprite_index
		LDX #NUM_ENTITY_SPRITES
		STX var::baddy_sprite_index

		; Set the colour from the 2nd bit of the option.
		LDA var::colour_do
		LDX var::text_current_option
		CPX #4
		BNE @do
		LDA var::colour_dont
	@do:
		STA var::player_colour

		RTS

initSettings:
		JSR initTextScreen

		LDA #.LOBYTE(TEXT_SETTINGS)
		STA var::text_ptr
		LDA #.HIBYTE(TEXT_SETTINGS)
		STA var::text_ptr_hi
		JSR printLines

		LDA #.LOBYTE(TEXT_SETTINGS_OPTIONS)
		STA var::text_option_ptr
		LDA #.HIBYTE(TEXT_SETTINGS_OPTIONS)
		STA var::text_option_ptr_hi

		;Always start at back.
		LDA #0
		STA var::text_current_option

		JSR initOptions

		LDA var::text_num_options
		STA var::text_current_option
		LDA #BG_SUBOPTION
		STA var::text_suboption_hilight

	@subOptionLoop:
		DEC var::text_current_option
		BEQ @finishedSuboptions 

		LDY var::text_current_option
		LDA var::text_settings_music - 1, Y
		STA var::text_current_suboption

		JSR setSuboptionFromOption
		JSR setTextPtrFromSuboption
		LDA var::text_suboption_hilight
		STA var::text_hilight_colour
		JSR textHilight

		JMP @subOptionLoop
	@finishedSuboptions:

		;Always start at back.
		LDA #0
		STA var::text_current_option

		LDA #24 * 8
		STA var::player_x_pxl
		LDA #3 * 8
		STA var::player_y_pxl
	
		LDA #0
		STA var::player_z_pxl
		STA var::old_player_z_pxl

		LDA #%00000010
		STA var::player_dirax
		LDA #%00000111
		STA var::sprite_enable
		LDA #0
		STA var::num_baddies
		LDX #0
		STX var::player_sprite_index
		LDX #NUM_ENTITY_SPRITES
		STX var::baddy_sprite_index

		LDA var::colour_dont
		STA var::player_colour
		LDA #PLAYER_STATE_DONT
		STA var::player_state

		LDA #GAME_STATE_SETTINGS
		STA var::game_state

		RTS

initGoodLuck:
		JSR initTextScreen

		LDA #.LOBYTE(TEXT_GOOD_LUCK)
		STA var::text_ptr
		LDA #.HIBYTE(TEXT_GOOD_LUCK)
		STA var::text_ptr_hi
		JSR printLines

		LDA GOOD_LUCK_FRAME_COUNT
		STA var::ending_frame_countdown

		LDA #GAME_STATE_GOOD_LUCK
		STA var::game_state

		RTS

initGameOver:
		JSR initTextScreen

		LDA #.LOBYTE(TEXT_GAME_OVER)
		STA var::text_ptr
		LDA #.HIBYTE(TEXT_GAME_OVER)
		STA var::text_ptr_hi
		JSR printLines

		LDA GAME_OVER_FRAME_COUNT
		STA var::ending_frame_countdown

		LDA #GAME_STATE_GAME_OVER
		STA var::game_state

		RTS

initCongratulations:
		JSR initTextScreen

		LDA #.LOBYTE(TEXT_CONGRATULATIONS)
		STA var::text_ptr
		LDA #.HIBYTE(TEXT_CONGRATULATIONS)
		STA var::text_ptr_hi
		JSR printLines

		LDA #10 * 8
		STA var::player_x_pxl
		LDA #10 * 8
		STA var::player_y_pxl
		LDA #15 * 8
		STA var::baddy_x_pxl
		LDA #10 * 8
		STA var::baddy_y_pxl
		
		LDA #0
		STA var::player_z_pxl
		STA var::old_player_z_pxl

		LDA #%00000000
		STA var::player_dirax
		LDA #%00110111
		STA var::sprite_enable
		LDA #1
		STA var::num_baddies
		LDX #0
		STX var::player_sprite_index
		LDX #NUM_ENTITY_SPRITES
		STX var::baddy_sprite_index

		LDA var::colour_do
		STA var::player_colour
		LDA #PLAYER_STATE_DONT
		STA var::player_state
		LDA #HEART_COLOUR
		STA var::baddy_colour
		LDA #FRAME_HEART
		STA var::baddy_frame

		LDA CONGRATULATIONS_FRAME_COUNT
		STA var::ending_frame_countdown

		LDA #GAME_STATE_CONGRATULATIONS
		STA var::game_state

		RTS

initCheat:
		JSR initTextScreen

		LDA #.LOBYTE(TEXT_CHEAT)
		STA var::text_ptr
		LDA #.HIBYTE(TEXT_CHEAT)
		STA var::text_ptr_hi
		JSR printLines

		LDA CHEAT_FRAME_COUNT
		STA var::ending_frame_countdown

		LDA #GAME_STATE_CHEAT
		STA var::game_state

		RTS

initCredits:
		JSR initTextScreen
		LDA #.LOBYTE(TEXT_CREDITS)
		STA var::text_ptr
		LDA #.HIBYTE(TEXT_CREDITS)
		STA var::text_ptr_hi
		JSR printLines

		LDA #.LOBYTE(TEXT_CREDITS_BACK)
		STA var::text_ptr
		LDA #.HIBYTE(TEXT_CREDITS_BACK)
		STA var::text_ptr_hi
		JSR textHilight

		LDA #GAME_STATE_CREDITS
		STA var::game_state

		RTS

;Move the screen and colour pointer to the position described by the screen
;coords
screenCoordsToTextScreenPtrs:
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
		ADC #.HIBYTE(TEXT_SCREEN_ADDRESS)
		STA var::screen_ptr_hi
		;TODO Probably not needed.
		CLC
		ADC #.HIBYTE(COLOUR_RAM) - .HIBYTE(TEXT_SCREEN_ADDRESS)
		STA var::colour_ptr_hi
		RTS

clearTextScreen:
		LDA #0
		STA var::screen_x
		LDA #0
		STA var::screen_y
	@rowLoop:
		JSR screenCoordsToTextScreenPtrs
		LDY #0
	@columnLoop:
		LDA #TEXT_SPACE
		STA (var::screen_ptr), Y
		LDA #TEXT_COLOUR_NORMAL
		STA (var::colour_ptr), Y
		INY
		CPY #SCREEN_WIDTH
		BNE @columnLoop
		
		INC var::screen_y
		LDA var::screen_y
		CMP #SCREEN_HEIGHT
		BNE @rowLoop
		RTS

printLines:
	@printALine:
		LDY #0
		LDA (var::text_ptr), Y
		BEQ @return
		STA var::screen_y
		INY
		LDA (var::text_ptr), Y
		STA var::screen_x
		JSR screenCoordsToTextScreenPtrs
		LDX #2
		JSR addXToTextPtr
		LDY #0
		LDA (var::text_ptr), Y
		TAY
		TAX
	@charLoop:
		LDA (var::text_ptr), Y
		STA (var::screen_ptr), Y
		CMP #'h'
		BEQ @heartColour
		CMP #'o'
		BEQ @heartColour
		CMP #'u'
		BMI @normalColour
	@rotorColour:
		LDA #ROTOR_COLOUR
		JMP @setColour
	@heartColour:
		LDA #TEXT_COLOUR_HEART
	@setColour:
		STA (var::colour_ptr),Y
	@normalColour:
	@dec:
		DEY
		BNE @charLoop

		INX
		JSR addXToTextPtr
		
		JMP @printALine

	@return:
		RTS

textHilight:
	;At screen_x, screen_y with length in text_hilight_length
		LDY #0
		LDA (var::text_ptr), Y
		STA var::screen_y
		INY
		LDA (var::text_ptr), Y
		STA var::screen_x
		INY
		LDA (var::text_ptr), Y
		PHA

		DEC var::screen_x
		DEC var::screen_y
		JSR screenCoordsToTextScreenPtrs

		LDY #1
		LDA #'{'
		ORA var::text_hilight_colour
		STA (var::screen_ptr), Y
		LDA #BORDER_COLOUR
		STA (var::colour_ptr), Y

		PLA
		PHA
		TAX

		LDY #2
	@charLoop1:
		LDA #'_'
		ORA var::text_hilight_colour
		STA (var::screen_ptr), Y
		LDA #BORDER_COLOUR
		STA (var::colour_ptr), Y
		INY
		DEX
		BNE @charLoop1

		LDA #'}'
		ORA var::text_hilight_colour
		STA (var::screen_ptr), Y
		LDA #BORDER_COLOUR
		STA (var::colour_ptr), Y
			
		PLA
		PHA
		TAX

		LDY #SCREEN_WIDTH + 1
		LDA #'['
		ORA var::text_hilight_colour
		STA (var::screen_ptr), Y
		LDA #BORDER_COLOUR
		STA (var::colour_ptr), Y

		INY 
	@charLoop2:
		LDA (var::screen_ptr), Y
		AND #%00111111
		ORA var::text_hilight_colour
		STA (var::screen_ptr), Y
		INY
		DEX
		BNE @charLoop2

		LDA #']'
		ORA var::text_hilight_colour
		STA (var::screen_ptr), Y
		LDA #BORDER_COLOUR
		STA (var::colour_ptr), Y

		LDY #(SCREEN_WIDTH * 2) + 1
		LDA #'%'
		ORA var::text_hilight_colour
		STA (var::screen_ptr), Y
		LDA #BORDER_COLOUR
		STA (var::colour_ptr), Y

		PLA
		TAX

		LDY #(SCREEN_WIDTH * 2) + 2
	@charLoop3:
		LDA #'^'
		ORA var::text_hilight_colour
		STA (var::screen_ptr), Y
		LDA #BORDER_COLOUR
		STA (var::colour_ptr), Y
		INY
		DEX
		BNE @charLoop3

		LDA #'|'
		ORA var::text_hilight_colour
		STA (var::screen_ptr), Y
		LDA #BORDER_COLOUR
		STA (var::colour_ptr), Y
	
		RTS

textCheckKeyboard:
		LDA #0
		STA var::key_event

		; This seems to reset key detection. No time to understand why :-)
		LDA #%11111111
		STA CIA1_PORT_A

		;Check joystick 2
		LDA CIA1_PORT_A
		AND #%00011111
		EOR #%00011111
		BEQ @noJoystickEventInPort2
		STA var::key_event
		JMP @checkEventIsNew

	@noJoystickEventInPort2:
		;Check joystick 1
		LDA #%11111111
		STA CIA1_PORT_A
		LDA CIA1_PORT_B
		AND #%00011111
		EOR #%00011111
		BEQ @noJoystickEvent
		STA var::key_event
		JMP @checkEventIsNew

	@noJoystickEvent:
		LDA #(~KEYBOARD_COLUMN_UPDOWN & 255)
		STA CIA1_PORT_A
		LDA CIA1_PORT_B
		AND #KEYBOARD_ROW_UPDOWN
		BNE @notDown
		LDA #JOYSTICK_BIT_DOWN
		STA var::key_event
		JMP @checkShift

	@notDown:
		LDA #(~KEYBOARD_COLUMN_LEFTRIGHT & 255)
		STA CIA1_PORT_A
		LDA CIA1_PORT_B
		AND #KEYBOARD_ROW_LEFTRIGHT
		BNE @notRight
		LDA #JOYSTICK_BIT_RIGHT
		STA var::key_event

	@checkShift:
		LDA #(~KEYBOARD_COLUMN_LSHIFT & 255)
		STA CIA1_PORT_A
		LDA CIA1_PORT_B
		AND #KEYBOARD_ROW_LSHIFT
		BEQ @shifted

		LDA #(~KEYBOARD_COLUMN_RSHIFT & 255)
		STA CIA1_PORT_A
		LDA CIA1_PORT_B
		AND #KEYBOARD_ROW_RSHIFT
		BNE @notShifted

	@shifted:
		LSR var::key_event

	@notRight:
	@notShifted:
		LDA #(~KEYBOARD_COLUMN_SPACE & 255)
		STA CIA1_PORT_A
		LDA CIA1_PORT_B
		AND #KEYBOARD_ROW_SPACE
		BEQ @fire

		LDA #(~KEYBOARD_COLUMN_RETURN & 255)
		STA CIA1_PORT_A
		LDA CIA1_PORT_B
		AND #KEYBOARD_ROW_RETURN
		BNE @notFire
	
	@fire:
		LDA var::key_event
		ORA #JOYSTICK_BIT_FIRE
		STA var::key_event

	@notFire:
	@checkEventIsNew:
		LDA var::key_event
		CMP var::key_state
		STA var::key_state
		BNE @newEvent
	@noKeysAreDown:
		LDA #0
		STA var::key_event
	@newEvent:
		RTS

addXToTextPtr:
		TXA
		CLC
		ADC var::text_ptr
		STA var::text_ptr
		LDA #0
		ADC var::text_ptr_hi
		STA var::text_ptr_hi
		RTS

stepTitleScreen:
		JSR updateTextAnimations
		JSR textCheckKeyboard
		JSR processOptions

		LDA var::key_event
		CMP #JOYSTICK_BIT_FIRE
		BNE @notFire

		LDA var::text_current_option
		BEQ @newGame
		CMP #1
		BEQ @instructions
		CMP #2
		BEQ @settings
		;CMP #3
		;BEQ @credits

	@credits:
		JSR startStateTransition
		JSR initCredits
		JSR endStateTransition
		RTS


	@settings:
		JSR startStateTransition
		JSR initSettings
		JSR endStateTransition
		RTS

		
	@notFire:
		RTS

	@newGame:
		JSR startStateTransition
		JSR initGoodLuck
		JSR endStateTransition
		RTS

	@instructions:
		JSR startStateTransition
		JSR initInstructions
		JSR endStateTransition
		RTS

stepInstructions:
		JSR updateTextAnimations

		JSR playerSound_preUpdate
		LDA var::text_current_option
		CMP #4
		BEQ @bouncing
		CMP #2
		BEQ @wobbling
		CMP #3
		BNE @noSprites
		
	@wobbling:
		LDA #PLAYER_STATE_DO
		STA var::player_state
		JSR updateWobblingPlayer
		JSR drawEntity
		JSR playerSound_postUpdate
		JMP @common

	@bouncing:
		LDA #PLAYER_STATE_DONT
		STA var::player_state
		JSR updateBouncingPlayer
		JSR drawEntity
		JSR playerSound_postUpdate
		
	@common:
		JSR updateEntityInterrupts
	@noSprites:
		JSR textCheckKeyboard
		JSR processSuboptions

		LDA var::key_event
		CMP #JOYSTICK_BIT_FIRE
		BNE @notFire

		JSR startStateTransition

		LDA var::text_current_suboption
		BNE @nextPage
	@prevPage:
		LDX var::text_current_option
		BEQ @backToTitles
		DEX
		STX var::text_current_option
		JMP @instructionPage

	@nextPage:
		LDX var::text_current_option
		INX
		STX var::text_current_option
		CPX #6
		BEQ @backToTitles

	@instructionPage:

		JSR initInstructionsAgain
		JSR endStateTransition
		RTS
		
	@backToTitles:
		LDA #1
		STA var::text_current_option
		JSR initTitleScreenAtOption
		JSR endStateTransition
		RTS

	@notFire:
		RTS
		
stepSettings:
		JSR updateTextAnimations

		;Swap player colour on bounce
		LDA var::old_player_z_pxl
		BEQ @noSwap
		LDA var::player_z_pxl
		BNE @noSwap
		LDA var::player_colour
		CMP var::colour_dont
		BNE @do

		LDA var::colour_do
		JMP @common
	@do:
		LDA var::colour_dont
		
	@common:
		STA var::player_colour

	@noSwap:
		JSR playerSound_preUpdate
		JSR updateBouncingPlayer
		JSR playerSound_postUpdate
		JSR drawEntity
		JSR updateEntityInterrupts
		JSR textCheckKeyboard

		LDA var::text_current_option
		STA var::option_tmp
		
		JSR processOptions

		LDA var::text_current_option
		BEQ @noSuboptions

		CMP var::option_tmp
		BEQ @noOptionChange

		TAY
		LDA var::text_settings_music - 1, Y
		STA var::text_current_suboption
		JSR setSuboptionFromOption

	@noOptionChange:
		LDA var::text_current_suboption
		STA var::option_tmp

		JSR processSuboptions

		LDA var::text_current_suboption
		CMP var::option_tmp
		BEQ @noSuboptionChange

		LDY var::text_current_option
		STA var::text_settings_music - 1, Y

		CPY #1
		BNE @notMusic
		LDA var::text_settings_music
		JSR music
	@notMusic:

		CPY #2
		BNE @notSpeed
		JSR setSpeed
		JMP @afterSuboption
	@notSpeed:

		CPY #3
		BNE @notColours
		CMP #0
		BNE @alternativeColours
	@normalColours:
		JSR setNormalColourScheme
		JMP @afterSuboption
	@alternativeColours:
		JSR setAlternativeColourScheme
		JMP @afterSuboption
	@notColours:

		CPY #4
		BNE @notRotors
		CMP #0
		BNE @rotorsFling
	@rotorsTwist:
		LDA #255
		JMP @rotorsCommon
	@rotorsFling:
		LDA #1
	@rotorsCommon:
		STA var::rotors_direction
		JMP @afterSuboption
	@notRotors:

	@noSuboptions:
	@noSuboptionChange:

		LDA var::key_event
		CMP #JOYSTICK_BIT_FIRE
		BNE @notFire

		LDA var::text_current_option
		BEQ @backToTitles
		
	@afterSuboption:
	@notFire:
		RTS

	@backToTitles:
		JSR startStateTransition
		LDA #2
		STA var::text_current_option
		JSR initTitleScreenAtOption
		JSR endStateTransition
		RTS

stepGoodLuck:
		DEC var::ending_frame_countdown
		BNE @return

		JSR startStateTransition
		JSR initGame
		JSR endStateTransition
		RTS

	@return:
		RTS	

stepGameOver:
		DEC var::ending_frame_countdown
		BNE @return

		JSR startStateTransition
		JSR initTitleScreen
		JSR endStateTransition
		RTS

	@return:
		RTS	

stepCongratulations:
		LDA var::ending_frame_countdown
		BEQ @waitForKey
		DEC var::ending_frame_countdown
		BNE @continue

	@waitForKey:
		JSR textCheckKeyboard
		LDA var::key_event
		BEQ @continue

		JSR startStateTransition
		JSR initTitleScreen
		JSR endStateTransition
		RTS

	@continue:
		JSR playerSound_preUpdate
		JSR updateBouncingPlayer
		JSR drawEntity

		LDA var::static_pxl
		CLC
		ADC #20
		CMP #40
		BCC @justStore
		SEC
		SBC #40
	@justStore:
		TAY
		LDA LUT_PLAYER_Z_OFFSETS_STARTING, Y
		STA var::baddy_z_pxl

		LDA #var::baddy_x_pxl
		STA var::entity_0ptr

		JSR drawEntity

		JSR playerSound_postUpdate
		JSR updateEntityInterrupts
	@return:
		RTS	

stepCredits:
		JSR updateTextAnimations
		JSR textCheckKeyboard
		JSR processSuboptions

		LDA var::key_event
		CMP #JOYSTICK_BIT_FIRE
		BNE @return

		JSR startStateTransition
		LDA #3
		STA var::text_current_option
		JSR initTitleScreenAtOption
		JSR endStateTransition
		
	@return:
		RTS

stepCheat:
		DEC var::ending_frame_countdown
		BNE @return

		JSR startStateTransition
		JSR initTitleScreen
		JSR endStateTransition
	@return:
		RTS

updateTextAnimations:
		CLC
		LDA VAR_ANIMATION_ADVANCE
		LSR
		ADC var::animation_countdown
		STA var::animation_countdown
		BCC @return

		INC var::animation_counter
		LDA var::animation_counter
		AND #%00000111
		TAX
		LDA LUT_TEXT_MEMORY_POINTERS, X
		STA var::memory_pointers_top
		STA var::memory_pointers_bottom

		LDX var::game_state
		CPX #GAME_STATE_INSTRUCTIONS
		BNE @notInstructions

	@instructions:
		LDA var::animation_counter
		AND #%00000011
		ORA #%00000100

		ASL
		ORA #(TEXT_SCREEN_MEMORY << 4)
		STA var::memory_pointers_top
	@notInstructions:
	@return:
		RTS

