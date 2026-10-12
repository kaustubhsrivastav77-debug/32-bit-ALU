module instruction_decoder(
input  [19:0] instruction,

output [3:0]  opcode,
output [3:0]  rs1,
output [3:0]  rs2,
output [7:0]  imm,
output        is_immediate

);

// Extract instruction fields
assign opcode = instruction[19:16];
assign rs1    = instruction[15:12];
assign rs2    = instruction[11:8];
assign imm    = instruction[7:0];

// Select immediate for immediate variants
assign is_immediate =
    (opcode == 4'b0001) ||  // ADDI
    (opcode == 4'b0011) ||  // SUBI
    (opcode == 4'b1001) ||  // LSLI
    (opcode == 4'b1011) ||  // LSRI
    (opcode == 4'b1101);    // ASRI

endmodule
