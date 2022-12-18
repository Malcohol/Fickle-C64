from sys import stdout
from argparse import ArgumentParser, FileType

parser = ArgumentParser()
parser.add_argument("-o", "--output", action="store")
parsedArgs = parser.parse_args()

output = stdout
if parsedArgs.output:
    output = open(parsedArgs.output, "w")

# The bottom sprite only needs 10 pixels, so splitting at 11
# means we don't need an extra sprite and extra interrupts.
splitAt = 11
maxLine = 199
spriteHeight = 21
spriteStride = 64

def calcLine(x):
	d, m = divmod(x, spriteHeight)
	d = d * (2 * spriteStride)
	if m >= splitAt:
		d = d + spriteStride
	m = m * 3
	return d + m


output.write("LUT_LINE_TABLE_HI:\n")
for i in range(0, maxLine + 1):
	output.write("\t.byte .hibyte(HUD_RIGHT_ADDRESS + {})\n".format(calcLine(i)))

output.write("LUT_LINE_TABLE_LO:\n")
for i in range(0, maxLine + 1):
	output.write("\t.byte .lobyte(HUD_RIGHT_ADDRESS + {})\n".format(calcLine(i)))
