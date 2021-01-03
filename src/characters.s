	.segment "SEG_CHAR"
CHR_SOURCE:

;special.
CHR_GAP = CHR_BLOCK | BG_WALL_TOP

CHARBLOCK_1_0:
CHARBLOCK_1_TARGETCHAR = (* - CHR_SOURCE) / 8

CHR_CORNER_TL = (* - CHR_SOURCE) / 8
	.byte %00000011
	.byte %00011111
	.byte %00111111
	.byte %01111111
	.byte %01111111
	.byte %11111111
	.byte %11111111
	.byte %11111111

CHR_CORNER_TR = (* - CHR_SOURCE) / 8
	.byte %11000000
	.byte %11111000
	.byte %11111100
	.byte %11111110
	.byte %11111110
	.byte %11111111
	.byte %11111111
	.byte %11111111

CHR_CORNER_BL = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %01111111
	.byte %01111111
	.byte %00111111
	.byte %00011111
	.byte %00000011

CHR_CORNER_BR = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111110
	.byte %11111110
	.byte %11111100
	.byte %11111000
	.byte %11000000

;I needed one additional character, so the left and right and its opposite
;share an index (See CHAR_SWAPPED)
CHR_LEVER_T = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

CHR_LOCK_L = (* - CHR_SOURCE) / 8
	.byte %11111100
	.byte %11111000
	.byte %11111000
	.byte %11111100
	.byte %11111000
	.byte %11110000
	.byte %11100000
	.byte %11111111

CHR_LOCK_R = (* - CHR_SOURCE) / 8
	.byte %00111111
	.byte %00011111
	.byte %00011111
	.byte %00111111
	.byte %00011111
	.byte %00001111
	.byte %00000111
	.byte %11111111

CHR_DOOR_TOP = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %11111111
	.byte %11111111

CHR_DOOR_BOTTOM = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

CHR_BLOCK = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111

CHR_FIRST_SPIKE = (* - CHR_SOURCE) / 8


CHR_SPIKE_LEFT_B = (* - CHR_SOURCE) / 8
	.byte %11100000
	.byte %11000000
	.byte %10000000
	.byte %11100000
	.byte %11110000
	.byte %11000000
	.byte %11100000
	.byte %11000000


CHR_SPIKE_UP = (* - CHR_SOURCE) / 8
	.byte %01111110
	.byte %01101110
	.byte %00100100
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

CHR_SPIKE_RIGHT_M = (* - CHR_SOURCE) / 8
	.byte %00001111
	.byte %00000011
	.byte %00000111
	.byte %00000011
	.byte %00000001
	.byte %00000111
	.byte %00001111
	.byte %00000011

CHR_SPIKE_DOWN = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00100100
	.byte %01101110
	.byte %11111111

CHR_SPIKE_LEFT_M = (* - CHR_SOURCE) / 8
	.byte %11110000
	.byte %11000000
	.byte %11100000
	.byte %11000000
	.byte %10000000
	.byte %11100000
	.byte %11110000
	.byte %11000000
CHR_SPIKE_LEFT_T = (* - CHR_SOURCE) / 8
	.byte %10000000
	.byte %11100000
	.byte %11110000
	.byte %11000000
	.byte %11100000
	.byte %11000000
	.byte %10000000
	.byte %11100000



CHR_SPIKE_RIGHT_T = (* - CHR_SOURCE) / 8
	.byte %00000001
	.byte %00000111
	.byte %00001111
	.byte %00000011
	.byte %00000111
	.byte %00000011
	.byte %00000001
	.byte %00000111


CHR_SPIKE_RIGHT_B = (* - CHR_SOURCE) / 8
	.byte %00000111
	.byte %00000011
	.byte %00000001
	.byte %00000111
	.byte %00001111
	.byte %00000011
	.byte %00000111
	.byte %00000011



CHR_KEY_LEFT = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00111100
	.byte %01100110
	.byte %11000011
	.byte %11000011
	.byte %01100110
	.byte %00111100
	.byte %00000000

CHR_KEY_RIGHT = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %11111111
	.byte %11111111
	.byte %00011111
	.byte %00011011
	.byte %00000000

CHR_LEVER_BL = (* - CHR_SOURCE) / 8
	.byte %11000000
	.byte %10000000
	.byte %10000000
	.byte %10000000
	.byte %10000011
	.byte %10001100
	.byte %10110000
	.byte %11000000

CHR_LEVER_BM = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

CHR_LEVER_BR = (* - CHR_SOURCE) / 8
	.byte %00000011
	.byte %00000001
	.byte %00000001
	.byte %00000001
	.byte %11000001
	.byte %00110001
	.byte %00001101
	.byte %00000011

CHR_HEART_LEFT = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %01111111
	.byte %01111111
	.byte %00111111
	.byte %00011111
	.byte %00001111
	.byte %00000111
	.byte %00000011

CHR_HEART_RIGHT = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111110
	.byte %11111110
	.byte %11111100
	.byte %11111000
	.byte %11110000
	.byte %11100000
	.byte %11000000

CHR_HEART_BOTTOM_LEFT = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %01111111
	.byte %00111111
	.byte %00011111
	.byte %00001111
	.byte %00000111
	.byte %00000011

CHR_HEART_BOTTOM_RIGHT = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %11111110
	.byte %11111100
	.byte %11111000
	.byte %11110000
	.byte %11100000
	.byte %11000000

CHR_ROTOR_TL = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000001

CHR_ROTOR_TR = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %10000000

CHR_ROTOR_BL = (* - CHR_SOURCE) / 8
	.byte %00000001
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

CHR_ROTOR_BR = (* - CHR_SOURCE) / 8
	.byte %10000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

CHARBLOCK_1_NUMCHARS = (* - CHARBLOCK_1_0) / 8

CHARBLOCK_2_0:
CHARBLOCK_2_TARGETCHAR = (* - CHR_SOURCE) / 8

CHR_BARRIER_OPEN = (* - CHR_SOURCE) / 8
	.byte %10000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000001

CHR_BARRIER_OPEN_VERT_TOP = (* - CHR_SOURCE) / 8
	.byte %10000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000001
	.byte %10000000
	.byte %00000000

CHR_BARRIER_OPEN_VERT_BOTTOM = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000001
	.byte %10000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

CHARBLOCK_2_NUMCHARS = (* - CHARBLOCK_2_0) / 8

CHARBLOCK_ROTOR_0:
CHARBLOCK_ROTOR_TARGETCHAR_CLOCKWISE = (* - CHR_SOURCE) / 8

CHR_CLOCKWISE_0 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00001111
	.byte %00111111
	.byte %11111111
	.byte %11111111

CHR_CLOCKWISE_1 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %11110000
	.byte %00011100
	.byte %00000011
	.byte %00000001

CHR_CLOCKWISE_2 = (* - CHR_SOURCE) / 8
	.byte %00000011
	.byte %00000011
	.byte %00000111
	.byte %00000111
	.byte %00000110
	.byte %00000110
	.byte %00000011
	.byte %00000011

CHR_CLOCKWISE_3 = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

CHR_CLOCKWISE_4 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111

CHR_CLOCKWISE_5 = (* - CHR_SOURCE) / 8
	.byte %11000000
	.byte %11000000
	.byte %01100000
	.byte %01100000
	.byte %11100000
	.byte %11100000
	.byte %11000000
	.byte %11000000

CHR_CLOCKWISE_6 = (* - CHR_SOURCE) / 8
	.byte %10000000
	.byte %11000000
	.byte %00111000
	.byte %00001111
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

CHR_CLOCKWISE_7 = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %11111100
	.byte %11110000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

CHARBLOCK_ROTOR_NUMCHARS =  (* - CHARBLOCK_ROTOR_0) / 8

CHARBLOCK_ROTOR_2:
CHARBLOCK_ROTOR_TARGETCHAR_ANTICLOCKWISE = (* - CHR_SOURCE) / 8

CHR_ANTICLOCKWISE_0 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00001111
	.byte %00111000
	.byte %11000000
	.byte %10000000

CHR_ANTICLOCKWISE_1 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %11110000
	.byte %11111100
	.byte %11111111
	.byte %11111111

CHR_ANTICLOCKWISE_2 = (* - CHR_SOURCE) / 8
	.byte %00000011
	.byte %00000011
	.byte %00000110
	.byte %00000110
	.byte %00000111
	.byte %00000111
	.byte %00000011
	.byte %00000011

CHR_ANTICLOCKWISE_3 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111

CHR_ANTICLOCKWISE_4 = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

CHR_ANTICLOCKWISE_5 = (* - CHR_SOURCE) / 8
	.byte %11000000
	.byte %11000000
	.byte %11100000
	.byte %11100000
	.byte %01100000
	.byte %01100000
	.byte %11000000
	.byte %11000000

CHR_ANTICLOCKWISE_6 = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %00111111
	.byte %00001111
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

CHR_ANTICLOCKWISE_7 = (* - CHR_SOURCE) / 8
	.byte %00000001
	.byte %00000011
	.byte %00011100
	.byte %11110000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

CHARBLOCK_4_0:
CHARBLOCK_4_TARGETCHAR = (* - CHR_SOURCE) / 8

CHR_TELEPORT_0 = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111110

CHR_TELEPORT_1 = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11110000
	.byte %11000000
	.byte %00000000
	.byte %00000000

CHR_TELEPORT_2 = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %00001111
	.byte %00000011
	.byte %00000000
	.byte %00000000

CHR_TELEPORT_3 = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %01111111

CHR_TELEPORT_4 = (* - CHR_SOURCE) / 8
	.byte %11111100
	.byte %11111100
	.byte %11111000
	.byte %11111000
	.byte %11111000
	.byte %11111000
	.byte %11111100
	.byte %11111100

CHR_TELEPORT_5 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000011
	.byte %00000111
	.byte %00000111
	.byte %00000011
	.byte %00000000
	.byte %00000000

CHR_TELEPORT_6 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %11000000
	.byte %11100000
	.byte %11100000
	.byte %11000000
	.byte %00000000
	.byte %00000000

CHR_TELEPORT_7 = (* - CHR_SOURCE) / 8
	.byte %00111111
	.byte %00111111
	.byte %00011111
	.byte %00011111
	.byte %00011111
	.byte %00011111
	.byte %00111111
	.byte %00111111

CHR_TELEPORT_8 = (* - CHR_SOURCE) / 8
	.byte %11111110
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111

CHR_TELEPORT_9 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %11000000
	.byte %11110000
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111

CHR_TELEPORT_A = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000011
	.byte %00001111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111

CHR_TELEPORT_B = (* - CHR_SOURCE) / 8
	.byte %01111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111


CHARBLOCK_4_NUMCHARS = (* - CHARBLOCK_4_0) / 8

CHARBLOCK_8_0:
CHARBLOCK_8_TARGETCHAR = (* - CHR_SOURCE) / 8

CHR_BARRIER_CLOSED = (* - CHR_SOURCE) / 8
	.byte %10011001
	.byte %11001100
	.byte %01100110
	.byte %00110011
	.byte %10011001
	.byte %00110011
	.byte %01100110
	.byte %11001100

CHR_BARRIER_ELECTRIFIED = (* - CHR_SOURCE) / 8
	.byte %10011110
	.byte %00110001
	.byte %01011111
	.byte %00110101
	.byte %10101010
	.byte %01011011
	.byte %01001001
	.byte %00110010

CHARBLOCK_8_NUMCHARS = (* - CHARBLOCK_8_0) / 8

CHR_SOURCE_END:

CHARBLOCK_ROTOR_1:

;CHR_ROTOR_0 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00001111
	.byte %00111111
	.byte %11111111
	.byte %11111111

;CHR_ROTOR_1 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %11110000
	.byte %11111100
	.byte %11111111
	.byte %11111111

;CHR_ROTOR_2 = (* - CHR_SOURCE) / 8
	.byte %00000011
	.byte %00000011
	.byte %00000110
	.byte %00000110
	.byte %00000110
	.byte %00000110
	.byte %00000011
	.byte %00000011

;CHR_ROTOR_3 = (* - CHR_SOURCE) / 8
	.byte %00111111
	.byte %00001111
	.byte %00000011
	.byte %00000001
	.byte %00000001
	.byte %00000011
	.byte %00001111
	.byte %00111111

;CHR_ROTOR_4 = (* - CHR_SOURCE) / 8
	.byte %11111100
	.byte %11110000
	.byte %11000000
	.byte %10000000
	.byte %10000000
	.byte %11000000
	.byte %11110000
	.byte %11111100

;CHR_ROTOR_5 = (* - CHR_SOURCE) / 8
	.byte %11000000
	.byte %11000000
	.byte %01100000
	.byte %01100000
	.byte %01100000
	.byte %01100000
	.byte %11000000
	.byte %11000000

;CHR_ROTOR_6 = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %00111111
	.byte %00001111
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

;CHR_ROTOR_7 = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %11111100
	.byte %11110000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000


CHARBLOCK_ROTOR_3:

;CHR_ROTOR_0 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00001111
	.byte %00111000
	.byte %11000000
	.byte %10000000

;CHR_ROTOR_1 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %11110000
	.byte %00011100
	.byte %00000011
	.byte %00000001

;CHR_ROTOR_2 = (* - CHR_SOURCE) / 8
	.byte %00000011
	.byte %00000011
	.byte %00000111
	.byte %00000111
	.byte %00000111
	.byte %00000111
	.byte %00000011
	.byte %00000011

;CHR_ROTOR_3 = (* - CHR_SOURCE) / 8
	.byte %10000000
	.byte %11100000
	.byte %11111000
	.byte %11111111
	.byte %11111111
	.byte %11111000
	.byte %11100000
	.byte %10000000

;CHR_ROTOR_4 = (* - CHR_SOURCE) / 8
	.byte %00000001
	.byte %00000111
	.byte %00011111
	.byte %11111111
	.byte %11111111
	.byte %00011111
	.byte %00000111
	.byte %00000001

;CHR_ROTOR_5 = (* - CHR_SOURCE) / 8
	.byte %11000000
	.byte %11000000
	.byte %11100000
	.byte %11100000
	.byte %11100000
	.byte %11100000
	.byte %11000000
	.byte %11000000

;CHR_ROTOR_6 = (* - CHR_SOURCE) / 8
	.byte %10000000
	.byte %11100000
	.byte %00111000
	.byte %00001111
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

;CHR_ROTOR_7 = (* - CHR_SOURCE) / 8
	.byte %00000001
	.byte %00000011
	.byte %00011100
	.byte %11110000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000


CHARBLOCK_2_1:

;CHR_BARRIER_OPEN
	.byte %00000001
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %10000000

;CHR_BARRIER_OPEN_VERT_TOP = (* - CHR_SOURCE) / 8
	.byte %00000001
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %10000000
	.byte %00000001
	.byte %00000000

;CHR_BARRIER_OPEN_VERT_BOTTOM = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %10000000
	.byte %00000001
	.byte %00000000
	.byte %00000000
	.byte %00000000


CHARBLOCK_4_1:

;CHR_TELEPORT_0 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000011
	.byte %00000111
	.byte %00001111
	.byte %00011111
	.byte %00111111
	.byte %01111111

;CHR_TELEPORT_1 = (* - CHR_SOURCE) / 8
	.byte %00011111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111

;CHR_TELEPORT_2 = (* - CHR_SOURCE) / 8
	.byte %11111000
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111

;CHR_TELEPORT_3 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %11000000
	.byte %11100000
	.byte %11110000
	.byte %11111000
	.byte %11111100
	.byte %11111110

;CHR_TELEPORT_4 = (* - CHR_SOURCE) / 8
	.byte %01111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %01111111

;CHR_TELEPORT_5 = (* - CHR_SOURCE) / 8
	.byte %11111000
	.byte %11100000
	.byte %11000000
	.byte %11000011
	.byte %11000011
	.byte %11000000
	.byte %11100000
	.byte %11111000

;CHR_TELEPORT_6 = (* - CHR_SOURCE) / 8
	.byte %00011111
	.byte %00000111
	.byte %00000011
	.byte %11000011
	.byte %11000011
	.byte %00000011
	.byte %00000111
	.byte %00011111

;CHR_TELEPORT_7 = (* - CHR_SOURCE) / 8
	.byte %11111110
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111110

;CHR_TELEPORT_8 = (* - CHR_SOURCE) / 8
	.byte %01111111
	.byte %00111111
	.byte %00011111
	.byte %00001111
	.byte %00000111
	.byte %00000011
	.byte %00000000
	.byte %00000000

;CHR_TELEPORT_9 = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %00011111

;CHR_TELEPORT_A = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111111
	.byte %11111000

;CHR_TELEPORT_B = (* - CHR_SOURCE) / 8
	.byte %11111110
	.byte %11111100
	.byte %11111000
	.byte %11110000
	.byte %11100000
	.byte %11000000
	.byte %00000000
	.byte %00000000

CHARBLOCK_4_2:

;CHR_TELEPORT_0 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000001

;CHR_TELEPORT_1 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00001111
	.byte %00111111
	.byte %11111111
	.byte %11111111

;CHR_TELEPORT_2 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %11110000
	.byte %11111100
	.byte %11111111
	.byte %11111111

;CHR_TELEPORT_3 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %10000000

;CHR_TELEPORT_4 = (* - CHR_SOURCE) / 8
	.byte %00000011
	.byte %00000011
	.byte %00000111
	.byte %00000111
	.byte %00000111
	.byte %00000111
	.byte %00000011
	.byte %00000011

;CHR_TELEPORT_5 = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %11111100
	.byte %11111000
	.byte %11111000
	.byte %11111100
	.byte %11111111
	.byte %11111111

;CHR_TELEPORT_6 = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %00111111
	.byte %00011111
	.byte %00011111
	.byte %00111111
	.byte %11111111
	.byte %11111111

;CHR_TELEPORT_7 = (* - CHR_SOURCE) / 8
	.byte %11000000
	.byte %11000000
	.byte %11100000
	.byte %11100000
	.byte %11100000
	.byte %11100000
	.byte %11000000
	.byte %11000000

;CHR_TELEPORT_8 = (* - CHR_SOURCE) / 8
	.byte %00000001
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

;CHR_TELEPORT_9 = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %00111111
	.byte %00001111
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

;CHR_TELEPORT_A = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %11111100
	.byte %11110000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

;CHR_TELEPORT_B = (* - CHR_SOURCE) / 8
	.byte %10000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

CHARBLOCK_4_3:

;CHR_TELEPORT_0 = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %11111100
	.byte %11111000
	.byte %11110000
	.byte %11100000
	.byte %11000000
	.byte %10000000

;CHR_TELEPORT_1 = (* - CHR_SOURCE) / 8
	.byte %11100000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

;CHR_TELEPORT_2 = (* - CHR_SOURCE) / 8
	.byte %00000111
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000

;CHR_TELEPORT_3 = (* - CHR_SOURCE) / 8
	.byte %11111111
	.byte %11111111
	.byte %00111111
	.byte %00011111
	.byte %00001111
	.byte %00000111
	.byte %00000011
	.byte %00000001

;CHR_TELEPORT_4 = (* - CHR_SOURCE) / 8
	.byte %10000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %10000000

;CHR_TELEPORT_5 = (* - CHR_SOURCE) / 8
	.byte %00000111
	.byte %00011111
	.byte %00111111
	.byte %00111100
	.byte %00111100
	.byte %00111111
	.byte %00011111
	.byte %00000111

;CHR_TELEPORT_6 = (* - CHR_SOURCE) / 8
	.byte %11100000
	.byte %11111000
	.byte %11111100
	.byte %00111100
	.byte %00111100
	.byte %11111100
	.byte %11111000
	.byte %11100000

;CHR_TELEPORT_7 = (* - CHR_SOURCE) / 8
	.byte %00000001
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000001

;CHR_TELEPORT_8 = (* - CHR_SOURCE) / 8
	.byte %10000000
	.byte %11000000
	.byte %11100000
	.byte %11110000
	.byte %11111000
	.byte %11111100
	.byte %11111111
	.byte %11111111

;CHR_TELEPORT_9 = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %11100000

;CHR_TELEPORT_A = (* - CHR_SOURCE) / 8
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000000
	.byte %00000111

;CHR_TELEPORT_B = (* - CHR_SOURCE) / 8
	.byte %00000001
	.byte %00000011
	.byte %00000111
	.byte %00001111
	.byte %00011111
	.byte %00111111
	.byte %11111111
	.byte %11111111


CHARBLOCK_8_1:

;CHR_BARRIER_CLOSED
	.byte %11001100
	.byte %01100110
	.byte %00110011
	.byte %10011001
	.byte %00110011
	.byte %01100110
	.byte %11001100
	.byte %10011001

;CHR_BARRIER_ELECTRIFIED
	.byte %01010001
	.byte %01011100
	.byte %00101101
	.byte %11011011
	.byte %00101001
	.byte %01011110
	.byte %00110010
	.byte %11010011


CHARBLOCK_8_2:

;CHR_BARRIER_CLOSED
	.byte %01100110
	.byte %00110011
	.byte %10011001
	.byte %00110011
	.byte %01100110
	.byte %11001100
	.byte %10011001
	.byte %11001100


;CHR_BARRIER_ELECTRIFIED
	.byte %01110111
	.byte %11010101
	.byte %10110100
	.byte %01101011
	.byte %11010110
	.byte %10101010
	.byte %00110011
	.byte %11001100


CHARBLOCK_8_3:

;CHR_BARRIER_CLOSED
	.byte %00110011
	.byte %10011001
	.byte %00110011
	.byte %01100110
	.byte %11001100
	.byte %10011001
	.byte %11001100
	.byte %01100110

;CHR_BARRIER_ELECTRIFIED
	.byte %11011001
	.byte %11101110
	.byte %10110101
	.byte %01000110
	.byte %01110010
	.byte %11001110
	.byte %11011100
	.byte %11110011

CHARBLOCK_8_4:

;CHR_BARRIER_CLOSED
	.byte %10011001
	.byte %00110011
	.byte %01100110
	.byte %11001100
	.byte %10011001
	.byte %11001100
	.byte %01100110
	.byte %00110011

;CHR_BARRIER_ELECTRIFIED
	.byte %01101010
	.byte %01001001
	.byte %01001100
	.byte %11011001
	.byte %01110101
	.byte %00110010
	.byte %11100110
	.byte %11000101

CHARBLOCK_8_5:

;CHR_BARRIER_CLOSED
	.byte %00110011
	.byte %01100110
	.byte %11001100
	.byte %10011001
	.byte %11001100
	.byte %01100110
	.byte %00110011
	.byte %10011001


;CHR_BARRIER_ELECTRIFIED
	.byte %11011100
	.byte %10110010
	.byte %01011101
	.byte %01011011
	.byte %00100100
	.byte %10011010
	.byte %11101100
	.byte %01100011


CHARBLOCK_8_6:

;CHR_BARRIER_CLOSED
	.byte %01100110
	.byte %11001100
	.byte %10011001
	.byte %11001100
	.byte %01100110
	.byte %00110011
	.byte %10011001
	.byte %00110011


;CHR_BARRIER_ELECTRIFIED
	.byte %11011010
	.byte %01101100
	.byte %00100110
	.byte %11100001
	.byte %01110110
	.byte %10110011
	.byte %11001011
	.byte %00100101


CHARBLOCK_8_7:

;CHR_BARRIER_CLOSED
	.byte %11001100
	.byte %10011001
	.byte %11001100
	.byte %01100110
	.byte %00110011
	.byte %10011001
	.byte %00110011
	.byte %01100110

;CHR_BARRIER_ELECTRIFIED
	.byte %00010001
	.byte %11110101
	.byte %10011110
	.byte %01011011
	.byte %00110101
	.byte %10110001
	.byte %01111011
	.byte %10001010

CHAR_SWAPPED:
	.byte %00000000
	.byte %00110000
	.byte %01111000
	.byte %01111000
	.byte %00111000
	.byte %00011100
	.byte %00011100
	.byte %00001110

	.byte  %00000000
	.byte  %00001100
	.byte  %00011110
	.byte  %00011110
	.byte  %00011100
	.byte  %00111000
	.byte  %00111000
	.byte  %01110000

