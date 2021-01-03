VIC_BANK = 1
VIC_BASE = VIC_BANK * $4000

SCREEN_MEMORY = 1

SCREEN_WIDTH = 40
SCREEN_HEIGHT = 25

SCREEN_ADDRESS = VIC_BASE + (SCREEN_MEMORY * $400)

;Holds 8 single sprites between chars and screen
SPRITE_ADDRESS_0 = VIC_BASE + ($800 * 0) + $200
;Each bank holds 4 quad sprites or 24 single sprites.
SPRITE_ADDRESS_1 = VIC_BASE + ($800 * 1) + $200
SPRITE_ADDRESS_2 = VIC_BASE + ($800 * 4) + $200
SPRITE_ADDRESS_3 = VIC_BASE + ($800 * 5) + $200
SPRITE_ADDRESS_4 = VIC_BASE + ($800 * 6) + $200
;SPRITE_ADDRESS_5 = VIC_BASE + ($800 * 7) + $200

;These banks reserved for the HUD.
HUD_RIGHT_ADDRESS = VIC_BASE + ($800 * 2) + $200
HUD_LEFT_ADDRESS = VIC_BASE + ($800 * 3) + $200

HUD_LEFT_SPRITE_INDEX = (HUD_LEFT_ADDRESS - VIC_BASE) / 64
HUD_RIGHT_SPRITE_INDEX = (HUD_RIGHT_ADDRESS - VIC_BASE) / 64
HUD_MEMORY_SIZE = 10 * 2 * 64
HUD_SYMBOL_HEIGHT = 9

SPRITE_0_INDEX = SCREEN_ADDRESS + 1016
SPRITE_1_INDEX = SCREEN_ADDRESS + 1017
SPRITE_2_INDEX = SCREEN_ADDRESS + 1018
SPRITE_3_INDEX = SCREEN_ADDRESS + 1019
SPRITE_4_INDEX = SCREEN_ADDRESS + 1020
SPRITE_5_INDEX = SCREEN_ADDRESS + 1021
SPRITE_6_INDEX = SCREEN_ADDRESS + 1022
SPRITE_7_INDEX = SCREEN_ADDRESS + 1023

TEXT_SPRITE_0_INDEX = TEXT_SCREEN_ADDRESS + 1016
TEXT_SPRITE_1_INDEX = TEXT_SCREEN_ADDRESS + 1017
TEXT_SPRITE_2_INDEX = TEXT_SCREEN_ADDRESS + 1018
TEXT_SPRITE_3_INDEX = TEXT_SCREEN_ADDRESS + 1019
TEXT_SPRITE_4_INDEX = TEXT_SCREEN_ADDRESS + 1020
TEXT_SPRITE_5_INDEX = TEXT_SCREEN_ADDRESS + 1021
TEXT_SPRITE_6_INDEX = TEXT_SCREEN_ADDRESS + 1022
TEXT_SPRITE_7_INDEX = TEXT_SCREEN_ADDRESS + 1023


NUM_ENTITY_SPRITES = 3

BORDER_COLOUR = VIC_II_COLOUR_BLACK
FLOOR_COLOUR = VIC_II_COLOUR_BLACK
WALL_TOP_COLOUR = VIC_II_COLOUR_LIGHT_BLUE
WALL_EDGE_COLOUR = VIC_II_COLOUR_BLUE
ALT_WALL_TOP_COLOUR = VIC_II_COLOUR_GREY
ALT_WALL_EDGE_COLOUR = VIC_II_COLOUR_DARK_GREY
LEVER_COLOUR = VIC_II_COLOUR_LIGHT_GREY

KEY_COLOUR = VIC_II_COLOUR_YELLOW
NO_KEY_COLOUR = VIC_II_COLOUR_GREY
SWITCH_COLOUR = VIC_II_COLOUR_LIGHT_BROWN
HEART_COLOUR = VIC_II_COLOUR_PINK
TELEPORT_COLOUR = VIC_II_COLOUR_CYAN
TELEPORT_COLOUR_2 = VIC_II_COLOUR_LIGHT_BROWN
ROTOR_COLOUR = VIC_II_COLOUR_PURPLE
TRANSPARENT_COLOUR = %00010000
DOOR_TOP_COLOUR = VIC_II_COLOUR_LIGHT_BROWN
DOOR_EDGE_COLOUR = VIC_II_COLOUR_DARK_BROWN
LOCK_TOP_COLOUR = VIC_II_COLOUR_YELLOW
LOCK_EDGE_COLOUR = VIC_II_COLOUR_LIGHT_BROWN
BARRIER_OPEN_COLOUR = VIC_II_COLOUR_WHITE
BARRIER_CLOSED_TOP_COLOUR = VIC_II_COLOUR_WHITE
BARRIER_CLOSED_EDGE_COLOUR = VIC_II_COLOUR_GREY
BARRIER_ELECTRIFIED_TOP_COLOUR = VIC_II_COLOUR_WHITE
BARRIER_ELECTRIFIED_EDGE_COLOUR = VIC_II_COLOUR_GREY
TIMEBAR_COLOUR = VIC_II_COLOUR_CYAN
TIMEBAR_COLOUR_WARNING = VIC_II_COLOUR_RED
SMOKE_COLOUR = VIC_II_COLOUR_LIGHT_GREY
PLAYER_BADDY_TOUCH_COLOUR = VIC_II_COLOUR_LIGHT_GREY


BG_FLOOR = BG_COLOUR_0
BG_WALL_TOP = BG_COLOUR_1
BG_WALL_EDGE = BG_COLOUR_2
BG_OTHER = BG_COLOUR_3

NUM_GAME_COLUMNS = 6
NUM_GAME_ROWS = 6
TILE_WIDTH = 4
TILE_HEIGHT = 3
GUTTER_WIDTH = 1
GUTTER_HEIGHT = 1
TILE_HORIZ_INCREMENT = TILE_WIDTH + GUTTER_WIDTH
TILE_VERT_INCREMENT = TILE_HEIGHT + GUTTER_HEIGHT

LEVEL_WIDTH = TILE_HORIZ_INCREMENT * NUM_GAME_COLUMNS
LEVEL_HEIGHT = TILE_VERT_INCREMENT * NUM_GAME_COLUMNS
LEVEL_HORIZ_OFFSET = ((SCREEN_WIDTH - LEVEL_WIDTH) / 2) - 2

AXIS_HORIZONTAL	= 0
AXIS_VERTICAL 	= 1
DIR_BACK 	= -1 ;left or up
DIR_FORWARD 	= 1  ;right or down

;This is not a valid barrier since the (x,y) encoding maxes out at 29 << 3, so the
;highest valid barrier would be %11101111
BARRIER_TERMINATOR = %11110000

NUM_LEVELS = 15
HEARTBAR_Y = ((SCREEN_HEIGHT * 8) - (NUM_LEVELS * (HUD_SYMBOL_HEIGHT + 1))) / 2

TIMEBAR_Y = HEARTBAR_Y
TIMEBAR_HEIGHT = (NUM_LEVELS * (HUD_SYMBOL_HEIGHT + 1))
TIMEBAR_FIRST_ROW = TIMEBAR_Y + 1
TIMEBAR_LAST_ROW = TIMEBAR_Y + TIMEBAR_HEIGHT - 2
TIMEBAR_WARNING_ROW = TIMEBAR_LAST_ROW - (TIMEBAR_HEIGHT / 10)
TIMEBAR_NUM_CHARS = NUM_LEVELS
;3/2 * 1/50 * 146/118 (146/118 is <C64 timebar pxls>/<VIC20 timebar pxls>))

TOTAL_NUM_SPARE_LIVES = 4
TOTAL_NUM_LIVES = TOTAL_NUM_SPARE_LIVES + 1
NO_LIFE_COLOUR = VIC_II_COLOUR_DARK_GREY

TOTAL_NUM_KEYS = TOTAL_NUM_LIVES


SPRITE_X_OFFSET = 24
SPRITE_Y_OFFSET = 50

SPRITE_X_LEVEL_OFFSET = 64 - 4
SPRITE_Y_LEVEL_OFFSET = 50

;Amount by which a double sprite starts above the entities y coord.
SPRITE_Y_ADJUST = 3

KEY_PROBE = (SCREEN_WIDTH * 3) + 2
SWITCH_PROBE = (SCREEN_WIDTH * 2) + 2

PLAYER_STATE_TO_DO   = 0
PLAYER_STATE_DO      = 1
PLAYER_STATE_TO_DONT = 2
PLAYER_STATE_DONT    = 3
PLAYER_STATE_START   = 4
PLAYER_STATE_BADDY_TOUCH = 5
PLAYER_STATE_FINISH = 6
PLAYER_STATE_EXPLODING = 7
PLAYER_STATE_ELECTRIFIED_DO = 8
PLAYER_STATE_ELECTRIFIED_DONT = 9

BADDY_STATE_NORMAL   = 0
BADDY_STATE_TOUCHED  = 1

GAME_STATE_PLAYING_LEVEL  = 0
GAME_STATE_LEVEL_ENDING   = 1
GAME_STATE_LEVEL_COMPLETE = 2
GAME_STATE_LEVEL_FAILED   = 3
GAME_STATE_TITLE_SCREEN = 4
GAME_STATE_PLAYING = 5
GAME_STATE_INSTRUCTIONS = 6
GAME_STATE_SETTINGS = 7
GAME_STATE_GOOD_LUCK = 8
GAME_STATE_GAME_OVER = 9
GAME_STATE_CONGRATULATIONS = 10
GAME_STATE_CREDITS = 11
GAME_STATE_CHEAT = 12

COLOURS_DO 				= 0
COLOURS_DO_BRIGHT 		= 1
COLOURS_DONT 			= 2
COLOURS_DONT_BRIGHT 	= 3
COLOURS_PLAYER_DARK 	= 4
COLOURS_PLAYER_WHITE 	= 5
COLOURS_PLAYER_GREY 	= 6


FACE_COLOUR = VIC_II_COLOUR_BLACK

BADDY_COLOUR = VIC_II_COLOUR_WHITE

ENTITY_X_PXL = 0
ENTITY_Y_PXL = 1
ENTITY_X_SUBPXL = 2
ENTITY_Y_SUBPXL = 3
ENTITY_Z_PXL = 4
ENTITY_DIR = 5
ENTITY_AXIS = 6
ENTITY_DIRAX = 7
ENTITY_SPRITE_INDEX = 8
ENTITY_COLOUR = 9
ENTITY_SPRITE_FRAME = 10
ENTITY_HORIZ_SPEED_PXL = 11
ENTITY_VERT_SPEED_PXL = 12
ENTITY_HORIZ_SPEED_SUBPXL = 13
ENTITY_VERT_SPEED_SUBPXL = 14

ENTITY_COLLISION_WIDTH = 30
ENTITY_COLLISION_HEIGHT = 20

HUD_X_OFFSET = 9
HUD_LEFT_X_POS = SPRITE_X_OFFSET + HUD_X_OFFSET
HUD_RIGHT_X_POS = .LOBYTE(SPRITE_X_OFFSET + (SCREEN_WIDTH * 8) - 24 + 1 - HUD_X_OFFSET)

TEXT_VIC_BANK = 0
TEXT_VIC_BASE = TEXT_VIC_BANK * $4000
TEXT_SCREEN_MEMORY = 1
TEXT_SCREEN_ADDRESS = TEXT_VIC_BASE + (TEXT_SCREEN_MEMORY * $400)
TEXT_CHAR_MEMORY = 4
TEXT_CHAR_ADDRESS = TEXT_VIC_BASE + (TEXT_CHAR_MEMORY * $800)

TEXT_TERMINATOR = 0
TEXT_COLOUR_HEART = VIC_II_COLOUR_PINK
TEXT_COLOUR_NORMAL = VIC_II_COLOUR_WHITE
TEXT_BACKGROUND_1 = VIC_II_COLOUR_PINK
TEXT_BACKGROUND_2 = VIC_II_COLOUR_DARK_GREY
TEXT_BACKGROUND_3 = VIC_II_COLOUR_GREY

BG_NOHILIGHT = BG_COLOUR_0
BG_HILIGHT = BG_COLOUR_1
BG_SUBOPTION = BG_COLOUR_2
BG_SUBOPTION_HILIGHT = BG_COLOUR_3

;In subpxls.
FLOOR_ALIGNMENT_PRECISION = %11000000

SOUND_EFFECTS_CHANNEL = 14
