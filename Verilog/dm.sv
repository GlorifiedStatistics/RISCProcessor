module DM (
  input wire          clk,
  input wire		  mem_write,
  input wire	[7:0] rmi,
  input wire	[7:0] rmo,
  input wire	[7:0] rf_reg_out,
  output wire	[7:0] dm_out
);
  
  reg	[7:0] core [255:0];
  
  // The writing
  always_ff @(posedge clk) if (mem_write) core[rmo] = rf_reg_out;
  
  // The reading
  assign dm_out = core[rmi];

endmodule