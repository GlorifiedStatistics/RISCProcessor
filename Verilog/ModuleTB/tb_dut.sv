module tb_dut ();

  parameter HALF_CLOCK = 5;
  parameter FULL_CLOCK = 2 * HALF_CLOCK;
  
  // Clock
  reg clk;

  reg reset;
  reg req;
  reg ack;

  DUT dut(.*);

  initial begin

    // Do the reset first!
    reset = 1'b1;
    #FULL_CLOCK
    reset = 1'b0;
    #FULL_CLOCK

    // Load a simple program that tests all of the commands
    dut.ir1.core[0] = 9'b000100001;
    dut.ir1.core[1] = 9'b000001010;
    dut.ir1.core[2] = 9'b000100010;
    dut.ir1.core[3] = 9'b000011110;
    dut.ir1.core[4] = 9'b000100000;
    dut.ir1.core[5] = 9'b000000000;
    dut.ir1.core[6] = 9'b000100011;
    dut.ir1.core[7] = 9'b000000010;
    dut.ir1.core[8] = 9'b000100100;
    dut.ir1.core[9] = 9'b000001010;
    dut.ir1.core[10] = 9'b001000101;
    dut.ir1.core[11] = 9'b010000001;
    dut.ir1.core[12] = 9'b001000110;
    dut.ir1.core[13] = 9'b011100111;
    dut.ir1.core[14] = 9'b100001000;
    dut.ir1.core[15] = 9'b001101000;
    dut.ir1.core[16] = 9'b010000010;
    dut.ir1.core[17] = 9'b100101000;
    dut.ir1.core[18] = 9'b001101000;
    dut.ir1.core[19] = 9'b010000010;
    dut.ir1.core[20] = 9'b010000001;
    dut.ir1.core[21] = 9'b010000000;
    dut.ir1.core[22] = 9'b010100000;
    dut.ir1.core[23] = 9'b000100001;
    dut.ir1.core[24] = 9'b000011110;
    dut.ir1.core[25] = 9'b000100010;
    dut.ir1.core[26] = 9'b000111100;
    dut.ir1.core[27] = 9'b000100000;
    dut.ir1.core[28] = 9'b000000000;
    dut.ir1.core[29] = 9'b000100011;
    dut.ir1.core[30] = 9'b000000100;
    dut.ir1.core[31] = 9'b000100100;
    dut.ir1.core[32] = 9'b000100001;
    dut.ir1.core[33] = 9'b001000101;
    dut.ir1.core[34] = 9'b010000001;
    dut.ir1.core[35] = 9'b001000110;
    dut.ir1.core[36] = 9'b101000111;
    dut.ir1.core[37] = 9'b101101000;
    dut.ir1.core[38] = 9'b001101000;
    dut.ir1.core[39] = 9'b010000010;
    dut.ir1.core[40] = 9'b110001000;
    dut.ir1.core[41] = 9'b001101000;
    dut.ir1.core[42] = 9'b010000010;
    dut.ir1.core[43] = 9'b010000001;
    dut.ir1.core[44] = 9'b010000000;
    dut.ir1.core[45] = 9'b010100000;
    dut.ir1.core[46] = 9'b000100101;
    dut.ir1.core[47] = 9'b011011011;
    dut.ir1.core[48] = 9'b000100110;
    dut.ir1.core[49] = 9'b001101101;
    dut.ir1.core[50] = 9'b000100010;
    dut.ir1.core[51] = 9'b001011010;
    dut.ir1.core[52] = 9'b000101001;
    dut.ir1.core[53] = 9'b011011000;
    dut.ir1.core[54] = 9'b000101010;
    dut.ir1.core[55] = 9'b001000010;
    dut.ir1.core[56] = 9'b000101011;
    dut.ir1.core[57] = 9'b000000000;
    dut.ir1.core[58] = 9'b000101100;
    dut.ir1.core[59] = 9'b000000000;
    dut.ir1.core[60] = 9'b000101101;
    dut.ir1.core[61] = 9'b000000000;
    dut.ir1.core[62] = 9'b110100111;
    dut.ir1.core[63] = 9'b011000000;
    dut.ir1.core[64] = 9'b111101011;
    dut.ir1.core[65] = 9'b010001100;
    dut.ir1.core[66] = 9'b111000111;
    dut.ir1.core[67] = 9'b111101101;
    dut.ir1.core[68] = 9'b001101011;
    dut.ir1.core[69] = 9'b010000010;
    dut.ir1.core[70] = 9'b001101100;
    dut.ir1.core[71] = 9'b010000010;
    dut.ir1.core[72] = 9'b001101101;
    dut.ir1.core[73] = 9'b000000000;
    dut.ir1.core[74] = 9'b000101000;
    dut.ir1.core[75] = 9'b000001010;
    dut.ir1.core[76] = 9'b000100010;
    dut.ir1.core[77] = 9'b010111110;
    dut.ir1.core[78] = 9'b001101000;
    dut.ir1.core[79] = 9'b000000000;

    // Setup the memory for it
    dut.dm1.core[10] = 8'b00011101;
    dut.dm1.core[11] = 8'b00000110;
    dut.dm1.core[12] = 8'b11011000;
    dut.dm1.core[13] = 8'b00000000;
    dut.dm1.core[34] = 8'b10100101;
    dut.dm1.core[35] = 8'b11011111;
    dut.dm1.core[36] = 8'b01000000;
    dut.dm1.core[37] = 8'b00000100;

    // Initial program and wait for ack
    req = 1'b1;
    #FULL_CLOCK
    req = 1'b0;
    wait(ack);

    // The final values
    if (dut.dm1.core[30] != 8'b11001100) $display("Error in DUT 1: %b", dut.dm1.core[30]);
    if (dut.dm1.core[31] != 8'b11000011) $display("Error in DUT 2: %b", dut.dm1.core[31]);
    if (dut.dm1.core[32] != 8'b10000010) $display("Error in DUT 3: %b", dut.dm1.core[32]);
    if (dut.dm1.core[33] != 8'b00011011) $display("Error in DUT 4: %b", dut.dm1.core[33]);

    if (dut.dm1.core[60] != 8'b00011101) $display("Error in DUT 5: %b", dut.dm1.core[60]);
    if (dut.dm1.core[61] != 8'b00000110) $display("Error in DUT 6: %b", dut.dm1.core[61]);
    if (dut.dm1.core[62] != 8'b11011000) $display("Error in DUT 7: %b", dut.dm1.core[62]);
    if (dut.dm1.core[63] != 8'b00000000) $display("Error in DUT 8: %b", dut.dm1.core[63]);
    if (dut.dm1.core[64] != 8'b11111010) $display("Error in DUT 9: %b", dut.dm1.core[64]);
    if (dut.dm1.core[65] != 8'b00000111) $display("Error in DUT 10: %b", dut.dm1.core[65]);
    if (dut.dm1.core[66] != 8'b10100100) $display("Error in DUT 11: %b", dut.dm1.core[66]);
    if (dut.dm1.core[67] != 8'b10000000) $display("Error in DUT 12: %b", dut.dm1.core[67]);

    if (dut.dm1.core[90] != 8'd2) $display("Error in DUT 13: %b", dut.dm1.core[90]);
    if (dut.dm1.core[91] != 8'd1) $display("Error in DUT 14: %b", dut.dm1.core[91]);
    if (dut.dm1.core[92] != 8'd1) $display("Error in DUT 15: %b", dut.dm1.core[92]);

    // Second program and wait for ack
    req = 1'b1;
    #FULL_CLOCK
    req = 1'b0;
    wait(ack);

    if (dut.dm1.core[190] != 8'd10) $display("Error in DUT 16: %b", dut.dm1.core[92]);

    $display("Testing Complete");
    #10 $stop;
  end

  always begin
    #HALF_CLOCK clk = 1'b1;
    #HALF_CLOCK clk = 1'b0;
  end

endmodule