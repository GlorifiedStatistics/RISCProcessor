module CTRL (
  input wire		  req,
  input wire		  reset,
  input wire		  clk,
  input wire	[8:0] instruction,
  output wire		  ack,
  output wire		  pc_update,
  output wire         pc_inc2,
  output wire		  pc_bns,
  output wire		  pc_bcz,
  output wire		  rf_write_reg,
  output wire		  rf_din_dm,
  output wire		  rf_din_alu,
  output wire		  mem_write,
  output wire	[3:0] alu_op
);

  // The op code
  wire [3:0] op_code = instruction[8:5];
  
  // Make wires so I don't mess thigns up, made this bit automatically
  wire end_op = op_code == 4'b0000;
  wire lrv_op = op_code == 4'b0001;
  wire lrm_op = op_code == 4'b0010;
  wire str_op = op_code == 4'b0011;
  wire inc_op = op_code == 4'b0100;
  wire bns_op = op_code == 4'b0101;
  wire bcz_op = op_code == 4'b0110;
  wire hgp_op = op_code == 4'b0111;
  wire hel_op = op_code == 4'b1000;
  wire hem_op = op_code == 4'b1001;
  wire hep_op = op_code == 4'b1010;
  wire hcl_op = op_code == 4'b1011;
  wire hcm_op = op_code == 4'b1100;
  wire pob_op = op_code == 4'b1101;
  wire ptb_op = op_code == 4'b1110;
  wire apc_op = op_code == 4'b1111;

  reg cs;

  always_ff @(posedge clk) begin
    if (reset) cs <= 1'b0;
    else if (req) cs <= 1'b1;
    else if (cs & end_op) cs <= 1'b0;
  end
  
  // If this is an alu operation
  wire ao = inc_op|hgp_op|hel_op|hem_op|hep_op|hcl_op|hcm_op|pob_op|ptb_op|apc_op;
  
  // PC_Update things, obvious
  assign pc_update = cs;
  assign pc_inc2 = lrv_op;
  assign pc_bns = bns_op;
  assign pc_bcz = bcz_op;
  
  // If we are running and (we should lrv, or operation requires current-cycle load from memory or alu)
  assign rf_write_reg = cs & (lrv_op | lrm_op | ao);
  
  // A 1 if reading from memory (lrm), else 0
  assign rf_din_dm = lrm_op;
  
  // Just pass the direct op code
  assign alu_op = op_code;
  
  // Should be a 1 if we are writing, 0 if not
  assign mem_write = cs & str_op;
  
  // If we are doing alu operation
  assign rf_din_alu = ao;
  
  // A 1 if we are done
  assign ack = ~cs;

endmodule