module operand_select(
input  [31:0] read_data2,
input  [7:0]  imm,
input         is_immediate,

output [31:0] alu_B

);

wire [31:0] sign_extended_imm;

// Sign-extend the 8-bit immediate to 32 bits
assign sign_extended_imm = {{24{imm[7]}}, imm};

// Select the ALU's second operand
assign alu_B = is_immediate
             ? sign_extended_imm
             : read_data2;

endmodule
