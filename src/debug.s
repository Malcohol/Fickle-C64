DEBUG = 0
TESTING = 0

.macro debug COLOUR
.if DEBUG
		LDA #COLOUR
		STA VIC_II_BORDER_COLOUR
.endif
.endmacro

.macro enddebug
.if DEBUG
		LDA #BORDER_COLOUR
		STA VIC_II_BORDER_COLOUR
.endif
.endmacro

DEBUG_MAIN = VIC_II_COLOUR_YELLOW
DEBUG_ANIMATIONS = VIC_II_COLOUR_GREY
DEBUG_BARRIERS = VIC_II_COLOUR_DARK_GREY
DEBUG_PLAYER = VIC_II_COLOUR_GREEN
DEBUG_BADDY = VIC_II_COLOUR_WHITE
DEBUG_OVERLAPS = VIC_II_COLOUR_LIGHT_GREY
DEBUG_ENTITY_INTERRUPTS = VIC_II_COLOUR_PURPLE

DEBUG_REENABLE_SPRITES = VIC_II_COLOUR_CYAN
DEBUG_BUMP_GRAPHICS = VIC_II_COLOUR_RED
DEBUG_BUMP_GRAPHICS_2 = VIC_II_COLOUR_PINK
DEBUG_GRAPHICS_AND_COLOUR_0 = VIC_II_COLOUR_BLUE
DEBUG_GRAPHICS_AND_COLOUR_1 = VIC_II_COLOUR_GREEN
DEBUG_GRAPHICS_AND_COLOUR_2 = VIC_II_COLOUR_LIGHT_GREY
DEBUG_CHANGE_COLOUR_3 = VIC_II_COLOUR_PURPLE
DEBUG_ENTITY_SPRITE = VIC_II_COLOUR_LIGHT_GREEN

DEBUG_MUSIC = VIC_II_COLOUR_CYAN
