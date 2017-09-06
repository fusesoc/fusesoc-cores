wire [31:0] wb_m2s_or1k_d_adr;
wire [31:0] wb_m2s_or1k_d_dat;
wire  [3:0] wb_m2s_or1k_d_sel;
wire        wb_m2s_or1k_d_we;
wire        wb_m2s_or1k_d_cyc;
wire        wb_m2s_or1k_d_stb;
wire  [2:0] wb_m2s_or1k_d_cti;
wire  [1:0] wb_m2s_or1k_d_bte;
wire [31:0] wb_s2m_or1k_d_dat;
wire        wb_s2m_or1k_d_ack;
wire        wb_s2m_or1k_d_err;
wire        wb_s2m_or1k_d_rty;
wire [31:0] wb_m2s_dbg_adr;
wire [31:0] wb_m2s_dbg_dat;
wire  [3:0] wb_m2s_dbg_sel;
wire        wb_m2s_dbg_we;
wire        wb_m2s_dbg_cyc;
wire        wb_m2s_dbg_stb;
wire  [2:0] wb_m2s_dbg_cti;
wire  [1:0] wb_m2s_dbg_bte;
wire [31:0] wb_s2m_dbg_dat;
wire        wb_s2m_dbg_ack;
wire        wb_s2m_dbg_err;
wire        wb_s2m_dbg_rty;
wire [31:0] wb_m2s_dbus_adr;
wire [31:0] wb_m2s_dbus_dat;
wire  [3:0] wb_m2s_dbus_sel;
wire        wb_m2s_dbus_we;
wire        wb_m2s_dbus_cyc;
wire        wb_m2s_dbus_stb;
wire  [2:0] wb_m2s_dbus_cti;
wire  [1:0] wb_m2s_dbus_bte;
wire [31:0] wb_s2m_dbus_dat;
wire        wb_s2m_dbus_ack;
wire        wb_s2m_dbus_err;
wire        wb_s2m_dbus_rty;

wb_intercon_dbg wb_intercon_dbg0
   (.wb_clk_i        (wb_clk),
    .wb_rst_i        (wb_rst),
    .wb_or1k_d_adr_i (wb_m2s_or1k_d_adr),
    .wb_or1k_d_dat_i (wb_m2s_or1k_d_dat),
    .wb_or1k_d_sel_i (wb_m2s_or1k_d_sel),
    .wb_or1k_d_we_i  (wb_m2s_or1k_d_we),
    .wb_or1k_d_cyc_i (wb_m2s_or1k_d_cyc),
    .wb_or1k_d_stb_i (wb_m2s_or1k_d_stb),
    .wb_or1k_d_cti_i (wb_m2s_or1k_d_cti),
    .wb_or1k_d_bte_i (wb_m2s_or1k_d_bte),
    .wb_or1k_d_dat_o (wb_s2m_or1k_d_dat),
    .wb_or1k_d_ack_o (wb_s2m_or1k_d_ack),
    .wb_or1k_d_err_o (wb_s2m_or1k_d_err),
    .wb_or1k_d_rty_o (wb_s2m_or1k_d_rty),
    .wb_dbg_adr_i    (wb_m2s_dbg_adr),
    .wb_dbg_dat_i    (wb_m2s_dbg_dat),
    .wb_dbg_sel_i    (wb_m2s_dbg_sel),
    .wb_dbg_we_i     (wb_m2s_dbg_we),
    .wb_dbg_cyc_i    (wb_m2s_dbg_cyc),
    .wb_dbg_stb_i    (wb_m2s_dbg_stb),
    .wb_dbg_cti_i    (wb_m2s_dbg_cti),
    .wb_dbg_bte_i    (wb_m2s_dbg_bte),
    .wb_dbg_dat_o    (wb_s2m_dbg_dat),
    .wb_dbg_ack_o    (wb_s2m_dbg_ack),
    .wb_dbg_err_o    (wb_s2m_dbg_err),
    .wb_dbg_rty_o    (wb_s2m_dbg_rty),
    .wb_dbus_adr_o   (wb_m2s_dbus_adr),
    .wb_dbus_dat_o   (wb_m2s_dbus_dat),
    .wb_dbus_sel_o   (wb_m2s_dbus_sel),
    .wb_dbus_we_o    (wb_m2s_dbus_we),
    .wb_dbus_cyc_o   (wb_m2s_dbus_cyc),
    .wb_dbus_stb_o   (wb_m2s_dbus_stb),
    .wb_dbus_cti_o   (wb_m2s_dbus_cti),
    .wb_dbus_bte_o   (wb_m2s_dbus_bte),
    .wb_dbus_dat_i   (wb_s2m_dbus_dat),
    .wb_dbus_ack_i   (wb_s2m_dbus_ack),
    .wb_dbus_err_i   (wb_s2m_dbus_err),
    .wb_dbus_rty_i   (wb_s2m_dbus_rty));
