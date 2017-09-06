module clkgen
  (// External input clock
   input  sys_clk_pad_i,

   // External input reset, active low
   input  rst_n_pad_i,

   // Wishbone clock and reset out
   output wb_clk_o,
   output wb_rst_o,

   // Main memory clocks
   output sdram_clk_o,
   output sdram_rst_o);

   wire pll_lock;

   pll pll0 
     (.areset	(~rst_n_pad_i),
      .inclk0	(sys_clk_pad_i),
      .c0	(sdram_clk_o),
      .c1	(wb_clk_o),
      .locked	(pll_lock));

   rst_sync #(.STAGES (16))
   wb_rst_sync
     (.clk_i (wb_clk_o),
      .rst_i (~pll_lock),
      .rst_o (wb_rst_o));
   
   rst_sync #(.STAGES (16))
   sdram_rst_sync
     (.clk_i (sdram_clk_o),
      .rst_i (~pll_lock),
      .rst_o (sdram_rst_o));

endmodule
