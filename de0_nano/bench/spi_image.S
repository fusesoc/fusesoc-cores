	l.movhi r0, 0
	l.movhi   r3, hi(0xdeadbeef)
	l.ori r3, r3, lo(0xdeadbeef)
	l.nop 0x2
	l.nop 0x1
	l.nop 0x0
	
