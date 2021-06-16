module tb_rf();

  parameter HALF_CLOCK = 5;
  parameter FULL_CLOCK = 2 * HALF_CLOCK;

  // Clock
  reg clk;
  
  // Register File
  reg 		  rf_write_reg;
  reg 	[3:0] rf_reg_in;
  reg 	[7:0] rf_write_data;
  reg	[7:0] rf_reg_out;
  reg	[7:0] rs [13:0];
  
  RF rf(.*);
  

  initial begin

    // Make sure they are cleared to 0's at the beginning
    integer i;
    for (i=0; i<=13; i+=1) if (rs[i] != 8'd0) $display("Error in clear %d: %b", i, rs[i]);
    
    // rpct
    rf_reg_in = 4'b0111;
    rf_write_data = 8'b0000_0010;
    rf_write_reg = 1'b1;
    #FULL_CLOCK
    rf_write_reg = 1'b0;

    if (rs[7] != 8'b0000_0010) $display("Error in 1: %b", rf_reg_out);
    if (rf_reg_out != 8'b0000_0010) $display("Error 2: %b", rf_reg_out);
    
    
    // rtbc
    rf_reg_in = 4'b1101;
    rf_write_data = 8'b0100_1010;
    rf_write_reg = 1'b1;
    #FULL_CLOCK
    rf_write_reg = 1'b0;

    if (rs[13] != 8'b0100_1010) $display("Error in 3: %b", rf_reg_out);
    if (rf_reg_out != 8'b0100_1010) $display("Error in 4: %b", rf_reg_out);
    
    
    // ri but don't write
    rf_reg_in = 4'b0111;
    #1
    if (rf_reg_out != rs[7]) $display("Error in 5: %b", rf_reg_out);
    if (rf_reg_out != 8'b0000_0010) $display("Error in 6: %b", rf_reg_out);
    
    $display("Testbench Complete");
    #10 $stop;
  end
  
  always begin
    #HALF_CLOCK clk = 1'b1;
    #HALF_CLOCK clk = 1'b0;
  end

endmodule