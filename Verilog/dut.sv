module DUT (
  input wire clk,
  input wire reset,
  input wire req,
  output wire ack
);

  // Registers
  parameter RI = 0, RMI = 1, RMO = 2, RSI = 3, RJLS = 4, RLSB = 5, RMSB = 6, RPCT = 7, RST = 8,
    RPTN = 9, RJNI = 10, ROBC = 11, RUBC = 12, RTBC = 13;
  wire [7:0] rs [13:0];

  // PC
  wire pc_update, pc_bns, pc_bcz, pc_inc2;
  wire [7:0] pc;

  // IR
  wire [7:0] ld_val;
  wire [8:0] instruction;

  // DM
  wire mem_write;
  wire [7:0] dm_out;

  // ALU
  wire [3:0] alu_op;
  wire [7:0] alu_out;

  // RF
  wire rf_din_dm, rf_din_alu;
  wire rf_write_reg;
  wire [7:0] rf_reg_out;
  wire [3:0] rf_reg_in = instruction[3:0];
  wire [7:0] rf_write_data = rf_din_dm ? dm_out :
                       rf_din_alu ? alu_out :
                       ld_val;


  PC pc1(.rjls(rs[RJLS]), .rjni(rs[RJNI]), .ri(rs[RI]), .rsi(rs[RSI]), .rpct(rs[RPCT]), .*);
  IR ir1(.*);
  CTRL ctrl1(.*);
  ALU alu1(.rpct(rs[RPCT]), .rlsb(rs[RLSB]), .rmsb(rs[RMSB]), .rptn(rs[RPTN]), .*);
  DM dm1(.rmi(rs[RMI]), .rmo(rs[RMO]), .*);
  RF rf1(.*);

endmodule