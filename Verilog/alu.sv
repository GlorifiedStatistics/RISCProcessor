module ALU (
  input wire 	[7:0] rf_reg_out,
  input wire 	[7:0] rpct,
  input wire 	[7:0] rlsb,
  input wire 	[7:0] rmsb,
  input wire 	[7:0] rptn,
  input wire 	[3:0] alu_op,
  output wire 	[7:0] alu_out
);

  // ADD and INC
  // Use add_in = 1 if op == inc, otherwise rpct
  wire [7:0] add_out = rf_reg_out + ((alu_op == 4'b0100) ? 8'd1 : rpct);


  // HGP
  wire [3:0] hgp_pty = {
    ^{rmsb[2:0], rlsb[7:4]},								// p8
    ^{rmsb[2:0], rlsb[7], rlsb[3:1]},						// p4
    ^{rmsb[2:1], rlsb[6:5], rlsb[3:2], rlsb[0]},			// p2
    ^{rmsb[2], rmsb[0], rlsb[6], rlsb[4:3], rlsb[1:0]}		// p1
  };
  wire [7:0] hgp = {3'b000, hgp_pty,
                    ^{rmsb[2:0], rlsb, hgp_pty}				// p0
                   };

  // HEL, HEM
  wire [7:0] hel = {rlsb[3:1], rpct[3], rlsb[0], rpct[2:0]};
  wire [7:0] hem = {rmsb[2:0], rlsb[7:4], rpct[4]};

  // HEP
  wire [3:0] hep_pty = {
    (^(rmsb[7:1])) ^ rmsb[0],															// s8
    (^{rmsb[7:4], rlsb[7:5]}) ^ rlsb[4],												// s4
    (^{rmsb[7:6], rmsb[3:2], rlsb[7:6], rlsb[3]}) ^ rlsb[2],							// s2
    (^{rmsb[7], rmsb[5], rmsb[3], rmsb[1], rlsb[7], rlsb[5], rlsb[3]}) ^ rlsb[1]		// s1
  };
  wire [7:0] hep = {3'b000, hep_pty, ^{rmsb, rlsb}};									// s0

  // HCL, HCM
  wire [7:0] hcl = {
    (hep_pty == 4'b1100) ? ~rmsb[4] : rmsb[4],
    (hep_pty == 4'b1011) ? ~rmsb[3] : rmsb[3],
    (hep_pty == 4'b1010) ? ~rmsb[2] : rmsb[2],
    (hep_pty == 4'b1001) ? ~rmsb[1] : rmsb[1],

    (hep_pty == 4'b0111) ? ~rlsb[7] : rlsb[7],
    (hep_pty == 4'b0110) ? ~rlsb[6] : rlsb[6],
    (hep_pty == 4'b0101) ? ~rlsb[5] : rlsb[5],

    (hep_pty == 4'b0011) ? ~rlsb[3] : rlsb[3]
  };

  wire [7:0] hcm = {( (~rpct[0]) & (~(rpct[4:1] == 4'b0000)) ) ? 1'b1 : 1'b0, 4'b0000,
                    (hep_pty == 4'b1111) ? ~rmsb[7] : rmsb[7],
                    (hep_pty == 4'b1110) ? ~rmsb[6] : rmsb[6],
                    (hep_pty == 4'b1101) ? ~rmsb[5] : rmsb[5]
                   };


  // The pattern for POB and PTB
  wire [4:0] ptn = rptn[7:3];

  // POB
  wire A = rlsb[7:3] == ptn;
  wire B = rlsb[6:2] == ptn;
  wire C = rlsb[5:1] == ptn;
  wire D = rlsb[4:0] == ptn;

  wire [2:0] pob_count = A + B + C + D;
  wire [7:0] pob = {5'b00000, pob_count};

  // PTB
  wire a = {rlsb[3:0], rmsb[7]} == ptn;
  wire b = {rlsb[2:0], rmsb[7:6]} == ptn;
  wire c = {rlsb[1:0], rmsb[7:5]} == ptn;
  wire d = {rlsb[0], rmsb[7:4]} == ptn;
  
  // A direct copy of pob's logic
  wire [2:0] ptb_count = a + b + c + d;
  wire [7:0] ptb = {5'b00000, ptb_count};
  
  // The ending switch for output choice
  assign alu_out =
    (alu_op == 4'b0100) ? add_out :
    (alu_op == 4'b1111) ? add_out :
    (alu_op == 4'b0111) ? hgp :
    (alu_op == 4'b1000) ? hel :
    (alu_op == 4'b1001) ? hem :
    (alu_op == 4'b1010) ? hep :
    (alu_op == 4'b1011) ? hcl :
    (alu_op == 4'b1100) ? hcm :
    (alu_op == 4'b1101) ? pob :
    (alu_op == 4'b1110) ? ptb :
		8'd0;

endmodule