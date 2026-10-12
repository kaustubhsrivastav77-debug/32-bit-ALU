module top(
input  [19:0] instruction,
output [31:0] result
);

// Instruction decoder outputs
wire [3:0] opcode;
wire [3:0] rs1;
wire [3:0] rs2;
wire [7:0] imm;
wire is_immediate;

// Register file outputs
wire [31:0] read_data1;
wire [31:0] read_data2;

// ALU operand B
wire [31:0] alu_B;

// Instruction decoder
instruction_decoder DECODER (
    .instruction(instruction),
    .opcode(opcode),
    .rs1(rs1),
    .rs2(rs2),
    .imm(imm),
    .is_immediate(is_immediate)
);

// Register file
register RF (
    .rs1(rs1),
    .rs2(rs2),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

// Immediate extension and operand selection
operand_select OPERAND_MUX (
    .read_data2(read_data2),
    .imm(imm),
    .is_immediate(is_immediate),
    .alu_B(alu_B)
);

// ALU
alu ALU_UNIT (
    .A(read_data1),
    .B(alu_B),
    .opcode(opcode),
    .result(result)
);

endmodule
