
HWALL_SOURCE:

HWALL_OPEN = (* - HWALL_SOURCE) 
	.byte CHR_GAP, CHR_GAP, CHR_GAP, CHR_GAP
	.byte CHR_GAP, CHR_GAP, CHR_GAP, CHR_GAP

HWALL_SPIKE_UP = (* - HWALL_SOURCE) 
	.byte CHR_SPIKE_UP | BG_WALL_TOP, CHR_SPIKE_UP | BG_WALL_TOP
	.byte CHR_SPIKE_UP | BG_WALL_TOP, CHR_SPIKE_UP | BG_WALL_TOP
	.byte CHR_BLOCK, CHR_BLOCK, CHR_BLOCK, CHR_BLOCK

HWALL_SPIKE_DOWN = (* - HWALL_SOURCE) 
	.byte CHR_SPIKE_DOWN | BG_WALL_TOP, CHR_SPIKE_DOWN | BG_WALL_TOP
	.byte CHR_SPIKE_DOWN | BG_WALL_TOP, CHR_SPIKE_DOWN | BG_WALL_TOP
	.byte CHR_SPIKE_DOWN | BG_WALL_EDGE, CHR_SPIKE_DOWN | BG_WALL_EDGE
	.byte CHR_SPIKE_DOWN | BG_WALL_EDGE, CHR_SPIKE_DOWN | BG_WALL_EDGE

HWALL_SOLID = (* - HWALL_SOURCE) 
	.byte CHR_BLOCK, CHR_BLOCK, CHR_BLOCK, CHR_BLOCK
	.byte CHR_BLOCK, CHR_BLOCK, CHR_BLOCK, CHR_BLOCK

HWALL_DOOR =  (* - HWALL_SOURCE)
	.byte CHR_BLOCK, CHR_BLOCK, CHR_BLOCK, CHR_BLOCK
	.byte CHR_BLOCK, CHR_LOCK_L, CHR_LOCK_R, CHR_BLOCK

HWALL_BARRIER_OPEN =  (* - HWALL_SOURCE)
	.byte CHR_GAP, CHR_GAP, CHR_GAP, CHR_GAP
	.byte CHR_BARRIER_OPEN, CHR_BARRIER_OPEN, CHR_BARRIER_OPEN, CHR_BARRIER_OPEN

HWALL_BARRIER_CLOSED =  (* - HWALL_SOURCE)
	.byte CHR_BARRIER_CLOSED | BG_WALL_TOP, CHR_BARRIER_CLOSED | BG_WALL_TOP, CHR_BARRIER_CLOSED | BG_WALL_TOP, CHR_BARRIER_CLOSED | BG_WALL_TOP
	.byte CHR_BARRIER_CLOSED | BG_WALL_EDGE, CHR_BARRIER_CLOSED | BG_WALL_EDGE, CHR_BARRIER_CLOSED | BG_WALL_EDGE, CHR_BARRIER_CLOSED | BG_WALL_EDGE

HWALL_BARRIER_ELECTRIFIED =  (* - HWALL_SOURCE)
	.byte CHR_BARRIER_ELECTRIFIED, CHR_BARRIER_ELECTRIFIED, CHR_BARRIER_ELECTRIFIED, CHR_BARRIER_ELECTRIFIED
	.byte CHR_BARRIER_ELECTRIFIED, CHR_BARRIER_ELECTRIFIED, CHR_BARRIER_ELECTRIFIED, CHR_BARRIER_ELECTRIFIED

HWALL_CORNER_TL = (* - HWALL_SOURCE) 
	.byte CHR_BLOCK, CHR_BLOCK, CHR_BLOCK, CHR_BLOCK
	.byte CHR_CORNER_TL | BG_WALL_TOP, CHR_BLOCK, CHR_BLOCK, CHR_BLOCK

HWALL_CORNER_TR = (* - HWALL_SOURCE) 
	.byte CHR_BLOCK, CHR_BLOCK, CHR_BLOCK, CHR_BLOCK
	.byte CHR_BLOCK, CHR_BLOCK, CHR_BLOCK, CHR_CORNER_TR | BG_WALL_TOP

HWALL_BLOCK = (* - HWALL_SOURCE) 
	.byte CHR_BLOCK, CHR_BLOCK, CHR_BLOCK, CHR_BLOCK
	.byte CHR_BLOCK, CHR_BLOCK, CHR_BLOCK, CHR_BLOCK

HWALL_COLOUR_SOURCE:

HWALL_COLOUR_OPEN = (* - HWALL_COLOUR_SOURCE) 
	.byte TRANSPARENT_COLOUR, TRANSPARENT_COLOUR
	.byte TRANSPARENT_COLOUR, TRANSPARENT_COLOUR
	.byte FLOOR_COLOUR, FLOOR_COLOUR, FLOOR_COLOUR, FLOOR_COLOUR

HWALL_COLOUR_UP = (* - HWALL_COLOUR_SOURCE) 
	.byte TRANSPARENT_COLOUR, TRANSPARENT_COLOUR
	.byte TRANSPARENT_COLOUR, TRANSPARENT_COLOUR
	.byte WALL_EDGE_COLOUR, WALL_EDGE_COLOUR, WALL_EDGE_COLOUR, WALL_EDGE_COLOUR

HWALL_COLOUR_DOWN = (* - HWALL_COLOUR_SOURCE) 
	.byte WALL_EDGE_COLOUR, WALL_EDGE_COLOUR, WALL_EDGE_COLOUR, WALL_EDGE_COLOUR
	.byte FLOOR_COLOUR, FLOOR_COLOUR, FLOOR_COLOUR, FLOOR_COLOUR

HWALL_COLOUR_SOLID = (* - HWALL_COLOUR_SOURCE) 
	.byte WALL_TOP_COLOUR, WALL_TOP_COLOUR, WALL_TOP_COLOUR, WALL_TOP_COLOUR
	.byte WALL_EDGE_COLOUR, WALL_EDGE_COLOUR, WALL_EDGE_COLOUR, WALL_EDGE_COLOUR

HWALL_COLOUR_DOOR = (* - HWALL_COLOUR_SOURCE) 
	.byte DOOR_TOP_COLOUR, LOCK_TOP_COLOUR, LOCK_TOP_COLOUR, DOOR_TOP_COLOUR
	.byte DOOR_EDGE_COLOUR, LOCK_EDGE_COLOUR, LOCK_EDGE_COLOUR, DOOR_EDGE_COLOUR

HWALL_COLOUR_BARRIER_OPEN = (* - HWALL_COLOUR_SOURCE) 
	.byte TRANSPARENT_COLOUR, TRANSPARENT_COLOUR
	.byte TRANSPARENT_COLOUR, TRANSPARENT_COLOUR
	.byte BARRIER_OPEN_COLOUR, BARRIER_OPEN_COLOUR, BARRIER_OPEN_COLOUR, BARRIER_OPEN_COLOUR

HWALL_COLOUR_BARRIER_CLOSED = (* - HWALL_COLOUR_SOURCE) 
	.byte BARRIER_CLOSED_TOP_COLOUR, BARRIER_CLOSED_TOP_COLOUR, BARRIER_CLOSED_TOP_COLOUR, BARRIER_CLOSED_TOP_COLOUR
	.byte BARRIER_CLOSED_EDGE_COLOUR, BARRIER_CLOSED_EDGE_COLOUR, BARRIER_CLOSED_EDGE_COLOUR, BARRIER_CLOSED_EDGE_COLOUR

HWALL_COLOUR_BARRIER_ELECTRIFIED = (* - HWALL_COLOUR_SOURCE) 
	.byte BARRIER_ELECTRIFIED_TOP_COLOUR, BARRIER_ELECTRIFIED_TOP_COLOUR, BARRIER_ELECTRIFIED_TOP_COLOUR, BARRIER_ELECTRIFIED_TOP_COLOUR
	.byte BARRIER_ELECTRIFIED_EDGE_COLOUR, BARRIER_ELECTRIFIED_EDGE_COLOUR, BARRIER_ELECTRIFIED_EDGE_COLOUR, BARRIER_ELECTRIFIED_EDGE_COLOUR

HWALL_COLOUR_CORNER_TL = (* - HWALL_COLOUR_SOURCE) 
	.byte WALL_TOP_COLOUR, WALL_TOP_COLOUR, WALL_TOP_COLOUR, WALL_TOP_COLOUR
	.byte WALL_EDGE_COLOUR, WALL_EDGE_COLOUR, WALL_EDGE_COLOUR, WALL_EDGE_COLOUR

HWALL_COLOUR_CORNER_TR = (* - HWALL_COLOUR_SOURCE) 
	.byte WALL_TOP_COLOUR, WALL_TOP_COLOUR, WALL_TOP_COLOUR, WALL_TOP_COLOUR
	.byte WALL_EDGE_COLOUR, WALL_EDGE_COLOUR, WALL_EDGE_COLOUR, WALL_EDGE_COLOUR

HWALL_COLOUR_BLOCK = (* - HWALL_COLOUR_SOURCE) 
	.byte WALL_TOP_COLOUR, WALL_TOP_COLOUR, WALL_TOP_COLOUR, WALL_TOP_COLOUR
	.byte WALL_TOP_COLOUR, WALL_TOP_COLOUR, WALL_TOP_COLOUR, WALL_TOP_COLOUR



VWALL_SOURCE:

VWALL_OPEN = (* - VWALL_SOURCE)
	.byte CHR_BLOCK, CHR_GAP, CHR_GAP

VWALL_SPIKE_RIGHT = (* - VWALL_SOURCE)
	.byte CHR_SPIKE_LEFT_T | BG_WALL_TOP
	.byte CHR_SPIKE_LEFT_M | BG_WALL_TOP
	.byte CHR_SPIKE_LEFT_B | BG_WALL_TOP

VWALL_SPIKE_LEFT = (* - VWALL_SOURCE)
	.byte CHR_SPIKE_RIGHT_T | BG_WALL_TOP
	.byte CHR_SPIKE_RIGHT_M | BG_WALL_TOP
	.byte CHR_SPIKE_RIGHT_B | BG_WALL_TOP

VWALL_SOLID = (* - VWALL_SOURCE)
	.byte CHR_BLOCK, CHR_BLOCK, CHR_BLOCK

VWALL_DOOR = (* - VWALL_SOURCE)
	.byte CHR_DOOR_TOP | BG_OTHER, CHR_BLOCK, CHR_DOOR_BOTTOM | BG_OTHER

VWALL_BARRIER_OPEN = (* - VWALL_SOURCE)
	.byte CHR_BLOCK, CHR_BARRIER_OPEN_VERT_TOP, CHR_BARRIER_OPEN_VERT_BOTTOM

VWALL_BARRIER_CLOSED = (* - VWALL_SOURCE)
	.byte CHR_BARRIER_CLOSED | BG_WALL_TOP, CHR_BARRIER_CLOSED | BG_WALL_TOP, CHR_BARRIER_CLOSED | BG_WALL_TOP

VWALL_BARRIER_ELECTRIFIED = (* - VWALL_SOURCE)
	.byte CHR_BARRIER_ELECTRIFIED, CHR_BARRIER_ELECTRIFIED, CHR_BARRIER_ELECTRIFIED

VWALL_COLOUR_SOURCE:

VWALL_COLOUR_OPEN = (* - VWALL_COLOUR_SOURCE)
	.byte WALL_EDGE_COLOUR, FLOOR_COLOUR, FLOOR_COLOUR

VWALL_COLOUR_SPIKE_RIGHT = (* - VWALL_COLOUR_SOURCE)
	.byte WALL_EDGE_COLOUR, WALL_EDGE_COLOUR, WALL_EDGE_COLOUR

VWALL_COLOUR_SPIKE_LEFT = (* - VWALL_COLOUR_SOURCE)
	.byte WALL_EDGE_COLOUR, WALL_EDGE_COLOUR, WALL_EDGE_COLOUR

VWALL_COLOUR_SOLID = (* - VWALL_COLOUR_SOURCE)
	.byte WALL_TOP_COLOUR, WALL_TOP_COLOUR, WALL_TOP_COLOUR

VWALL_COLOUR_DOOR = (* - VWALL_COLOUR_SOURCE)
	.byte LOCK_TOP_COLOUR, LOCK_TOP_COLOUR, LOCK_TOP_COLOUR

VWALL_COLOUR_BARRIER_OPEN = (* - VWALL_COLOUR_SOURCE)
	.byte WALL_EDGE_COLOUR, BARRIER_OPEN_COLOUR, BARRIER_OPEN_COLOUR 

VWALL_COLOUR_BARRIER_CLOSED = (* - VWALL_COLOUR_SOURCE)
	.byte BARRIER_CLOSED_TOP_COLOUR, BARRIER_CLOSED_TOP_COLOUR, BARRIER_CLOSED_TOP_COLOUR

VWALL_COLOUR_BARRIER_ELECTRIFIED = (* - VWALL_COLOUR_SOURCE)
	.byte BARRIER_ELECTRIFIED_TOP_COLOUR, BARRIER_ELECTRIFIED_TOP_COLOUR, BARRIER_ELECTRIFIED_TOP_COLOUR
