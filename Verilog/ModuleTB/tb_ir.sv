module tb_ir();

  // Instruction ROM
  reg   [7:0] pc;
  reg   [8:0] instruction;
  reg   [7:0] ld_val;
  
  IR inst(.*);
  
  initial begin

	pc = 9'd0;
    if (instruction != 9'b000100000) $display("Error in 1: %b", instruction);
    
    pc = 9'd57;
    if (instruction != 9'b000100011) $display("Error in 2: %b", instruction);
    
    pc = 9'd87;
    if (instruction != 9'b001101101) $display("Error in 3: %b", instruction);

    pc = 9'd88;
    if (instruction != 9'b000000000) $display("Error in 4: %b", instruction);

    pc = 9'd4;
    if (instruction != 9'b000100010) $display("Error in 5: %b", instruction);
    if (ld_val != 9'b00011110) $display("Error in 6: %b", ld_val);


    $display("Testbench Complete");
    #10 $stop;
  end

endmodule