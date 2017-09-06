//////////////////////////////////////////////////////////////////////
///                                                               //// 
/// bootrom                                                       ////
///                                                               ////
/// Assembly programs to be embedded inside system to aid boot    ////
///                                                               ////
/// Julius Baxter, julius@opencores.org                           ////
/// Olof Kindgren, olof.kindgren@gmail.com                        ////
///                                                               ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2009, 2010 Authors and OPENCORES.ORG           ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

	/* Assembly program to go into the boot ROM */
	/* For use with simple_spi SPI master core and standard SPI flash
	   interface-compatible parts (ST M25P16 for example.)*/
	/* Currently just loads a program from SPI flash into RAM */

/* Base address of the Simple SPI instance used to communicate with the Flash */
#ifndef SPI_BASE
#define SPI_BASE 0xB0000000
#endif

/* 24-bit address in SPI Flash where application image is stored */
#ifndef BOOTROM_ADDR
#define BOOTROM_ADDR 0x000000
#endif	

#define HEADER_ADDR BOOTROM_ADDR + 0xc
#define A2 ((HEADER_ADDR) >> 16) & 0xFF
#define A1 ((HEADER_ADDR) >> 8) & 0xFF
#define A0  (HEADER_ADDR) & 0xFF

#ifndef INIT_DELAY
#define INIT_DELAY 1250 //FIXME 0
#endif	
	
#define SPI_SPCR 0x0
#define SPI_SPSR 0x1
#define SPI_SPDR 0x2
#define SPI_SPER 0x3
#define SPI_SPSS 0x4

#define SPI_SPCR_XFER_GO 0x51
#define SPI_SPSS_INIT 0x1
#define SPI_SPSR_RX_CHECK 0x01 /* Check bit 0 is cleared, fifo !empty*/

	/* Registers used
	r1 temp register (used in spi_xfer)
	r2 spi_xfer return value
	r3 spi_xfer tx data
	r4 Simple SPI base address
	r5 spi_xfer byte counter
	r6 temp register
	r7 temp register
	r8 temp register
	r9 return address
	r10
	r11 Image size
	r12 Load address
	r13 Reset vector
	*/	
boot_init:	
	l.movhi r0, 0
	l.movhi r2, 0
	l.movhi r5, 0

	l.movhi r1,     hi(INIT_DELAY)
	l.ori   r1, r1, lo(INIT_DELAY)
1:	l.sfeqi r1, 0
	l.bnf 1b
	l.addi r1, r1, -1
	
	l.movhi r4, hi(SPI_BASE)
	
spi_init:
	l.ori 	r2, r0, SPI_SPCR_XFER_GO /* Setup SPCR with enable bit set */
	l.sb 	SPI_SPCR(r4), r2
	l.sb  	SPI_SPSS(r4), r0         /* Clear SPI slave selects */
	l.ori 	r6, r0, SPI_SPSS_INIT
	l.sb  	SPI_SPSS(r4), r6         /* Set appropriate slave select */

	l.ori   r5, r0, 1 /*Set spi_xfer in byte mode */
	l.jal	spi_xfer
	l.ori 	r3, r0, 0x3              /* READ command opcode for SPI device*/

	l.jal 	spi_xfer

	/* Set start address in SPI Flash */
	l.ori 	r3, r0, A2
	l.jal 	spi_xfer
	l.ori 	r3, r0, A1
	l.jal 	spi_xfer
	l.ori 	r3, r0, A0

	l.ori r5, r0, 4 /* set spi_xfer in word mode */
	
	/* Load image size to r11 */
get_size:
	l.jal spi_xfer
	l.nop
	l.or r11, r2, r0

	/* Load RAM base address to r12 */
get_load_addr:
	l.jal spi_xfer
	l.nop
	l.or r12, r2, r0
	
	/* Load reset vector to r13 */
get_entry_point:
	l.jal spi_xfer
	l.nop
	l.or r13, r2, r0
	
	/* Dummy read rest of the uimage header */
	l.ori r6, r0, 0x9
get_rest:
	l.jal spi_xfer
	l.nop
	l.sfeqi r6, 0

	l.bnf get_rest
	l.addi r6, r6, -1
	
	// r6 = loop counter
	// r7 = memory store address
	// Assumes at least one 32-bit word in image
	//Fixme: Copy last remaining words in byte mode
	l.movhi r6, 0
copy:	
	l.jal 	spi_xfer         /* Read a word into r2 */
	l.add	r7, r12, r6      /* Set memory store address */
	l.sw    0(r7), r2        /* Write word */

	l.addi	r6, r6, 4        /* Increse counter */

	l.sfgeu r6, r11         /* Check if file is completely copied */
	l.bnf copy
	l.nop

goto_reset:
	l.jr 	r13
	l.sb  	SPI_SPSS(r4), r0 /* Clear SPI slave selects */
	
/* Write one byte, or read one to four bytes with Simple SPI
	r1 = temp register
	r2 = Data read back from SPI
	r3 = Byte to write
	r4 = Simple SPI Base address
	r5 = Number of transfers (1-4)
	*/
spi_xfer:
	l.or r1, r5, r0
	
spi_xfer_loop:	
	l.sb 	SPI_SPDR(r4), r3  /* Dummy write what's in r3 */
	l.ori 	r3, r0, SPI_SPSR_RX_CHECK /* r3 = , ensure loop just once */
spi_xfer_poll:	
	l.andi 	r3, r3, SPI_SPSR_RX_CHECK /* AND read fifo bit empty */
	l.sfeqi r3, SPI_SPSR_RX_CHECK    /* is bit set? ... */
	l.bf 	spi_xfer_poll     /* ... if so, rxfifo empty, keep polling */
	l.lbz 	r3, SPI_SPSR(r4) /* Read SPSR */

	l.lbz 	r3, SPI_SPDR(r4) /* Get data byte */

	l.slli r2, r2, 8
	l.or   r2,  r2, r3
	l.sfeqi r1, 1
	l.bnf spi_xfer_loop
	l.addi r1, r1, -1
	
	l.jr 	r9
	l.nop
