module tb_pc();

  parameter HALF_CLOCK = 5;
  parameter FULL_CLOCK = 2 * HALF_CLOCK;

  // Clock
  reg clk;

  // PC_UPDATE
  wire [7:0] pc;
  reg [7:0] rjls;
  reg [7:0] rjni;
  reg [7:0] ri;
  reg [7:0] rsi;
  reg [7:0] rpct;

  reg	    pc_bns;
  reg		pc_bcz;
  reg       pc_update;
  reg       pc_inc2;
  reg       reset;
  PC pc1 (.*);
    
    
  initial begin

    reset = 1'b1;
    #FULL_CLOCK
    reset = 1'b0;

    pc_bns = 1'b0;
    pc_bcz = 1'b0;
    pc_inc2 = 1'b0;
    pc_update = 1'b1;

    #FULL_CLOCK
    if (pc != 8'd1) $display("Error in 1: %d", pc);
    #FULL_CLOCK
    if (pc != 8'd2) $display("Error in 2: %d", pc);
    #FULL_CLOCK
    if (pc != 8'd3) $display("Error in 3: %d", pc);

    pc1.pc_internal = 8'd0;
    pc_bns = 1'b1;
    ri = 8'd33;
    rsi = 8'd57;
    rjls = 8'd66;
    #FULL_CLOCK
    if (pc != 8'd66) $display("Error in 4: %d", pc);
    
    ri = 8'd56;
    #FULL_CLOCK
    if (pc != 8'd66) $display("Error in 5: %d", pc);
    
    ri = 8'd58;
    #FULL_CLOCK
    if (pc != 8'd66) $display("Error in 6: %d", pc);
    
    ri = 8'd57;
    pc1.pc_internal = 8'd0;
    #FULL_CLOCK
    if (pc != 8'd1) $display("Error in 7: %d", pc);
    
    pc_bns = 1'b0;
    pc_bcz = 1'b1;
    rpct = 8'd1;
    rjni = 8'd55;
    pc1.pc_internal = 8'd0;
    #FULL_CLOCK
    if (pc != 8'd1) $display("Error in 8: %d", pc);
    
    rpct = 8'd0;
    #FULL_CLOCK
    if (pc != 8'd55) $display("Error in 9: %d", pc);
    
    pc_bcz = 1'b0;
    pc_update = 1'b0;
    pc1.pc_internal = 8'd0;
    #FULL_CLOCK
    if (pc != 8'd0) $display("Error in 10: %d", pc);

    pc_update = 1'b1;
    pc_inc2 = 1'b1;
    #FULL_CLOCK
    if (pc != 8'd2) $display("Error in pc_11: %d", pc);

    $display("Testbench Complete");
    #10 $stop;
  end

  always begin
    #HALF_CLOCK clk = 1'b1;
    #HALF_CLOCK clk = 1'b0;
  end

endmodule