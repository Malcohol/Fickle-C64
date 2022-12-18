from sys import stdout
from argparse import ArgumentParser, FileType

parser = ArgumentParser()
parser.add_argument("-o", "--output", action="store")
parsedArgs = parser.parse_args()

output = stdout
if parsedArgs.output:
    output = open(parsedArgs.output, "w")

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
	output.write("\t.byte {}, .LOBYTE({})\n".format(e[0], e[1]))

interrupt_table = [ first_interrupt ]
current_raster = 50
for r in interrupt_rows:
	for i in range(0, 4):
		if i < len(r):
			interrupt_table.append( [ current_raster + column_offsets[i], r[i] ] )
	current_raster += 21

output.write("LUT_INTERRUPT_ROUTINES:\n")
for r in interrupt_table:
	printInterruptEntry(r)

output.write("BOTTOM_OF_SCREEN_RASTER:\n")
printInterruptEntry(last_interrupt)

output.write("LUT_INTERRUPT_ROUTINES_END:\n\n")

count = 0
current_raster = interrupt_table[0][0]

output.write("LUT_INTERRUPT_RASTER_TABLE_BASE:\n")
output.write("LUT_INTERRUPT_RASTER_TABLE = LUT_INTERRUPT_RASTER_TABLE_BASE - {}\n".format(current_raster))

# These calcuations are not quite right, but they work!

for r in interrupt_table[1:]:
	output.write("\t.byte ")
	while current_raster < r[0]:
		output.write("{}".format(count + 3)) 
		current_raster += 1
		if current_raster < r[0]:
			output.write(",")
	output.write("\n")
	count += 1
		
