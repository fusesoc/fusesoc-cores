module wb_intercon_dbg
   (input         wb_clk_i,
    input         wb_rst_i,
    input  [31:0] wb_or1k_d_adr_i,
    input  [31:0] wb_or1k_d_dat_i,
    input   [3:0] wb_or1k_d_sel_i,
    input         wb_or1k_d_we_i,
    input         wb_or1k_d_cyc_i,
    input         wb_or1k_d_stb_i,
    input   [2:0] wb_or1k_d_cti_i,
    input   [1:0] wb_or1k_d_bte_i,
    output [31:0] wb_or1k_d_dat_o,
    output        wb_or1k_d_ack_o,
    output        wb_or1k_d_err_o,
    output        wb_or1k_d_rty_o,
    input  [31:0] wb_dbg_adr_i,
    input  [31:0] wb_dbg_dat_i,
    input   [3:0] wb_dbg_sel_i,
    input         wb_dbg_we_i,
    input         wb_dbg_cyc_i,
    input         wb_dbg_stb_i,
    input   [2:0] wb_dbg_cti_i,
    input   [1:0] wb_dbg_bte_i,
    output [31:0] wb_dbg_dat_o,
    output        wb_dbg_ack_o,
    output        wb_dbg_err_o,
    output        wb_dbg_rty_o,
    output [31:0] wb_dbus_adr_o,
    output [31:0] wb_dbus_dat_o,
    output  [3:0] wb_dbus_sel_o,
    output        wb_dbus_we_o,
    output        wb_dbus_cyc_o,
    output        wb_dbus_stb_o,
    output  [2:0] wb_dbus_cti_o,
    output  [1:0] wb_dbus_bte_o,
    input  [31:0] wb_dbus_dat_i,
    input         wb_dbus_ack_i,
    input         wb_dbus_err_i,
    input         wb_dbus_rty_i);

wire [31:0] wb_m2s_or1k_d_dbus_adr;
wire [31:0] wb_m2s_or1k_d_dbus_dat;
wire  [3:0] wb_m2s_or1k_d_dbus_sel;
wire        wb_m2s_or1k_d_dbus_we;
wire        wb_m2s_or1k_d_dbus_cyc;
wire        wb_m2s_or1k_d_dbus_stb;
wire  [2:0] wb_m2s_or1k_d_dbus_cti;
wire  [1:0] wb_m2s_or1k_d_dbus_bte;
wire [31:0] wb_s2m_or1k_d_dbus_dat;
wire        wb_s2m_or1k_d_dbus_ack;
wire        wb_s2m_or1k_d_dbus_err;
wire        wb_s2m_or1k_d_dbus_rty;
wire [31:0] wb_m2s_dbg_dbus_adr;
wire [31:0] wb_m2s_dbg_dbus_dat;
wire  [3:0] wb_m2s_dbg_dbus_sel;
wire        wb_m2s_dbg_dbus_we;
wire        wb_m2s_dbg_dbus_cyc;
wire        wb_m2s_dbg_dbus_stb;
wire  [2:0] wb_m2s_dbg_dbus_cti;
wire  [1:0] wb_m2s_dbg_dbus_bte;
wire [31:0] wb_s2m_dbg_dbus_dat;
wire        wb_s2m_dbg_dbus_ack;
wire        wb_s2m_dbg_dbus_err;
wire        wb_s2m_dbg_dbus_rty;

wb_mux
  #(.num_slaves (1),
    .MATCH_ADDR ({32'h00000000}),
    .MATCH_MASK ({32'h00000000}))
 wb_mux_or1k_d
   (.wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wbm_adr_i (wb_or1k_d_adr_i),
    .wbm_dat_i (wb_or1k_d_dat_i),
    .wbm_sel_i (wb_or1k_d_sel_i),
    .wbm_we_i  (wb_or1k_d_we_i),
    .wbm_cyc_i (wb_or1k_d_cyc_i),
    .wbm_stb_i (wb_or1k_d_stb_i),
    .wbm_cti_i (wb_or1k_d_cti_i),
    .wbm_bte_i (wb_or1k_d_bte_i),
    .wbm_dat_o (wb_or1k_d_dat_o),
    .wbm_ack_o (wb_or1k_d_ack_o),
    .wbm_err_o (wb_or1k_d_err_o),
    .wbm_rty_o (wb_or1k_d_rty_o),
    .wbs_adr_o ({wb_m2s_or1k_d_dbus_adr}),
    .wbs_dat_o ({wb_m2s_or1k_d_dbus_dat}),
    .wbs_sel_o ({wb_m2s_or1k_d_dbus_sel}),
    .wbs_we_o  ({wb_m2s_or1k_d_dbus_we}),
    .wbs_cyc_o ({wb_m2s_or1k_d_dbus_cyc}),
    .wbs_stb_o ({wb_m2s_or1k_d_dbus_stb}),
    .wbs_cti_o ({wb_m2s_or1k_d_dbus_cti}),
    .wbs_bte_o ({wb_m2s_or1k_d_dbus_bte}),
    .wbs_dat_i ({wb_s2m_or1k_d_dbus_dat}),
    .wbs_ack_i ({wb_s2m_or1k_d_dbus_ack}),
    .wbs_err_i ({wb_s2m_or1k_d_dbus_err}),
    .wbs_rty_i ({wb_s2m_or1k_d_dbus_rty}));

wb_mux
  #(.num_slaves (1),
    .MATCH_ADDR ({32'h00000000}),
    .MATCH_MASK ({32'h00000000}))
 wb_mux_dbg
   (.wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wbm_adr_i (wb_dbg_adr_i),
    .wbm_dat_i (wb_dbg_dat_i),
    .wbm_sel_i (wb_dbg_sel_i),
    .wbm_we_i  (wb_dbg_we_i),
    .wbm_cyc_i (wb_dbg_cyc_i),
    .wbm_stb_i (wb_dbg_stb_i),
    .wbm_cti_i (wb_dbg_cti_i),
    .wbm_bte_i (wb_dbg_bte_i),
    .wbm_dat_o (wb_dbg_dat_o),
    .wbm_ack_o (wb_dbg_ack_o),
    .wbm_err_o (wb_dbg_err_o),
    .wbm_rty_o (wb_dbg_rty_o),
    .wbs_adr_o ({wb_m2s_dbg_dbus_adr}),
    .wbs_dat_o ({wb_m2s_dbg_dbus_dat}),
    .wbs_sel_o ({wb_m2s_dbg_dbus_sel}),
    .wbs_we_o  ({wb_m2s_dbg_dbus_we}),
    .wbs_cyc_o ({wb_m2s_dbg_dbus_cyc}),
    .wbs_stb_o ({wb_m2s_dbg_dbus_stb}),
    .wbs_cti_o ({wb_m2s_dbg_dbus_cti}),
    .wbs_bte_o ({wb_m2s_dbg_dbus_bte}),
    .wbs_dat_i ({wb_s2m_dbg_dbus_dat}),
    .wbs_ack_i ({wb_s2m_dbg_dbus_ack}),
    .wbs_err_i ({wb_s2m_dbg_dbus_err}),
    .wbs_rty_i ({wb_s2m_dbg_dbus_rty}));

wb_arbiter
  #(.num_masters (2))
 wb_arbiter_dbus
   (.wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wbm_adr_i ({wb_m2s_or1k_d_dbus_adr, wb_m2s_dbg_dbus_adr}),
    .wbm_dat_i ({wb_m2s_or1k_d_dbus_dat, wb_m2s_dbg_dbus_dat}),
    .wbm_sel_i ({wb_m2s_or1k_d_dbus_sel, wb_m2s_dbg_dbus_sel}),
    .wbm_we_i  ({wb_m2s_or1k_d_dbus_we, wb_m2s_dbg_dbus_we}),
    .wbm_cyc_i ({wb_m2s_or1k_d_dbus_cyc, wb_m2s_dbg_dbus_cyc}),
    .wbm_stb_i ({wb_m2s_or1k_d_dbus_stb, wb_m2s_dbg_dbus_stb}),
    .wbm_cti_i ({wb_m2s_or1k_d_dbus_cti, wb_m2s_dbg_dbus_cti}),
    .wbm_bte_i ({wb_m2s_or1k_d_dbus_bte, wb_m2s_dbg_dbus_bte}),
    .wbm_dat_o ({wb_s2m_or1k_d_dbus_dat, wb_s2m_dbg_dbus_dat}),
    .wbm_ack_o ({wb_s2m_or1k_d_dbus_ack, wb_s2m_dbg_dbus_ack}),
    .wbm_err_o ({wb_s2m_or1k_d_dbus_err, wb_s2m_dbg_dbus_err}),
    .wbm_rty_o ({wb_s2m_or1k_d_dbus_rty, wb_s2m_dbg_dbus_rty}),
    .wbs_adr_o (wb_dbus_adr_o),
    .wbs_dat_o (wb_dbus_dat_o),
    .wbs_sel_o (wb_dbus_sel_o),
    .wbs_we_o  (wb_dbus_we_o),
    .wbs_cyc_o (wb_dbus_cyc_o),
    .wbs_stb_o (wb_dbus_stb_o),
    .wbs_cti_o (wb_dbus_cti_o),
    .wbs_bte_o (wb_dbus_bte_o),
    .wbs_dat_i (wb_dbus_dat_i),
    .wbs_ack_i (wb_dbus_ack_i),
    .wbs_err_i (wb_dbus_err_i),
    .wbs_rty_i (wb_dbus_rty_i));

endmodule
