module wb_intercon
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
    input  [31:0] wb_or1k_i_adr_i,
    input  [31:0] wb_or1k_i_dat_i,
    input   [3:0] wb_or1k_i_sel_i,
    input         wb_or1k_i_we_i,
    input         wb_or1k_i_cyc_i,
    input         wb_or1k_i_stb_i,
    input   [2:0] wb_or1k_i_cti_i,
    input   [1:0] wb_or1k_i_bte_i,
    output [31:0] wb_or1k_i_dat_o,
    output        wb_or1k_i_ack_o,
    output        wb_or1k_i_err_o,
    output        wb_or1k_i_rty_o,
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
    output [31:0] wb_mem_adr_o,
    output [31:0] wb_mem_dat_o,
    output  [3:0] wb_mem_sel_o,
    output        wb_mem_we_o,
    output        wb_mem_cyc_o,
    output        wb_mem_stb_o,
    output  [2:0] wb_mem_cti_o,
    output  [1:0] wb_mem_bte_o,
    input  [31:0] wb_mem_dat_i,
    input         wb_mem_ack_i,
    input         wb_mem_err_i,
    input         wb_mem_rty_i,
    output [31:0] wb_uart_adr_o,
    output  [7:0] wb_uart_dat_o,
    output  [3:0] wb_uart_sel_o,
    output        wb_uart_we_o,
    output        wb_uart_cyc_o,
    output        wb_uart_stb_o,
    output  [2:0] wb_uart_cti_o,
    output  [1:0] wb_uart_bte_o,
    input   [7:0] wb_uart_dat_i,
    input         wb_uart_ack_i,
    input         wb_uart_err_i,
    input         wb_uart_rty_i);

wire [31:0] wb_m2s_or1k_d_mem_adr;
wire [31:0] wb_m2s_or1k_d_mem_dat;
wire  [3:0] wb_m2s_or1k_d_mem_sel;
wire        wb_m2s_or1k_d_mem_we;
wire        wb_m2s_or1k_d_mem_cyc;
wire        wb_m2s_or1k_d_mem_stb;
wire  [2:0] wb_m2s_or1k_d_mem_cti;
wire  [1:0] wb_m2s_or1k_d_mem_bte;
wire [31:0] wb_s2m_or1k_d_mem_dat;
wire        wb_s2m_or1k_d_mem_ack;
wire        wb_s2m_or1k_d_mem_err;
wire        wb_s2m_or1k_d_mem_rty;
wire [31:0] wb_m2s_or1k_i_mem_adr;
wire [31:0] wb_m2s_or1k_i_mem_dat;
wire  [3:0] wb_m2s_or1k_i_mem_sel;
wire        wb_m2s_or1k_i_mem_we;
wire        wb_m2s_or1k_i_mem_cyc;
wire        wb_m2s_or1k_i_mem_stb;
wire  [2:0] wb_m2s_or1k_i_mem_cti;
wire  [1:0] wb_m2s_or1k_i_mem_bte;
wire [31:0] wb_s2m_or1k_i_mem_dat;
wire        wb_s2m_or1k_i_mem_ack;
wire        wb_s2m_or1k_i_mem_err;
wire        wb_s2m_or1k_i_mem_rty;
wire [31:0] wb_m2s_dbg_mem_adr;
wire [31:0] wb_m2s_dbg_mem_dat;
wire  [3:0] wb_m2s_dbg_mem_sel;
wire        wb_m2s_dbg_mem_we;
wire        wb_m2s_dbg_mem_cyc;
wire        wb_m2s_dbg_mem_stb;
wire  [2:0] wb_m2s_dbg_mem_cti;
wire  [1:0] wb_m2s_dbg_mem_bte;
wire [31:0] wb_s2m_dbg_mem_dat;
wire        wb_s2m_dbg_mem_ack;
wire        wb_s2m_dbg_mem_err;
wire        wb_s2m_dbg_mem_rty;
wire [31:0] wb_m2s_resize_uart_adr;
wire [31:0] wb_m2s_resize_uart_dat;
wire  [3:0] wb_m2s_resize_uart_sel;
wire        wb_m2s_resize_uart_we;
wire        wb_m2s_resize_uart_cyc;
wire        wb_m2s_resize_uart_stb;
wire  [2:0] wb_m2s_resize_uart_cti;
wire  [1:0] wb_m2s_resize_uart_bte;
wire [31:0] wb_s2m_resize_uart_dat;
wire        wb_s2m_resize_uart_ack;
wire        wb_s2m_resize_uart_err;
wire        wb_s2m_resize_uart_rty;

wb_mux
  #(.num_slaves (2),
    .MATCH_ADDR ({32'h00000000, 32'h90000000}),
    .MATCH_MASK ({32'hfe000000, 32'hfffffff8}))
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
    .wbs_adr_o ({wb_m2s_or1k_d_mem_adr, wb_m2s_resize_uart_adr}),
    .wbs_dat_o ({wb_m2s_or1k_d_mem_dat, wb_m2s_resize_uart_dat}),
    .wbs_sel_o ({wb_m2s_or1k_d_mem_sel, wb_m2s_resize_uart_sel}),
    .wbs_we_o  ({wb_m2s_or1k_d_mem_we, wb_m2s_resize_uart_we}),
    .wbs_cyc_o ({wb_m2s_or1k_d_mem_cyc, wb_m2s_resize_uart_cyc}),
    .wbs_stb_o ({wb_m2s_or1k_d_mem_stb, wb_m2s_resize_uart_stb}),
    .wbs_cti_o ({wb_m2s_or1k_d_mem_cti, wb_m2s_resize_uart_cti}),
    .wbs_bte_o ({wb_m2s_or1k_d_mem_bte, wb_m2s_resize_uart_bte}),
    .wbs_dat_i ({wb_s2m_or1k_d_mem_dat, wb_s2m_resize_uart_dat}),
    .wbs_ack_i ({wb_s2m_or1k_d_mem_ack, wb_s2m_resize_uart_ack}),
    .wbs_err_i ({wb_s2m_or1k_d_mem_err, wb_s2m_resize_uart_err}),
    .wbs_rty_i ({wb_s2m_or1k_d_mem_rty, wb_s2m_resize_uart_rty}));

wb_mux
  #(.num_slaves (1),
    .MATCH_ADDR ({32'h00000000}),
    .MATCH_MASK ({32'hfe000000}))
 wb_mux_or1k_i
   (.wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wbm_adr_i (wb_or1k_i_adr_i),
    .wbm_dat_i (wb_or1k_i_dat_i),
    .wbm_sel_i (wb_or1k_i_sel_i),
    .wbm_we_i  (wb_or1k_i_we_i),
    .wbm_cyc_i (wb_or1k_i_cyc_i),
    .wbm_stb_i (wb_or1k_i_stb_i),
    .wbm_cti_i (wb_or1k_i_cti_i),
    .wbm_bte_i (wb_or1k_i_bte_i),
    .wbm_dat_o (wb_or1k_i_dat_o),
    .wbm_ack_o (wb_or1k_i_ack_o),
    .wbm_err_o (wb_or1k_i_err_o),
    .wbm_rty_o (wb_or1k_i_rty_o),
    .wbs_adr_o ({wb_m2s_or1k_i_mem_adr}),
    .wbs_dat_o ({wb_m2s_or1k_i_mem_dat}),
    .wbs_sel_o ({wb_m2s_or1k_i_mem_sel}),
    .wbs_we_o  ({wb_m2s_or1k_i_mem_we}),
    .wbs_cyc_o ({wb_m2s_or1k_i_mem_cyc}),
    .wbs_stb_o ({wb_m2s_or1k_i_mem_stb}),
    .wbs_cti_o ({wb_m2s_or1k_i_mem_cti}),
    .wbs_bte_o ({wb_m2s_or1k_i_mem_bte}),
    .wbs_dat_i ({wb_s2m_or1k_i_mem_dat}),
    .wbs_ack_i ({wb_s2m_or1k_i_mem_ack}),
    .wbs_err_i ({wb_s2m_or1k_i_mem_err}),
    .wbs_rty_i ({wb_s2m_or1k_i_mem_rty}));

wb_mux
  #(.num_slaves (1),
    .MATCH_ADDR ({32'h00000000}),
    .MATCH_MASK ({32'hfe000000}))
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
    .wbs_adr_o ({wb_m2s_dbg_mem_adr}),
    .wbs_dat_o ({wb_m2s_dbg_mem_dat}),
    .wbs_sel_o ({wb_m2s_dbg_mem_sel}),
    .wbs_we_o  ({wb_m2s_dbg_mem_we}),
    .wbs_cyc_o ({wb_m2s_dbg_mem_cyc}),
    .wbs_stb_o ({wb_m2s_dbg_mem_stb}),
    .wbs_cti_o ({wb_m2s_dbg_mem_cti}),
    .wbs_bte_o ({wb_m2s_dbg_mem_bte}),
    .wbs_dat_i ({wb_s2m_dbg_mem_dat}),
    .wbs_ack_i ({wb_s2m_dbg_mem_ack}),
    .wbs_err_i ({wb_s2m_dbg_mem_err}),
    .wbs_rty_i ({wb_s2m_dbg_mem_rty}));

wb_arbiter
  #(.num_masters (3))
 wb_arbiter_mem
   (.wb_clk_i  (wb_clk_i),
    .wb_rst_i  (wb_rst_i),
    .wbm_adr_i ({wb_m2s_or1k_i_mem_adr, wb_m2s_or1k_d_mem_adr, wb_m2s_dbg_mem_adr}),
    .wbm_dat_i ({wb_m2s_or1k_i_mem_dat, wb_m2s_or1k_d_mem_dat, wb_m2s_dbg_mem_dat}),
    .wbm_sel_i ({wb_m2s_or1k_i_mem_sel, wb_m2s_or1k_d_mem_sel, wb_m2s_dbg_mem_sel}),
    .wbm_we_i  ({wb_m2s_or1k_i_mem_we, wb_m2s_or1k_d_mem_we, wb_m2s_dbg_mem_we}),
    .wbm_cyc_i ({wb_m2s_or1k_i_mem_cyc, wb_m2s_or1k_d_mem_cyc, wb_m2s_dbg_mem_cyc}),
    .wbm_stb_i ({wb_m2s_or1k_i_mem_stb, wb_m2s_or1k_d_mem_stb, wb_m2s_dbg_mem_stb}),
    .wbm_cti_i ({wb_m2s_or1k_i_mem_cti, wb_m2s_or1k_d_mem_cti, wb_m2s_dbg_mem_cti}),
    .wbm_bte_i ({wb_m2s_or1k_i_mem_bte, wb_m2s_or1k_d_mem_bte, wb_m2s_dbg_mem_bte}),
    .wbm_dat_o ({wb_s2m_or1k_i_mem_dat, wb_s2m_or1k_d_mem_dat, wb_s2m_dbg_mem_dat}),
    .wbm_ack_o ({wb_s2m_or1k_i_mem_ack, wb_s2m_or1k_d_mem_ack, wb_s2m_dbg_mem_ack}),
    .wbm_err_o ({wb_s2m_or1k_i_mem_err, wb_s2m_or1k_d_mem_err, wb_s2m_dbg_mem_err}),
    .wbm_rty_o ({wb_s2m_or1k_i_mem_rty, wb_s2m_or1k_d_mem_rty, wb_s2m_dbg_mem_rty}),
    .wbs_adr_o (wb_mem_adr_o),
    .wbs_dat_o (wb_mem_dat_o),
    .wbs_sel_o (wb_mem_sel_o),
    .wbs_we_o  (wb_mem_we_o),
    .wbs_cyc_o (wb_mem_cyc_o),
    .wbs_stb_o (wb_mem_stb_o),
    .wbs_cti_o (wb_mem_cti_o),
    .wbs_bte_o (wb_mem_bte_o),
    .wbs_dat_i (wb_mem_dat_i),
    .wbs_ack_i (wb_mem_ack_i),
    .wbs_err_i (wb_mem_err_i),
    .wbs_rty_i (wb_mem_rty_i));

wb_data_resize
  #(.aw  (32),
    .mdw (32),
    .sdw (8))
 wb_data_resize_uart
   (.wbm_adr_i (wb_m2s_resize_uart_adr),
    .wbm_dat_i (wb_m2s_resize_uart_dat),
    .wbm_sel_i (wb_m2s_resize_uart_sel),
    .wbm_we_i  (wb_m2s_resize_uart_we),
    .wbm_cyc_i (wb_m2s_resize_uart_cyc),
    .wbm_stb_i (wb_m2s_resize_uart_stb),
    .wbm_cti_i (wb_m2s_resize_uart_cti),
    .wbm_bte_i (wb_m2s_resize_uart_bte),
    .wbm_dat_o (wb_s2m_resize_uart_dat),
    .wbm_ack_o (wb_s2m_resize_uart_ack),
    .wbm_err_o (wb_s2m_resize_uart_err),
    .wbm_rty_o (wb_s2m_resize_uart_rty),
    .wbs_adr_o (wb_uart_adr_o),
    .wbs_dat_o (wb_uart_dat_o),
    .wbs_we_o  (wb_uart_we_o),
    .wbs_cyc_o (wb_uart_cyc_o),
    .wbs_stb_o (wb_uart_stb_o),
    .wbs_cti_o (wb_uart_cti_o),
    .wbs_bte_o (wb_uart_bte_o),
    .wbs_dat_i (wb_uart_dat_i),
    .wbs_ack_i (wb_uart_ack_i),
    .wbs_err_i (wb_uart_err_i),
    .wbs_rty_i (wb_uart_rty_i));

endmodule
