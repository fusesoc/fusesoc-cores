/*--------------------------------------------------------------------
----                                                              ----
----  altera_virtual_jtag.vhd                                     ----
----                                                              ----
----                                                              ----
----                                                              ----
----  Author(s):                                                  ----
----       Nathan Yawn (nathan.yawn@opencores.org)                ----
----                                                              ----
----  Verilog conversion:                                         ----
----       Stefan Kristiansson (stefan.kristiansson@saunalahti.fi)----
----                                                              ----
----------------------------------------------------------------------
----                                                              ----
---- Copyright (C) 2008-2010 Authors                              ----
----                                                              ----
---- This source file may be used and distributed without         ----
---- restriction provided that this copyright statement is not    ----
---- removed from the file and that any derivative work contains  ----
---- the original copyright notice and the associated disclaimer. ----
----                                                              ----
---- This source file is free software; you can redistribute it   ----
---- and/or modify it under the terms of the GNU Lesser General   ----
---- Public License as published by the Free Software Foundation; ----
---- either version 2.1 of the License, or (at your option) any   ----
---- later version.                                               ----
----                                                              ----
---- This source is distributed in the hope that it will be       ----
---- useful, but WITHOUT ANY WARRANTY; without even the implied   ----
---- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ----
---- PURPOSE.  See the GNU Lesser General Public License for more ----
---- details.                                                     ----
----                                                              ----
---- You should have received a copy of the GNU Lesser General    ----
---- Public License along with this source; if not, download it   ----
---- from http://www.opencores.org/lgpl.shtml                     ----
----                                                              ----
----------------------------------------------------------------------
--                                                                  --
-- This file is a wrapper for the Altera Virtual JTAG device.       --
-- It is designed to take the place of a separate TAP               --
-- controller in Altera systems, to allow a user to access a CPU    --
-- debug module (such as that of the OR1200) through the FPGA's     --
-- dedicated JTAG / configuration port.                             --
--                                                                  --
--------------------------------------------------------------------*/

module altera_virtual_jtag (
	output	tck_o,
	input	debug_tdo_i,
	output	tdi_o,
	output	test_logic_reset_o,
	output	run_test_idle_o,
	output	shift_dr_o,
	output	capture_dr_o,
	output	pause_dr_o,
	output	update_dr_o,
	output	debug_select_o
);

localparam [3:0] CMD_DEBUG = 4'b1000;

wire	[3:0]	ir_value;

sld_virtual_jtag #(
	.sld_auto_instance_index	("YES"),
	.sld_instance_index		(0),
	.sld_ir_width			(4),
	.sld_sim_action			(""),
	.sld_sim_n_scan			(0),
	.sld_sim_total_length		(0),
	.lpm_type			("sld_virtual_jtag")
) sld_virtual_jtag_component (
	.ir_out				(ir_value),
	.tdo				(debug_tdo_i),
	.tdi				(tdi_o),
	.jtag_state_rti			(run_test_idle_o),
	.tck				(tck_o),
	.tms				(),
	.ir_in				(ir_value),
	.jtag_state_tlr			(test_logic_reset_o),
	.jtag_state_sdr			(),
	.jtag_state_sir			(),
	.jtag_state_sdrs		(),
	.jtag_state_cdr			(),
	.jtag_state_e1dr		(),
	.jtag_state_pdr			(),
	.jtag_state_e2dr		(),
	.jtag_state_udr			(),
	.jtag_state_sirs		(),
	.jtag_state_cir			(),
	.jtag_state_e1ir		(),
	.jtag_state_pir			(),
	.jtag_state_e2ir		(),
	.jtag_state_uir			(),

	.virtual_state_cir		(),
	.virtual_state_pdr		(pause_dr_o),
	.virtual_state_uir		(),
	.virtual_state_sdr		(shift_dr_o),
	.virtual_state_cdr		(capture_dr_o),
	.virtual_state_udr		(update_dr_o),
	.virtual_state_e1dr		(),
	.virtual_state_e2dr		()
);

assign debug_select_o = (ir_value == CMD_DEBUG);

endmodule
