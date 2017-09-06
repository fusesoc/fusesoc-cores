module de0_nano_top
  #(bootrom_file = "")
  (
   input 	 sys_clk_pad_i,
   input 	 rst_n_pad_i,
   output [1:0]  sdram_ba_pad_o,
   output [12:0] sdram_a_pad_o,
   output 	 sdram_cs_n_pad_o,
   output 	 sdram_ras_pad_o,
   output 	 sdram_cas_pad_o,
   output 	 sdram_we_pad_o,
   inout [15:0]  sdram_dq_pad_io,
   output [1:0]  sdram_dqm_pad_o,
   output 	 sdram_cke_pad_o,
   output 	 sdram_clk_pad_o,

   input 	 uart0_srx_pad_i,
   output 	 uart0_stx_pad_o,

   inout [7:0] 	 gpio0_io,
   input [3:0] 	 gpio1_i,

   inout 	 i2c0_sda_io,
   inout 	 i2c0_scl_io,

   inout 	 i2c1_sda_io,
   inout 	 i2c1_scl_io,

   output 	 spi0_sck_o,
   output 	 spi0_mosi_o,
   input 	 spi0_miso_i,
   output 	 spi0_ss_o,

   output 	 spi1_sck_o,
   output 	 spi1_mosi_o,
   input 	 spi1_miso_i,
   output 	 spi1_ss_o,

   output 	 spi2_sck_o,
   output 	 spi2_mosi_o,
   input 	 spi2_miso_i,
   output 	 spi2_ss_o,

   output 	 accelerometer_cs_o,
   input 	 accelerometer_irq_i);

////////////////////////////////////////////////////////////////////////
//
// Clock and reset generation module
//
////////////////////////////////////////////////////////////////////////

   wire 	 wb_clk;
   wire 	 wb_rst;
   wire 	 sdram_clk;
   wire 	 sdram_rst;

   clkgen clkgen0
     (.sys_clk_pad_i (sys_clk_pad_i),
      .rst_n_pad_i   (rst_n_pad_i),
      .wb_clk_o      (wb_clk),
      .wb_rst_o      (wb_rst),
      .sdram_clk_o   (sdram_clk),
      .sdram_rst_o   (sdram_rst));

////////////////////////////////////////////////////////////////////////
//
// JTAG
//
////////////////////////////////////////////////////////////////////////

   wire 	 dbg_if_select;
   wire 	 dbg_if_tdo;
   wire 	 dbg_tck;
   wire 	 jtag_tap_tdo;
   wire 	 jtag_tap_shift_dr;
   wire 	 jtag_tap_pause_dr;
   wire 	 jtag_tap_update_dr;
   wire 	 jtag_tap_capture_dr;

   altera_virtual_jtag jtag_tap0
     (.tck_o			(dbg_tck),
      .debug_tdo_i		(dbg_if_tdo),
      .tdi_o			(jtag_tap_tdo),
      .test_logic_reset_o	(),
      .run_test_idle_o	(),
      .shift_dr_o		(jtag_tap_shift_dr),
      .capture_dr_o		(jtag_tap_capture_dr),
      .pause_dr_o		(jtag_tap_pause_dr),
      .update_dr_o		(jtag_tap_update_dr),
      .debug_select_o		(dbg_if_select));

////////////////////////////////////////////////////////////////////////
//
// Core
//
////////////////////////////////////////////////////////////////////////

de0_nano_core
  #(.bootrom_file (bootrom_file))
   core
   (//Clock and reset
    .wb_clk (wb_clk),
    .wb_rst (wb_rst),
    .sdram_clk (sdram_clk),
    .sdram_rst (sdram_rst),
    //Debug interface
    .dbg_if_select_i       (dbg_if_select),
    .dbg_if_tdo_o          (dbg_if_tdo),
    .dbg_tck_i             (dbg_tck),
    .jtag_tap_tdo_i        (jtag_tap_tdo),
    .jtag_tap_shift_dr_i   (jtag_tap_shift_dr),
    .jtag_tap_pause_dr_i   (jtag_tap_pause_dr),
    .jtag_tap_update_dr_i  (jtag_tap_update_dr),
    .jtag_tap_capture_dr_i (jtag_tap_capture_dr),
    //SDRAM interface
    .sdram_ba_pad_o   (sdram_ba_pad_o),
    .sdram_a_pad_o    (sdram_a_pad_o),
    .sdram_cs_n_pad_o (sdram_cs_n_pad_o),
    .sdram_ras_pad_o  (sdram_ras_pad_o),
    .sdram_cas_pad_o  (sdram_cas_pad_o),
    .sdram_we_pad_o   (sdram_we_pad_o),
    .sdram_dq_pad_io  (sdram_dq_pad_io),
    .sdram_dqm_pad_o  (sdram_dqm_pad_o),
    .sdram_cke_pad_o  (sdram_cke_pad_o),
    .sdram_clk_pad_o  (sdram_clk_pad_o),

    .uart0_srx_pad_i	(uart0_srx_pad_i),
    .uart0_stx_pad_o	(uart0_stx_pad_o),

    .gpio0_io (gpio0_io),
    .gpio1_i  (gpio1_i),

    .i2c0_sda_io (i2c0_sda_io),
    .i2c0_scl_io (i2c0_scl_io),

    .i2c1_sda_io (i2c1_sda_io),
    .i2c1_scl_io (i2c1_scl_io),

    .spi0_sck_o  (spi0_sck_o),
    .spi0_mosi_o (spi0_mosi_o),
    .spi0_miso_i (spi0_miso_i),
    .spi0_ss_o   (spi0_ss_o),

    .spi1_sck_o  (spi1_sck_o),
    .spi1_mosi_o (spi1_mosi_o),
    .spi1_miso_i (spi1_miso_i),
    .spi1_ss_o   (spi1_ss_o),

    .spi2_sck_o  (spi2_sck_o),
    .spi2_mosi_o (spi2_mosi_o),
    .spi2_miso_i (spi2_miso_i),
    .spi2_ss_o   (spi2_ss_o),

    .accelerometer_cs_o  (accelerometer_cs_o),
    .accelerometer_irq_i (accelerometer_irq_i));
   
endmodule
