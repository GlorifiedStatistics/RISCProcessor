module PC (
  input wire          clk,
  input wire          reset,
  input wire          pc_update,
  input wire 		  pc_bns,
  input wire 		  pc_bcz,
  input wire          pc_inc2,
  input wire 	[7:0] rjls,
  input wire 	[7:0] rjni,
  input wire 	[7:0] ri,
  input wire 	[7:0] rsi,
  input wire 	[7:0] rpct,
  output wire 	[7:0] pc
);

  reg [7:0] pc_internal;

  always_ff @(posedge clk)
    if (reset) pc_internal <= 8'd0;
    else if (~pc_update) pc_internal <= pc_internal;
    else if (pc_inc2) pc_internal <= pc_internal + 2;
    else if (pc_bns & (ri != rsi)) pc_internal <= rjls;
    else if (pc_bcz & (rpct == 8'd0)) pc_internal <= rjni;
    else pc_internal <= pc_internal + 1;

  assign pc = pc_internal;

endmodule