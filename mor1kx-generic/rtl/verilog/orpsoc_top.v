module orpsoc_top
  #(parameter MEM_SIZE = 32'h02000000)
(
		input wb_clk_i,
		input wb_rst_i,
		output tdo_pad_o,
		input tms_pad_i,
		input tck_pad_i,
		input tdi_pad_i
);

localparam wb_aw = 32;
localparam wb_dw = 32;

////////////////////////////////////////////////////////////////////////
//
// Wishbone interconnect
//
////////////////////////////////////////////////////////////////////////
wire wb_clk = wb_clk_i;
wire wb_rst = wb_rst_i;

`include "wb_intercon.vh"

////////////////////////////////////////////////////////////////////////
//
// GENERIC JTAG TAP
//
////////////////////////////////////////////////////////////////////////

wire dbg_if_select;
wire dbg_if_tdo;
wire jtag_tap_tdo;
wire jtag_tap_shift_dr;
wire jtag_tap_pause_dr;
wire jtag_tap_update_dr;
wire jtag_tap_capture_dr;

tap_top jtag_tap0 (
	.tdo_pad_o			(tdo_pad_o),
	.tms_pad_i			(tms_pad_i),
	.tck_pad_i			(tck_pad_i),
	.trst_pad_i			(wb_rst),
	.tdi_pad_i			(tdi_pad_i),

	.tdo_padoe_o			(),

	.tdo_o				(jtag_tap_tdo),

	.shift_dr_o			(jtag_tap_shift_dr),
	.pause_dr_o			(jtag_tap_pause_dr),
	.update_dr_o			(jtag_tap_update_dr),
	.capture_dr_o			(jtag_tap_capture_dr),

	.extest_select_o		(),
	.sample_preload_select_o	(),
	.mbist_select_o			(),
	.debug_select_o			(dbg_if_select),


	.bs_chain_tdi_i			(1'b0),
	.mbist_tdi_i			(1'b0),
	.debug_tdi_i			(dbg_if_tdo)
);

////////////////////////////////////////////////////////////////////////
//
// Debug Interface
//
////////////////////////////////////////////////////////////////////////
wire [31:0]	or1k_dbg_dat_i;
wire [31:0]	or1k_dbg_adr_i;
wire		or1k_dbg_we_i;
wire		or1k_dbg_stb_i;
wire		or1k_dbg_ack_o;
wire [31:0]	or1k_dbg_dat_o;

wire		or1k_dbg_stall_i;
wire		or1k_dbg_ewt_i;
wire [3:0]	or1k_dbg_lss_o;
wire [1:0]	or1k_dbg_is_o;
wire [10:0]	or1k_dbg_wp_o;
wire		or1k_dbg_bp_o;
wire		or1k_dbg_rst;


adbg_top dbg_if0 (
	// OR1K interface
	.cpu0_clk_i	(wb_clk),
	.cpu0_rst_o	(or1k_dbg_rst),
	.cpu0_addr_o	(or1k_dbg_adr_i),
	.cpu0_data_o	(or1k_dbg_dat_i),
	.cpu0_stb_o	(or1k_dbg_stb_i),
	.cpu0_we_o	(or1k_dbg_we_i),
	.cpu0_data_i	(or1k_dbg_dat_o),
	.cpu0_ack_i	(or1k_dbg_ack_o),
	.cpu0_stall_o	(or1k_dbg_stall_i),
	.cpu0_bp_i	(or1k_dbg_bp_o),

	// TAP interface
	.tck_i		(tck_pad_i),
	.tdi_i		(jtag_tap_tdo),
	.tdo_o		(dbg_if_tdo),
	.rst_i		(wb_rst),
	.capture_dr_i	(jtag_tap_capture_dr),
	.shift_dr_i	(jtag_tap_shift_dr),
	.pause_dr_i	(jtag_tap_pause_dr),
	.update_dr_i	(jtag_tap_update_dr),
	.debug_select_i	(dbg_if_select),

	// Wishbone debug master
	.wb_clk_i	(wb_clk),
	.wb_dat_i	(wb_s2m_dbg_dat),
	.wb_ack_i	(wb_s2m_dbg_ack),
	.wb_err_i	(wb_s2m_dbg_err),

	.wb_adr_o	(wb_m2s_dbg_adr),
	.wb_dat_o	(wb_m2s_dbg_dat),
	.wb_cyc_o	(wb_m2s_dbg_cyc),
	.wb_stb_o	(wb_m2s_dbg_stb),
	.wb_sel_o	(wb_m2s_dbg_sel),
	.wb_we_o	(wb_m2s_dbg_we),
	.wb_cti_o	(wb_m2s_dbg_cti),
	.wb_bte_o	(wb_m2s_dbg_bte)
);

////////////////////////////////////////////////////////////////////////
//
// mor1kx cpu
//
////////////////////////////////////////////////////////////////////////

wire [31:0]	or1k_irq;
wire		or1k_clk;
wire		or1k_rst;

assign or1k_clk = wb_clk;
assign or1k_rst = wb_rst | or1k_dbg_rst;

mor1kx #(
	.FEATURE_DEBUGUNIT		("ENABLED"),
	.FEATURE_CMOV			("ENABLED"),
	.FEATURE_INSTRUCTIONCACHE	("ENABLED"),
	.OPTION_ICACHE_BLOCK_WIDTH	(5),
	.OPTION_ICACHE_SET_WIDTH	(8),
	.OPTION_ICACHE_WAYS		(2),
	.OPTION_ICACHE_LIMIT_WIDTH	(32),
	.FEATURE_IMMU			("ENABLED"),
	.FEATURE_DATACACHE		("ENABLED"),
	.OPTION_DCACHE_BLOCK_WIDTH	(5),
	.OPTION_DCACHE_SET_WIDTH	(8),
	.OPTION_DCACHE_WAYS		(2),
	.OPTION_DCACHE_LIMIT_WIDTH	(31),
	.FEATURE_DMMU			("ENABLED"),
	.OPTION_RF_NUM_SHADOW_GPR	(1),
	.IBUS_WB_TYPE			("B3_REGISTERED_FEEDBACK"),
	.DBUS_WB_TYPE			("B3_REGISTERED_FEEDBACK"),
	.OPTION_CPU0			("CAPPUCCINO"),
	.OPTION_RESET_PC		(32'h00000100)
) mor1kx0 (
	.iwbm_adr_o			(wb_m2s_or1k_i_adr),
	.iwbm_stb_o			(wb_m2s_or1k_i_stb),
	.iwbm_cyc_o			(wb_m2s_or1k_i_cyc),
	.iwbm_sel_o			(wb_m2s_or1k_i_sel),
	.iwbm_we_o			(wb_m2s_or1k_i_we),
	.iwbm_cti_o			(wb_m2s_or1k_i_cti),
	.iwbm_bte_o			(wb_m2s_or1k_i_bte),
	.iwbm_dat_o			(wb_m2s_or1k_i_dat),

	.dwbm_adr_o			(wb_m2s_or1k_d_adr),
	.dwbm_stb_o			(wb_m2s_or1k_d_stb),
	.dwbm_cyc_o			(wb_m2s_or1k_d_cyc),
	.dwbm_sel_o			(wb_m2s_or1k_d_sel),
	.dwbm_we_o			(wb_m2s_or1k_d_we ),
	.dwbm_cti_o			(wb_m2s_or1k_d_cti),
	.dwbm_bte_o			(wb_m2s_or1k_d_bte),
	.dwbm_dat_o			(wb_m2s_or1k_d_dat),

	.clk				(or1k_clk),
	.rst				(or1k_rst),

	.iwbm_err_i			(wb_s2m_or1k_i_err),
	.iwbm_ack_i			(wb_s2m_or1k_i_ack),
	.iwbm_dat_i			(wb_s2m_or1k_i_dat),
	.iwbm_rty_i			(wb_s2m_or1k_i_rty),

	.dwbm_err_i			(wb_s2m_or1k_d_err),
	.dwbm_ack_i			(wb_s2m_or1k_d_ack),
	.dwbm_dat_i			(wb_s2m_or1k_d_dat),
	.dwbm_rty_i			(wb_s2m_or1k_d_rty),

	.irq_i				(or1k_irq),

	.du_addr_i			(or1k_dbg_adr_i[15:0]),
	.du_stb_i			(or1k_dbg_stb_i),
	.du_dat_i			(or1k_dbg_dat_i),
	.du_we_i			(or1k_dbg_we_i),
	.du_dat_o			(or1k_dbg_dat_o),
	.du_ack_o			(or1k_dbg_ack_o),
	.du_stall_i			(or1k_dbg_stall_i),
	.du_stall_o			(or1k_dbg_bp_o)
);

////////////////////////////////////////////////////////////////////////
//
// Generic main RAM
//
////////////////////////////////////////////////////////////////////////
wb_ram #(
	.depth	(MEM_SIZE/4)
) wb_bfm_memory0 (
	//Wishbone Master interface
	.wb_clk_i	(wb_clk_i),
	.wb_rst_i	(wb_rst_i),
	.wb_adr_i	(wb_m2s_mem_adr[$clog2(MEM_SIZE)-3:0]),
	.wb_dat_i	(wb_m2s_mem_dat),
	.wb_sel_i	(wb_m2s_mem_sel),
	.wb_we_i	(wb_m2s_mem_we),
	.wb_cyc_i	(wb_m2s_mem_cyc),
	.wb_stb_i	(wb_m2s_mem_stb),
	.wb_cti_i	(wb_m2s_mem_cti),
	.wb_bte_i	(wb_m2s_mem_bte),
	.wb_dat_o	(wb_s2m_mem_dat),
	.wb_ack_o	(wb_s2m_mem_ack),
	.wb_err_o	(wb_s2m_mem_err)
);
   assign wb_s2m_mem_rty = 1'b0;

wire uart_irq;

uart_top #(
	.debug	(0),
	.SIM	(1)
) uart16550 (
	//Wishbone Master interface
	.wb_clk_i	(wb_clk_i),
	.wb_rst_i	(wb_rst_i),
	.wb_adr_i	(wb_m2s_uart_adr[2:0]),
	.wb_dat_i	(wb_m2s_uart_dat),
	.wb_sel_i	(4'h0),
	.wb_we_i	(wb_m2s_uart_we),
	.wb_cyc_i	(wb_m2s_uart_cyc),
	.wb_stb_i	(wb_m2s_uart_stb),
	.wb_dat_o	(wb_s2m_uart_dat),
	.wb_ack_o	(wb_s2m_uart_ack),
        .int_o		(uart_irq),
	.srx_pad_i	(1'b0),
	.stx_pad_o	(),
	.rts_pad_o	(),
	.cts_pad_i	(1'b0),
	.dtr_pad_o	(),
	.dsr_pad_i	(1'b0),
	.ri_pad_i	(1'b0),
	.dcd_pad_i	(1'b0)
);
   assign wb_s2m_uart_err = 1'b0;
   assign wb_s2m_uart_rty = 1'b0;

////////////////////////////////////////////////////////////////////////
//
// CPU Interrupt assignments
//
////////////////////////////////////////////////////////////////////////
assign or1k_irq[0] = 0;
assign or1k_irq[1] = 0;
assign or1k_irq[2] = uart_irq;
assign or1k_irq[3] = 0;
assign or1k_irq[4] = 0;
assign or1k_irq[5] = 0;
assign or1k_irq[6] = 0;
assign or1k_irq[7] = 0;
assign or1k_irq[8] = 0;
assign or1k_irq[9] = 0;
assign or1k_irq[10] = 0;
assign or1k_irq[11] = 0;
assign or1k_irq[12] = 0;
assign or1k_irq[13] = 0;
assign or1k_irq[14] = 0;
assign or1k_irq[15] = 0;
assign or1k_irq[16] = 0;
assign or1k_irq[17] = 0;
assign or1k_irq[18] = 0;
assign or1k_irq[19] = 0;
assign or1k_irq[20] = 0;
assign or1k_irq[21] = 0;
assign or1k_irq[22] = 0;
assign or1k_irq[23] = 0;
assign or1k_irq[24] = 0;
assign or1k_irq[25] = 0;
assign or1k_irq[26] = 0;
assign or1k_irq[27] = 0;
assign or1k_irq[28] = 0;
assign or1k_irq[29] = 0;
assign or1k_irq[30] = 0;

endmodule
