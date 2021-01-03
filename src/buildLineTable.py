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


print "LUT_LINE_TABLE_HI:"
for i in range(0, maxLine + 1):
	print "\t.byte .hibyte(HUD_RIGHT_ADDRESS + ", calcLine(i), ")"

print "LUT_LINE_TABLE_LO:"
for i in range(0, maxLine + 1):
	print "\t.byte .lobyte(HUD_RIGHT_ADDRESS + ", calcLine(i), ")"
