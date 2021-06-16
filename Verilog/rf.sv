module RF (
  input wire		  clk,
  input wire		  rf_write_reg,
  input wire	[3:0] rf_reg_in,
  input wire	[7:0] rf_write_data,
  output reg    [7:0] rs [13:0],
  output reg	[7:0] rf_reg_out
);

  // The output reg
  assign rf_reg_out = rs[rf_reg_in];

  // Writing to input reg, or clearing reg's if reset
  always @(posedge clk) if (rf_write_reg) rs[rf_reg_in] = rf_write_data;

  // Clear out the registers so the test bench works well
  integer i;
  initial begin
    for (i=0; i<=13; i+=1) rs[i] = 8'd0;
  end

endmodule