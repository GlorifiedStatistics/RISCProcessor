module tb_ctrl();

  parameter HALF_CLOCK = 5;
  parameter FULL_CLOCK = 2 * HALF_CLOCK;
  
  // Clock
  reg clk;

  // Control
  reg [8:0] instruction;
  reg req;
  reg reset;
  
  reg pc_update;
  reg pc_bns;
  reg pc_bcz;
  reg pc_inc2;
  reg rf_write_reg;
  reg rf_din_dm;
  reg mem_write;
  reg rf_din_alu;
  reg ack;
  reg [3:0] alu_op;
  
  CTRL ctrl(.*);
  initial begin
  
    // Reset
    reset = 1'b1;
    #FULL_CLOCK
    reset = 1'b0;
    
    if (pc_update != 1'b0) $display("Error in control 1: %b", pc_update);
    if (rf_write_reg != 1'b0) $display("Error in control 2: %b", rf_write_reg);
    if (mem_write != 1'b0) $display("Error in control 3: %b", rf_write_reg);
    if (ack != 1'b1) $display("Error in control 3.5: %b", ack);
    
    // Turn on
    instruction = 9'b0101_00000; // bns so nothing should be on
    req = 1'b1;
    #FULL_CLOCK
    req = 1'b0;
    
    if (pc_update != 1'b1) $display("Error in control 4: %b", pc_update);
    if (pc_inc2 != 1'b0) $display("Error in control 4.5: %b", pc_inc2);
    if (rf_write_reg != 1'b0) $display("Error in control 5: %b", rf_write_reg);
    if (mem_write != 1'b0) $display("Error in control 6: %b", rf_write_reg);
    if (ack != 1'b0) $display("Error in control 6.5: %b", ack);
    
    // lrm
    instruction = 9'b0010_00000;
    #1
    if (pc_update != 1'b1) $display("Error in control 7: %b", pc_update);
    if (pc_inc2 != 1'b0) $display("Error in control 7.5: %b", pc_inc2);
    if (pc_bns != 1'b0) $display("Error in control 8: %b", pc_bns);
    if (pc_bcz != 1'b0) $display("Error in control 9: %b", pc_bcz);
    if (rf_write_reg != 1'b1) $display("Error in control 10: %b", rf_write_reg);
    if (rf_din_dm != 1'b1) $display("Error in control 11: %b", rf_din_dm);
    if (mem_write != 1'b0) $display("Error in control 12: %b", mem_write);
    if (rf_din_alu != 1'b0) $display("Error in control 13: %b", rf_din_alu);
    if (ack != 1'b0) $display("Error in control 14: %b", ack);
    
    // str
    instruction = 9'b0011_00000;
    #1
    if (pc_update != 1'b1) $display("Error in control 15: %b", pc_update);
    if (pc_inc2 != 1'b0) $display("Error in control 15.5: %b", pc_inc2);
    if (pc_bns != 1'b0) $display("Error in control 16: %b", pc_bns);
    if (pc_bcz != 1'b0) $display("Error in control 17: %b", pc_bcz);
    if (rf_write_reg != 1'b0) $display("Error in control 18: %b", rf_write_reg);
    if (mem_write != 1'b1) $display("Error in control 19: %b", mem_write);
    if (ack != 1'b0) $display("Error in control 20: %b", ack);
    
    // inc
    instruction = 9'b0100_00000;
    #1
    if (pc_update != 1'b1) $display("Error in control 21: %b", pc_update);
    if (pc_inc2 != 1'b0) $display("Error in control 21.5: %b", pc_inc2);
    if (pc_bns != 1'b0) $display("Error in control 22: %b", pc_bns);
    if (pc_bcz != 1'b0) $display("Error in control 23: %b", pc_bcz);
    if (rf_write_reg != 1'b1) $display("Error in control 24: %b", rf_write_reg);
    if (rf_din_dm != 1'b0) $display("Error in control 25: %b", rf_din_dm);
    if (alu_op != 4'b0100) $display("Error in control 26: %b", alu_op);
    if (mem_write != 1'b0) $display("Error in control 27: %b", mem_write);
    if (rf_din_alu != 1'b1) $display("Error in control 28: %b", rf_din_alu);
    if (ack != 1'b0) $display("Error in control 29: %b", ack);
    
    // bns
    instruction = 9'b0101_00000;
    #1
    if (pc_update != 1'b1) $display("Error in control 30: %b", pc_update);
    if (pc_inc2 != 1'b0) $display("Error in control 30.5: %b", pc_inc2);
    if (pc_bns != 1'b1) $display("Error in control 31: %b", pc_bns);
    if (pc_bcz != 1'b0) $display("Error in control 32: %b", pc_bcz);
    if (rf_write_reg != 1'b0) $display("Error in control 33: %b", rf_write_reg);
    if (mem_write != 1'b0) $display("Error in control 34: %b", mem_write);
    if (ack != 1'b0) $display("Error in control 35: %b", ack);
    
    // bcz
    instruction = 9'b0110_00000;
    #1
    if (pc_update != 1'b1) $display("Error in control 36: %b", pc_update);
    if (pc_inc2 != 1'b0) $display("Error in control 36.5: %b", pc_inc2);
    if (pc_bns != 1'b0) $display("Error in control 37: %b", pc_bns);
    if (pc_bcz != 1'b1) $display("Error in control 38: %b", pc_bcz);
    if (rf_write_reg != 1'b0) $display("Error in control 39: %b", rf_write_reg);
    if (mem_write != 1'b0) $display("Error in control 40: %b", mem_write);
    if (ack != 1'b0) $display("Error in control 41: %b", ack);
    
    // hgp
    instruction = 9'b0111_00000;
    #1
    if (pc_update != 1'b1) $display("Error in control 42: %b", pc_update);
    if (pc_inc2 != 1'b0) $display("Error in control 42.5: %b", pc_inc2);
    if (pc_bns != 1'b0) $display("Error in control 43: %b", pc_bns);
    if (pc_bcz != 1'b0) $display("Error in control 44: %b", pc_bcz);
    if (rf_write_reg != 1'b1) $display("Error in control 45: %b", rf_write_reg);
    if (rf_din_dm != 1'b0) $display("Error in control 46: %b", rf_din_dm);
    if (alu_op != 4'b0111) $display("Error in control 47: %b", alu_op);
    if (mem_write != 1'b0) $display("Error in control 48: %b", mem_write);
    if (rf_din_alu != 1'b1) $display("Error in control 49: %b", rf_din_alu);
    if (ack != 1'b0) $display("Error in control 50: %b", ack);
    
    // hel
    instruction = 9'b1000_00000;
    #1
    if (pc_update != 1'b1) $display("Error in control 51: %b", pc_update);
    if (pc_inc2 != 1'b0) $display("Error in control 51.5: %b", pc_inc2);
    if (pc_bns != 1'b0) $display("Error in control 52: %b", pc_bns);
    if (pc_bcz != 1'b0) $display("Error in control 53: %b", pc_bcz);
    if (rf_write_reg != 1'b1) $display("Error in control 54: %b", rf_write_reg);
    if (rf_din_dm != 1'b0) $display("Error in control 55: %b", rf_din_dm);
    if (alu_op != 4'b1000) $display("Error in control 56: %b", alu_op);
    if (mem_write != 1'b0) $display("Error in control 57: %b", mem_write);
    if (rf_din_alu != 1'b1) $display("Error in control 58: %b", rf_din_alu);
    if (ack != 1'b0) $display("Error in control 59: %b", ack);
    
    // hem
    instruction = 9'b1001_00000;
    #1
    if (pc_update != 1'b1) $display("Error in control 60: %b", pc_update);
    if (pc_inc2 != 1'b0) $display("Error in control 60.5: %b", pc_inc2);
    if (pc_bns != 1'b0) $display("Error in control 61: %b", pc_bns);
    if (pc_bcz != 1'b0) $display("Error in control 62: %b", pc_bcz);
    if (rf_write_reg != 1'b1) $display("Error in control 63: %b", rf_write_reg);
    if (rf_din_dm != 1'b0) $display("Error in control 64: %b", rf_din_dm);
    if (alu_op != 4'b1001) $display("Error in control 65: %b", alu_op);
    if (mem_write != 1'b0) $display("Error in control 66: %b", mem_write);
    if (rf_din_alu != 1'b1) $display("Error in control 67: %b", rf_din_alu);
    if (ack != 1'b0) $display("Error in control 68: %b", ack);
    
    // hep
    instruction = 9'b1010_00000;
    #1
    if (pc_update != 1'b1) $display("Error in control 69: %b", pc_update);
    if (pc_inc2 != 1'b0) $display("Error in control 69.5: %b", pc_inc2);
    if (pc_bns != 1'b0) $display("Error in control 70: %b", pc_bns);
    if (pc_bcz != 1'b0) $display("Error in control 71: %b", pc_bcz);
    if (rf_write_reg != 1'b1) $display("Error in control 72: %b", rf_write_reg);
    if (rf_din_dm != 1'b0) $display("Error in control 73: %b", rf_din_dm);
    if (alu_op != 4'b1010) $display("Error in control 74: %b", alu_op);
    if (mem_write != 1'b0) $display("Error in control 75: %b", mem_write);
    if (rf_din_alu != 1'b1) $display("Error in control 76: %b", rf_din_alu);
    if (ack != 1'b0) $display("Error in control 77: %b", ack);
    
    // hcl
    instruction = 9'b1011_00000;
    #1
    if (pc_update != 1'b1) $display("Error in control 78: %b", pc_update);
    if (pc_inc2 != 1'b0) $display("Error in control 78.5: %b", pc_inc2);
    if (pc_bns != 1'b0) $display("Error in control 79: %b", pc_bns);
    if (pc_bcz != 1'b0) $display("Error in control 80: %b", pc_bcz);
    if (rf_write_reg != 1'b1) $display("Error in control 81: %b", rf_write_reg);
    if (rf_din_dm != 1'b0) $display("Error in control 82: %b", rf_din_dm);
    if (alu_op != 4'b1011) $display("Error in control 83: %b", alu_op);
    if (mem_write != 1'b0) $display("Error in control 84: %b", mem_write);
    if (rf_din_alu != 1'b1) $display("Error in control 85: %b", rf_din_alu);
    if (ack != 1'b0) $display("Error in control 86: %b", ack);
    
    // hcm
    instruction = 9'b1100_00000;
    #1
    if (pc_update != 1'b1) $display("Error in control 87: %b", pc_update);
    if (pc_inc2 != 1'b0) $display("Error in control 87.5: %b", pc_inc2);
    if (pc_bns != 1'b0) $display("Error in control 88: %b", pc_bns);
    if (pc_bcz != 1'b0) $display("Error in control 89: %b", pc_bcz);
    if (rf_write_reg != 1'b1) $display("Error in control 90: %b", rf_write_reg);
    if (rf_din_dm != 1'b0) $display("Error in control 91: %b", rf_din_dm);
    if (alu_op != 4'b1100) $display("Error in control 92: %b", alu_op);
    if (mem_write != 1'b0) $display("Error in control 93: %b", mem_write);
    if (rf_din_alu != 1'b1) $display("Error in control 94: %b", rf_din_alu);
    if (ack != 1'b0) $display("Error in control 95: %b", ack);
    
    // pob
    instruction = 9'b1101_00000;
    #1
    if (pc_update != 1'b1) $display("Error in control 96: %b", pc_update);
    if (pc_inc2 != 1'b0) $display("Error in control 96.5: %b", pc_inc2);
    if (pc_bns != 1'b0) $display("Error in control 97: %b", pc_bns);
    if (pc_bcz != 1'b0) $display("Error in control 98: %b", pc_bcz);
    if (rf_write_reg != 1'b1) $display("Error in control 99: %b", rf_write_reg);
    if (rf_din_dm != 1'b0) $display("Error in control 100: %b", rf_din_dm);
    if (alu_op != 4'b1101) $display("Error in control 101: %b", alu_op);
    if (mem_write != 1'b0) $display("Error in control 102: %b", mem_write);
    if (rf_din_alu != 1'b1) $display("Error in control 103: %b", rf_din_alu);
    if (ack != 1'b0) $display("Error in control 104: %b", ack);
    
    // ptb
    instruction = 9'b1110_00000;
    #1
    if (pc_update != 1'b1) $display("Error in control 105: %b", pc_update);
    if (pc_inc2 != 1'b0) $display("Error in control 105.5: %b", pc_inc2);
    if (pc_bns != 1'b0) $display("Error in control 106: %b", pc_bns);
    if (pc_bcz != 1'b0) $display("Error in control 107: %b", pc_bcz);
    if (rf_write_reg != 1'b1) $display("Error in control 108: %b", rf_write_reg);
    if (rf_din_dm != 1'b0) $display("Error in control 109: %b", rf_din_dm);
    if (alu_op != 4'b1110) $display("Error in control 110: %b", alu_op);
    if (mem_write != 1'b0) $display("Error in control 111: %b", mem_write);
    if (rf_din_alu != 1'b1) $display("Error in control 112: %b", rf_din_alu);
    if (ack != 1'b0) $display("Error in control 113: %b", ack);
    
    // apc
    instruction = 9'b1111_00000;
    #1
    if (pc_update != 1'b1) $display("Error in control 114: %b", pc_update);
    if (pc_inc2 != 1'b0) $display("Error in control 114.5: %b", pc_inc2);
    if (pc_bns != 1'b0) $display("Error in control 115: %b", pc_bns);
    if (pc_bcz != 1'b0) $display("Error in control 116: %b", pc_bcz);
    if (rf_write_reg != 1'b1) $display("Error in control 117: %b", rf_write_reg);
    if (rf_din_dm != 1'b0) $display("Error in control 118: %b", rf_din_dm);
    if (alu_op != 4'b1111) $display("Error in control 119: %b", alu_op);
    if (mem_write != 1'b0) $display("Error in control 120: %b", mem_write);
    if (rf_din_alu != 1'b1) $display("Error in control 121: %b", rf_din_alu);
    if (ack != 1'b0) $display("Error in control 122: %b", ack);
    
    //lrv
    instruction = 9'b0001_00000;
    #1

    if (pc_update != 1'b1) $display("Error in control 123: %b", pc_update);
    if (pc_inc2 != 1'b1) $display("Error in control 123.5: %b", pc_inc2);
    if (pc_bns != 1'b0) $display("Error in control 124: %b", pc_bns);
    if (pc_bcz != 1'b0) $display("Error in control 125: %b", pc_bcz);
    if (rf_write_reg != 1'b1) $display("Error in control 126: %b", rf_write_reg);
    if (rf_din_dm != 1'b0) $display("Error in control 127: %b", rf_din_dm);
    if (mem_write != 1'b0) $display("Error in control 128: %b", mem_write);
    if (rf_din_alu != 1'b0) $display("Error in control 129: %b", rf_din_alu);
    if (ack != 1'b0) $display("Error in control 130: %b", ack);
    
    // end
    instruction = 9'b0000_00000;
    #FULL_CLOCK

    if (pc_update != 1'b0) $display("Error in control 131: %b", pc_update);
    if (rf_write_reg != 1'b0) $display("Error in control 132: %b", rf_write_reg);
    if (mem_write != 1'b0) $display("Error in control 133: %b", mem_write);
    if (ack != 1'b1) $display("Error in control 134: %b", ack);

    req = 1'b1;
    instruction = 9'b0001_00000;
    #FULL_CLOCK

    if (pc_update != 1'b1) $display("Error in control 135: %b", pc_update);
    if (pc_inc2 != 1'b1) $display("Error in control 136.5: %b", pc_inc2);
    if (pc_bns != 1'b0) $display("Error in control 137: %b", pc_bns);
    if (pc_bcz != 1'b0) $display("Error in control 138: %b", pc_bcz);
    if (rf_write_reg != 1'b1) $display("Error in control 139: %b", rf_write_reg);
    if (rf_din_dm != 1'b0) $display("Error in control 140: %b", rf_din_dm);
    if (mem_write != 1'b0) $display("Error in control 141: %b", mem_write);
    if (rf_din_alu != 1'b0) $display("Error in control 142: %b", rf_din_alu);
    if (ack != 1'b0) $display("Error in control 143: %b", ack);
    
    $display("Testbench Complete");
    #10 $stop;
  end
  
  always begin
    #HALF_CLOCK clk = 1'b1;
    #HALF_CLOCK clk = 1'b0;
  end

endmodule