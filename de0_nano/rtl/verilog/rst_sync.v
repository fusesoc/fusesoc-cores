module rst_sync
  #(parameter STAGES = 2)
  (input clk_i,
   input  rst_i,
   output rst_o);

   reg [STAGES:0] rst_shr;

   assign rst_o = rst_shr[STAGES];
   
   always @(posedge clk_i or posedge rst_i)
     if (rst_i)
       rst_shr <= {(STAGES+1){1'b1}};
     else
       rst_shr <= {rst_shr[STAGES-1:0], 1'b0};
endmodule
