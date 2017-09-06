from struct import unpack
import sys
infile = sys.argv[1]
offset = 64

outfile = sys.stdout

BLOCK = """@00000000
{rom_contents}	 
"""

with open(infile, "rb") as f:
    word = f.read(4)
    addr = 0
    rom_contents = ""
    while word:
        data = unpack('>I', word)[0]
        if not data == 0:
            rom_contents += "{data:08X}\n".format(data=data)
        word = f.read(4)
        addr += 1
    outfile.write(BLOCK.format(rom_contents=rom_contents))
