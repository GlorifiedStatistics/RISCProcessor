// This file auto-generated
module IR (
  input wire    [7:0] pc,
  output wire   [7:0] ld_val,
  output wire	[8:0] instruction
);

  logic [8:0] core[255];
  assign instruction = core[pc];
  assign ld_val = core[pc + 1][7:0];

  // Loading the file not working for some reason, "no such file"
  initial begin
    core[0] = 9'b000100000;
    core[1] = 9'b000000000;
    core[2] = 9'b000100001;
    core[3] = 9'b000000000;
    core[4] = 9'b000100010;
    core[5] = 9'b000011110;
    core[6] = 9'b000100011;
    core[7] = 9'b000001111;
    core[8] = 9'b000100100;
    core[9] = 9'b000001010;
    core[10] = 9'b001000101;
    core[11] = 9'b010000001;
    core[12] = 9'b001000110;
    core[13] = 9'b011100111;
    core[14] = 9'b100001000;
    core[15] = 9'b001101000;
    core[16] = 9'b010000010;
    core[17] = 9'b100101000;
    core[18] = 9'b001101000;
    core[19] = 9'b010000000;
    core[20] = 9'b010000001;
    core[21] = 9'b010000010;
    core[22] = 9'b010100000;
    core[23] = 9'b000000000;
    core[24] = 9'b000100000;
    core[25] = 9'b000000000;
    core[26] = 9'b000100001;
    core[27] = 9'b001000000;
    core[28] = 9'b000100010;
    core[29] = 9'b001011110;
    core[30] = 9'b000100011;
    core[31] = 9'b000001111;
    core[32] = 9'b000100100;
    core[33] = 9'b000100010;
    core[34] = 9'b001000101;
    core[35] = 9'b010000001;
    core[36] = 9'b001000110;
    core[37] = 9'b101000111;
    core[38] = 9'b101101000;
    core[39] = 9'b001101000;
    core[40] = 9'b010000010;
    core[41] = 9'b110001000;
    core[42] = 9'b001101000;
    core[43] = 9'b010000000;
    core[44] = 9'b010000001;
    core[45] = 9'b010000010;
    core[46] = 9'b010100000;
    core[47] = 9'b000000000;
    core[48] = 9'b000100000;
    core[49] = 9'b000000000;
    core[50] = 9'b000100001;
    core[51] = 9'b010100000;
    core[52] = 9'b001001001;
    core[53] = 9'b000100001;
    core[54] = 9'b010000000;
    core[55] = 9'b000100010;
    core[56] = 9'b011000000;
    core[57] = 9'b000100011;
    core[58] = 9'b000011111;
    core[59] = 9'b000100100;
    core[60] = 9'b001000101;
    core[61] = 9'b000101010;
    core[62] = 9'b001001101;
    core[63] = 9'b000101011;
    core[64] = 9'b000000000;
    core[65] = 9'b000101100;
    core[66] = 9'b000000000;
    core[67] = 9'b000101101;
    core[68] = 9'b000000000;
    core[69] = 9'b001000101;
    core[70] = 9'b010000001;
    core[71] = 9'b001000110;
    core[72] = 9'b110100111;
    core[73] = 9'b011000000;
    core[74] = 9'b111101011;
    core[75] = 9'b111101101;
    core[76] = 9'b010001100;
    core[77] = 9'b111000111;
    core[78] = 9'b111101101;
    core[79] = 9'b010000000;
    core[80] = 9'b010100000;
    core[81] = 9'b001000101;
    core[82] = 9'b000101010;
    core[83] = 9'b001011001;
    core[84] = 9'b110100111;
    core[85] = 9'b011000000;
    core[86] = 9'b111101011;
    core[87] = 9'b111101101;
    core[88] = 9'b010001100;
    core[89] = 9'b001101011;
    core[90] = 9'b010000010;
    core[91] = 9'b001101100;
    core[92] = 9'b010000010;
    core[93] = 9'b001101101;
    core[94] = 9'b000000000;
  end

endmodule