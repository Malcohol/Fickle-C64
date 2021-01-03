; Some vars are in the zero page and other are put after the stack.
; A chunk of the zero page is kept for the interrupt table.

.scope var

	.segment "SEG_ZPINIT" : zeropage

memcopy_source_ptr: 	.word 0
memcopy_target_ptr:		.word 0
charblock_source_ptr:	.word 0
memcopy_target_offset_hi: .byte 0

memcopy_source_ptr_hi    = memcopy_source_ptr + 1
memcopy_target_ptr_hi    = memcopy_target_ptr + 1
charblock_source_ptr_hi  = charblock_source_ptr + 1

memcopy_num_bytes:		.byte 0
memcopy_num_bytes_hi:	.byte 0

; A bitfield which selects the target block to which the characters are written
charblock_num_chars:	.byte 0
charblock_filter:		.byte 0
charblock_target_char:	.byte 0
charBlock_temp:			.byte 0

	.segment "SEG_ZP" : zeropage

; The reason for setting up variables like this, is that the assembler
; exports useful symbols for vice to use.

; POINTERS: These have to be in the zero page.

screen_ptr:				.word 0
colour_ptr:				.word 0
; A pointer into the level data
level_data_ptr:			.word 0
; Index in the frame table.
sprite_frame_ptr:		.word 0
barrier_program_ptr:	.word 0
barrier_program_ptr2:	.word 0
;Can probably share with e.g. level ptr.
text_ptr:				.word 0
text_option_ptr:		.word 0
text_suboption_ptr:		.word 0

screen_ptr_hi            = screen_ptr + 1
colour_ptr_hi            = colour_ptr + 1
level_data_ptr_hi        = level_data_ptr + 1
sprite_frame_ptr_hi      = sprite_frame_ptr + 1
barrier_program_ptr_hi   = barrier_program_ptr + 1
barrier_program_ptr2_hi  = barrier_program_ptr2 + 1
text_ptr_hi              = text_ptr + 1
text_option_ptr_hi       = text_option_ptr + 1
text_suboption_ptr_hi    = text_suboption_ptr + 1

; ENTITY STRUCTS: These have to be in the zero page.

; PLAYER ENTITY
; The x and y coordinate of the 32 x 24 pixel rectangle occupied by the player,
; within the level.
player_x_pxl:			.byte 0
player_y_pxl:			.byte 0
; The height of the player off the ground.
player_x_subpxl:		.byte 0
player_y_subpxl:		.byte 0
player_z_pxl:			.byte 0
player_dir:				.byte 0
player_axis:			.byte 0
player_dirax:			.byte 0
; 0 if player corresponds to sprites 0-3, 4 if player corresponds to sprites 4-7.
player_sprite_index:	.byte 0
player_colour:			.byte 0
player_frame:			.byte 0
player_speed_pxl:		.byte 0, 0
player_speed_subpxl:	.byte 0, 0

;0 or 1
num_baddies:			.byte 0
; BADDY ENTITY
baddy_x_pxl:			.byte 0
baddy_y_pxl:			.byte 0
baddy_x_subpxl:			.byte 0
baddy_y_subpxl:			.byte 0
baddy_z_pxl:			.byte 0
baddy_dir:				.byte 0
baddy_axis:				.byte 0
baddy_dirax:			.byte 0
; 0 if baddy corresponds to sprites 0-2, 3 if baddy corresponds to sprites 3-6.
baddy_sprite_index:		.byte 0
baddy_colour:			.byte 0
baddy_frame:			.byte 0
baddy_speed_pxl:		.byte 0, 0
baddy_speed_subpxl:		.byte 0, 0

; The x and y coord in the level data (both 0..5)
floor_x:				.byte 0
floor_y:				.byte 0

; The byte in the level data.
floor_data:				.byte 0

; This is floor_data & 15
floor_tile:				.byte 0

barrier_index:			.byte 0
; The barrier data byte, stored after the level.
barrier_data:			.byte 0

; The barrier type (0 = door, 1..3 = barrier)
wall_type:				.byte 0
wall_axis:				.byte 0

screen_x:				.byte 0
screen_y:				.byte 0
screen_offset:			.byte 0

tile_x:					.byte 0
tile_y:					.byte 0

tiledata_index:			.byte 0

walldata_edge_index:	.byte 0
walldata_top_index:		.byte 0

level_num:				.byte 0
game_state:				.byte 0

animation_countdown:	.byte 0
animation_counter:		.byte 0

spike_overlap_index_0:	.byte 0
spike_overlap_index_1:	.byte 0

baddy_state:			.byte 0
baddy_floor_lower:		.byte 0	;Lower limit for the baddy in floor tiles
baddy_floor_upper:		.byte 0	;Upper limit for the baddy in floor tiles

;See constants.
player_state:			.byte 0
;The player's state in the last frame.
player_state_old:		.byte 0

; 0 if player corresponds to sprites 0-2, 3 if player corresponds to sprites 3-6.
sprite_index:			.byte 0
sprite_colour:			.byte 0

sprite_enable:			.byte 0

frame_sprite_index:		.byte 0
frame_x_pxl:			.byte 0
frame_y_pxl:			.byte 0

;The pixel offset of the player within the floor tile.
;These only apply to the entity's current axis.
entity_pxl_remainder:	.byte 0
entity_pxl_clamped:		.byte 0

entity_0ptr:			.byte 0
;mod_result:				.byte 0

num_keys:				.byte 0
num_lives:				.byte 0

num_teleports:			.byte 0
num_switches:			.byte 0 ; only used during level drawing.
teleport_0_x:			.byte 0		;X coord of the first teleport
teleport_0_y:			.byte 0		;Y coord of the first teleport
teleport_1_x:			.byte 0		;X coord of the second teleport
teleport_1_y:			.byte 0		;Y coord of the second teleport

key_event:				.byte 0
key_state:				.byte 0

interrupt_routine_index:	.byte 0

;The row of the hud
hud_row:				.byte 0
;The three bytes to draw
hud_row_bytes:			.byte 0, 0, 0

hud_source_index:		.byte 0

life_colour_0:			.byte 0
life_colour_1:			.byte 0
life_colour_2:			.byte 0
life_colour_3:			.byte 0

key_colour_0:			.byte 0
key_colour_1:			.byte 0
key_colour_2:			.byte 0
key_colour_3:			.byte 0

timebar_colour:			.byte 0

timebar_hud_row:		.byte 0
timebar_subpxl:			.byte 0

;
static_pxl:		.byte 0
static_subpxl:	.byte 0
half_speed_pxl:	.byte 0
half_speed_subpxl: .byte 0

finishing_heart_index:	.byte 0
finishing_rotation_index: .byte 0

sprite_1_interrupt_counter_0: .byte 0
sprite_1_interrupt_counter_1: .byte 0
								.byte 0 ;dummy
sprite_4_interrupt_counter_0: .byte 0
sprite_4_interrupt_counter_1: .byte 0

exploding_transition_countdown: .byte 0

;non-zero if the entities were colliding in the last frame.
were_colliding: 		.byte 0

ending_frame_countdown:	.byte 0

;setup barrier table.
switch_state:			.byte 0
char_to_draw:			.byte 0
colour_to_draw:			.byte 0
text_hilight_colour:	.byte 0

text_current_option:	.byte 0
text_num_options:		.byte 0

text_current_suboption:	.byte 0
text_num_suboptions:	.byte 0
text_suboption_hilight:	.byte 0
text_settings_music:	.byte 0
text_settings_speed:	.byte 0
text_settings_colours:	.byte 0
text_settings_rotors:	.byte 0

;0 if PAL.
region_speed_offset:	.byte 0

old_player_z_pxl:	.byte 0
old_player_frame:	.byte 0
old_baddy_z_pxl:	.byte 0

is_cheating:			.byte 0
has_cheated:			.byte 0
is_dying:				.byte 0

old_sound:				.byte 0

in_state_transition:	.byte 0
memory_pointers_top:	.byte 0
memory_pointers_bottom:	.byte 0

;+1 or -1
rotors_direction:		.byte 0

; Temporaries

counter:				.byte 0
multTemp:				.byte 0
mask:					.byte 0
overflow:				.byte 0
test_bits:				.byte 0
probed_colour:			.byte 0
barrier_tmp:			.byte 0
frame_tmp:				.byte 0
pxl_tmp:				.byte 0
subpxl_tmp:				.byte 0
bounce_pxl:				.byte 0
hud_row_ptr:			.byte 0
hud_row_ptr_hi:			.byte 0
hud_counter:			.byte 0
draw_hud_counter:		.byte 0
sprite_source_index:	.byte 0
finishing_tmp:			.byte 0
option_tmp:				.byte 0

.assert * <= ZP_LUT_INTERRUPT_ROUTINES, error, "Too many zp vars"

; Interrupt table goes somewhere here.

	.segment "SEG_VARS"

; Rotor 

; These are colour_ptr_hi, colour_ptr and colour.
; The end of the list is when colour_ptr_hi = 0.

spike_overlap_list_0:	
						.byte 0, 0, 0
						.byte 0, 0, 0
						.byte 0, 0, 0
						.byte 0, 0, 0
						.byte 0, 0, 0
						.byte 0, 0, 0

spike_overlap_list_1:
						.byte 0, 0, 0
						.byte 0, 0, 0
						.byte 0, 0, 0
						.byte 0, 0, 0
						.byte 0, 0, 0
						.byte 0, 0, 0
						.byte 0, 0, 0


barrier_program_char_0:
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0

barrier_program_colour_0:
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0

barrier_program_char_1:
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0

barrier_program_colour_1:
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0
						.byte 0, 0, 0, 0, 0


switch_colour_ptr:		.byte 0, 0, 0, 0
switch_colour_ptr_hi:	.byte 0, 0, 0, 0

colour_table:
colour_do:			.byte 0
colour_do_bright:	.byte 0
colour_dont:		.byte 0
colour_dont_bright:	.byte 0
colours_player_dark:	.byte 0
colours_player_white:	.byte 0
colours_player_grey:	.byte 0
colour_wall_top:	.byte 0
colour_wall_edge:	.byte 0

overlap_index:			.byte 0
overlap_index_A:		.byte 0
overlap_index_B:		.byte 0
overlap_colour_A:		.byte 0
overlap_colour_B:		.byte 0

.endscope
SIZE_OF_BARRIER_TABLE = var::barrier_program_colour_0 - var::barrier_program_char_0
SIZE_OF_SPIKE_OVERLAP_LIST = var::spike_overlap_list_1 - var::spike_overlap_list_0
SIZE_OF_SWITCH_TABLE = var::switch_colour_ptr_hi - var::switch_colour_ptr

