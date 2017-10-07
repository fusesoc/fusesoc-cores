/*
 * Copyright (c) 2014, Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
 * All rights reserved.
 *
 * Redistribution and use in source and non-source forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in non-source form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *
 * THIS WORK IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * WORK, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

// Timer
module tc (
	input 			   clk,
	input 			   rst,
	// Wishbone slave interface
	input [16:0] 		   wb_adr_i,
	input [31:0] 		   wb_dat_i,
	input [3:0] 		   wb_sel_i,
	input 			   wb_we_i,
	input 			   wb_cyc_i,
	input 			   wb_stb_i,
	input [2:0] 		   wb_cti_i,
	input [1:0] 		   wb_bte_i,
	output [31:0] 		   wb_dat_o,
	output reg		   wb_ack_o,
	output 			   wb_err_o,
	output 			   wb_rty_o
);

reg [31:0] tc;

always @(posedge clk)
	if (rst)
		tc <= 0;
	else
		tc <= tc + 1;

// Read logic
assign wb_dat_o = tc;

// Ack logic
always @(posedge clk)
	wb_ack_o <= wb_cyc_i & wb_stb_i & !wb_ack_o;

assign wb_err_o = 0;
assign wb_rty_o = 0;

endmodule
