/*
 * Simple 8-bit wide GPIO module
 *
 * First byte is the GPIO I/O reg
 * Second is the direction register
 *
 * Set direction bit to '1' to output corresponding data bit.
 *
 * Register mapping:
 *
 * adr 0: gpio data 7:0
 * adr 1: gpio dir 7:0
 */

module gpio
       (
	input			wb_clk,
	input			wb_rst,

	input			wb_adr_i,
	input		[7:0] 	wb_dat_i,
	input			wb_we_i,
	input			wb_cyc_i,
	input			wb_stb_i,
	input		[2:0] 	wb_cti_i,
	input		[1:0]	wb_bte_i,
	output reg	[7:0]	wb_dat_o,
	output reg		wb_ack_o,
	output			wb_err_o,
	output			wb_rty_o,

	input		[7:0]	gpio_i,
	output reg	[7:0]	gpio_o,
	output reg	[7:0]	gpio_dir_o
);


// GPIO dir register
always @(posedge wb_clk)
	if (wb_rst)
		gpio_dir_o <= 0; // All set to in at reset
	else if (wb_cyc_i & wb_stb_i & wb_we_i) begin
		if (wb_adr_i == 1)
			gpio_dir_o[7:0] <= wb_dat_i;
	end


// GPIO data out register
always @(posedge wb_clk)
	if (wb_rst)
		gpio_o <= 0;
	else if (wb_cyc_i & wb_stb_i & wb_we_i) begin
		if (wb_adr_i == 0)
			gpio_o[7:0] <= wb_dat_i;
	end


// Register the gpio in signal
always @(posedge wb_clk) begin
	// Data regs
	if (wb_adr_i == 0)
		wb_dat_o[7:0] <= gpio_i[7:0];

	// Direction regs
	if (wb_adr_i == 1)
		wb_dat_o[7:0] <= gpio_dir_o[7:0];
     end

// Ack generation
always @(posedge wb_clk)
	if (wb_rst)
		wb_ack_o <= 0;
	else if (wb_ack_o)
		wb_ack_o <= 0;
	else if (wb_cyc_i & wb_stb_i & !wb_ack_o)
		wb_ack_o <= 1;

assign wb_err_o = 0;
assign wb_rty_o = 0;

endmodule
