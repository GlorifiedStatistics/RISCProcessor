module tb_dm();

  parameter HALF_CLOCK = 5;
  parameter FULL_CLOCK = 2 * HALF_CLOCK;

  // Clock
  reg clk;
  
  // Data Memory
  reg		  reset;
  reg 		  mem_write;
  reg 	[7:0] rmi;
  reg 	[7:0] rmo;
  reg 	[7:0] rf_reg_out;
  reg 	[7:0] dm_out;
  
  DM dm(.*);
  

  initial begin

    reset = 1'b1;
    #FULL_CLOCK
    reset = 1'b0;

    rmo = 8'd10;
    rf_reg_out = 8'd155;
    mem_write = 1'b1;

    #FULL_CLOCK
    mem_write = 1'b0;
    
    if (dm.core[10] != 8'd155) $display("Error in 1: %b", dm.core[10]);
    
    rmi = 8'd10;
	#HALF_CLOCK
    if (dm_out != 8'd155) $display("Error in 2: %b", dm_out);
    
    
    $display("Testbench Complete");
    #3 $stop;
  end

  always begin
    #HALF_CLOCK clk = 1'b1;
    #HALF_CLOCK clk = 1'b0;
  end
  
endmodule