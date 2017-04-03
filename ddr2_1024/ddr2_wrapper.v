module ddr2_1024_wrapper
  #(parameter mem_bits = 10)
   (input 	load_memory,
    input        ck,
    input        ck_n,
    input        cke,
    input        cs_n,
    input        ras_n,
    input        cas_n,
    input        we_n,
    inout [1:0]  dm_rdqs,
    input [2:0]  ba,
    input [12:0] addr,
    inout [15:0] dq,
    inout [1:0]  dqs,
    inout [1:0]  dqs_n);

   ddr2
     #(.DEBUG (0),
       .MEM_BITS (mem_bits))
   mem_model
     (.ck      (ck),
      .ck_n    (ck_n),
      .cke     (cke),
      .cs_n    (cs_n),
      .ras_n   (ras_n),
      .cas_n   (cas_n),
      .we_n    (we_n),
      .dm_rdqs (dm_rdqs),
      .ba      (ba),
      .addr    (addr),
      .dq      (dq),
      .dqs     (dqs),
      .dqs_n   (dqs_n),
      .rdqs_n  (),
      .odt     (1'b0));

`ifndef DDR2_1024_DISABLE_VPI
   ////////////////////////////////////////////////////////////////////////
   //
   // ELF program loading
   //
   ////////////////////////////////////////////////////////////////////////
   integer mem_words;
   integer i;
   reg [1023:0] elf_file;
   reg [127:0] 	ram_word;
   reg [1:0] 	ram_word_idx;
   reg [2:0] 	ram_bank;
   reg [12:0] 	ram_row;
   reg [9:0] 	ram_col;

   initial begin
      if($value$plusargs("elf_load=%s", elf_file)) begin
	 $elf_load_file(elf_file);
	 mem_words = $elf_get_size/4;
	 $display("ELF loader: Reading %0d words from file", mem_words);
	 #1000 $display("ELF loader waiting for memory init done");
	 @(posedge load_memory)

	 $display("Writing ELF file to memory");
	 for(i=0; i < mem_words; i = i+1) begin
	    ram_word_idx = i[1:0];
	    ram_word[ram_word_idx*32+:32] = $elf_read_32(i*4);
	    {ram_bank, ram_row, ram_col} = i*2;
	    if(ram_word_idx == 3) begin
	       mem_model.memory_write(ram_bank, ram_row, ram_col, ram_word);
	       ram_word = 0;
	    end
	 end
	 if (ram_word_idx != 3)
	   mem_model.memory_write(ram_bank, ram_row, ram_col, ram_word);
      end else
	$display("No ELF file specified");
   end
`endif
endmodule
