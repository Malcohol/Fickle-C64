# Built the table of interrupts and a look-up table based on their raster positions.

first_interrupt = [ 40, "reenableSpritesInterrupt" ]

first_main_interrupt = 50
column_offsets = [ 0, 5, 11, 16 ]

# Most interrupts come in sequences of 4

interrupt_rows = [
  [ "entitySpriteInterrupt", "entitySpriteInterrupt", "hudBumpGraphicsRoutineAndColour0", "entitySpriteInterrupt" ],
  [ "hudBumpGraphicsRoutine2AndColour1", "entitySpriteInterrupt", "hudBumpGraphicsRoutine", "entitySpriteInterrupt" ],
  [ "hudBumpGraphicsRoutine2", "entitySpriteInterrupt", "hudBumpGraphicsRoutine", "entitySpriteInterrupt" ],
  [ "hudBumpGraphicsRoutine2", "entitySpriteInterrupt", "hudBumpGraphicsRoutine", "entitySpriteInterrupt" ],
  [ "hudBumpGraphicsRoutine2", "entitySpriteInterrupt", "hudBumpGraphicsRoutine", "entitySpriteInterrupt" ],
  [ "hudBumpGraphicsRoutine2", "entitySpriteInterrupt", "hudBumpGraphicsRoutine", "entitySpriteInterrupt" ],
  [ "hudBumpGraphicsRoutine2", "entitySpriteInterrupt", "hudBumpGraphicsRoutine", "entitySpriteInterrupt" ],
  [ "hudBumpGraphicsRoutine2", "entitySpriteInterrupt", "hudBumpGraphicsRoutine", "entitySpriteInterrupt" ],
  [ "hudBumpGraphicsRoutine2", "setMemoryPointersBottom", "hudBumpGraphicsRoutineAndColour2", "entitySpriteInterrupt" ],
  [ "hudChangeColourRoutine3" ]
]

last_interrupt = [ 50 + (25 * 8), "interrupt" ]

def printInterruptEntry(e):
	print "\t.byte", e[0], ", .LOBYTE(", e[1] , ")"
	

interrupt_table = [ first_interrupt ]
current_raster = 50
for r in interrupt_rows:
	for i in range(0, 4):
		if i < len(r):
			interrupt_table.append( [ current_raster + column_offsets[i], r[i] ] )
	current_raster += 21

print "LUT_INTERRUPT_ROUTINES:"
for r in interrupt_table:
	printInterruptEntry(r)

print "BOTTOM_OF_SCREEN_RASTER:"
printInterruptEntry(last_interrupt)

print "LUT_INTERRUPT_ROUTINES_END:"
print


count = 0
current_raster = interrupt_table[0][0]

print "LUT_INTERRUPT_RASTER_TABLE_BASE:"
print "LUT_INTERRUPT_RASTER_TABLE = LUT_INTERRUPT_RASTER_TABLE_BASE - ", current_raster

# These calcuations are not quite right, but they work!

for r in interrupt_table[1:]:
	print "\t.byte ",
	while current_raster < r[0]:
		print count + 3, 
		current_raster += 1
		if current_raster < r[0]:
			print ",",
	print
	count += 1
		
