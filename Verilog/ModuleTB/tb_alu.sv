module tb_alu();

  // ALU
  reg [7:0] rf_reg_out;
  reg [7:0] rpct;
  reg [7:0] rlsb;
  reg [7:0] rmsb;
  reg [7:0] rptn;
  reg [3:0] alu_op;

  reg [7:0] alu_out;

  ALU alu(.*);

  initial begin

    // Testing: inc
    alu_op = 4'b0100;

    rf_reg_out = 8'd0;
    if (alu_out != 8'd1) $display("Error in 1: %b", alu_out);

    rf_reg_out = 8'd127;
    if (alu_out != 8'd128) $display("Error in 2: %b", alu_out);

    rf_reg_out = 8'd255;
    if (alu_out != 8'd0) $display("Error in 3: %b", alu_out);


    // Testing: hgp, hel, hem. Values taken from python simulator
    alu_op = 4'b0111;
    rlsb = 8'b10101001;
    rmsb = 8'b00000111;

    if (alu_out != 8'b000_11100) $display("Error in 4: %b", alu_out);
    rpct = alu_out;
    alu_op = 4'b1000;
    if (alu_out != 8'b1001_1100) $display("Error in 5: %b", alu_out);
    alu_op = 4'b1001;
    if (alu_out != 8'b1111_0101) $display("Error in 6: %b", alu_out);



    alu_op = 4'b0111;
    rlsb = 8'b10011100;
    rmsb = 8'b00000000;

    if (alu_out != 8'b000_01001) $display("Error in 7: %b", alu_out);
    rpct = alu_out;
    alu_op = 4'b1000;
    if (alu_out != 8'b1101_0001) $display("Error in 8: %b", alu_out);
    alu_op = 4'b1001;
    if (alu_out != 8'b0001_0010) $display("Error in 9: %b", alu_out);



    alu_op = 4'b0111;
    rlsb = 8'b00000000;
    rmsb = 8'b00000000;

    if (alu_out != 8'b000_00000) $display("Error in 10: %b", alu_out);
    rpct = alu_out;
    alu_op = 4'b1000;
    if (alu_out != 8'b0000_0000) $display("Error in 11: %b", alu_out);
    alu_op = 4'b1001;
    if (alu_out != 8'b0000_0000) $display("Error in 12: %b", alu_out);



    alu_op = 4'b0111;
    rlsb = 8'b11111111;
    rmsb = 8'b00000101;

    if (alu_out != 8'b000_00011) $display("Error in 13: %b", alu_out);
    rpct = alu_out;
    alu_op = 4'b1000;
    if (alu_out != 8'b1110_1011) $display("Error in 14: %b", alu_out);
    alu_op = 4'b1001;
    if (alu_out != 8'b1011_1110) $display("Error in 15: %b", alu_out);


    // Testing: hep, hcl, hcm. Values taken from above and calculated manually

    // no change
    alu_op = 4'b1010;
    rlsb = 8'b1001_1100;
    rmsb = 8'b1111_0101;
    if (alu_out != 8'b000_00000) $display("Error in 16: %b", alu_out);
    rpct = alu_out;
    alu_op = 4'b1011;
    if (alu_out != 8'b1010_1001) $display("Error in 17: %b", alu_out);
    alu_op = 4'b1100;
    if (alu_out != 8'b0000_0111) $display("Error in 18: %b", alu_out);

    // 1 bit change
    alu_op = 4'b1010;
    rlsb = 8'b1101_0001;
    rmsb = 8'b0011_0010;
    if (alu_out != 8'b000_11011) $display("Error in 19: %b", alu_out);
    rpct = alu_out;
    alu_op = 4'b1011;
    if (alu_out != 8'b1001_1100) $display("Error in 20: %b", alu_out);
    alu_op = 4'b1100;
    if (alu_out != 8'b0000_0000) $display("Error in 21: %b", alu_out);

    // 2 bit change
    alu_op = 4'b1010;
    rlsb = 8'b0100_0000;
    rmsb = 8'b0000_0100;
    if (alu_out != 8'b000_11000) $display("Error in 22: %b", alu_out);
    rpct = alu_out;
    alu_op = 4'b1011;
    if (alu_out != 8'b1010_0100) $display("Error in 23: %b", alu_out);
    alu_op = 4'b1100;
    if (alu_out != 8'b1000_0000) $display("Error in 24: %b", alu_out);
    
    
    // pob, ptb
    rlsb = 8'b11011011;
    rmsb = 8'b01111011;
    rptn = 8'b11011_000;

    alu_op = 4'b1101;
    if (alu_out != 8'b0000_0010) $display("Error in 25: %b", alu_out);
    alu_op = 4'b1110;
    if (alu_out != 8'b0000_0001) $display("Error in 26: %b", alu_out);

    rlsb = 8'b00000000;
    rmsb = 8'b11111111;
    rptn = 8'b00000_000;

    alu_op = 4'b1101;
    if (alu_out != 8'b0000_0100) $display("Error in 27: %b", alu_out);
    alu_op = 4'b1110;
    if (alu_out != 8'b0000_0000) $display("Error in 28: %b", alu_out);

    rlsb = 8'b11110000;
    rmsb = 8'b00001111;
    rptn = 8'b00000_000;

    alu_op = 4'b1101;
    if (alu_out != 8'b0000_0000) $display("Error in 29: %b", alu_out);
    alu_op = 4'b1110;
    if (alu_out != 8'b0000_0100) $display("Error in 30: %b", alu_out);

    rlsb = 8'b11111111;
    rmsb = 8'b11111111;
    rptn = 8'b00000_000;

    alu_op = 4'b1101;
    if (alu_out != 8'b0000_0000) $display("Error in 31: %b", alu_out);
    alu_op = 4'b1110;
    if (alu_out != 8'b0000_0000) $display("Error in 32: %b", alu_out);


    // apc
    alu_op = 4'b1111;

    rf_reg_out = 8'b0000_0000;
    rpct = 8'b0000_0000;
    if (alu_out != 8'b0000_0000) $display("Error in 33: %b", alu_out);

    rf_reg_out = 8'b0000_0100;
    rpct = 8'b0000_1000;
    if (alu_out != 8'b0000_1100) $display("Error in 34: %b", alu_out);

    rf_reg_out = 8'b0000_0001;
    rpct = 8'b0000_0000;
    if (alu_out != 8'b0000_0001) $display("Error in 33: %b", alu_out);


    $display("Testbench Complete");
    #10 $stop;
  end

endmodule