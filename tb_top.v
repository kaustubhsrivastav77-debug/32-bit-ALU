`timescale 1ns / 1ps

module tb_top;

reg [19:0] instruction;
wire [31:0] result;

// Instantiate the complete design
top dut (
    .instruction(instruction),
    .result(result)
);

initial begin

    // Initialize instruction
    instruction = 20'b0;

    // Initialize registers directly for simulation
    dut.RF.registers[0]  = 32'd0;
    dut.RF.registers[1]  = 32'd10;
    dut.RF.registers[2]  = 32'd20;
    dut.RF.registers[3]  = -32'sd5;
    dut.RF.registers[4]  = 32'd8;
    dut.RF.registers[5]  = 32'd2;
    dut.RF.registers[6]  = 32'h80000000;
    dut.RF.registers[7]  = 32'hFFFFFFFF;

    #10;

    // ADD: R1 + R2 = 10 + 20 = 30
    instruction = {4'b0000, 4'd1, 4'd2, 8'd0};
    #10;
    $display("ADD  Result = %0d, Expected = 30", $signed(result));

    // ADDI: R1 + (-3) = 7
    instruction = {4'b0001, 4'd1, 4'd0, 8'hFD};
    #10;
    $display("ADDI Result = %0d, Expected = 7", $signed(result));

    // SUB: R2 - R1 = 20 - 10 = 10
    instruction = {4'b0010, 4'd2, 4'd1, 8'd0};
    #10;
    $display("SUB  Result = %0d, Expected = 10", $signed(result));

    // SUBI: R1 - (-3) = 13
    instruction = {4'b0011, 4'd1, 4'd0, 8'hFD};
    #10;
    $display("SUBI Result = %0d, Expected = 13", $signed(result));

    // NEG: -R1 = -10
    instruction = {4'b0100, 4'd1, 4'd0, 8'd0};
    #10;
    $display("NEG  Result = %0d, Expected = -10", $signed(result));

    // AND: 10 & 20 = 0
    instruction = {4'b0101, 4'd1, 4'd2, 8'd0};
    #10;
    $display("AND  Result = %0d, Expected = 0", $signed(result));

    // OR: 10 | 20 = 30
    instruction = {4'b0110, 4'd1, 4'd2, 8'd0};
    #10;
    $display("OR   Result = %0d, Expected = 30", $signed(result));

    // XOR: 10 ^ 20 = 30
    instruction = {4'b0111, 4'd1, 4'd2, 8'd0};
    #10;
    $display("XOR  Result = %0d, Expected = 30", $signed(result));

    // LSL: 8 << 2 = 32
    instruction = {4'b1000, 4'd4, 4'd5, 8'd0};
    #10;
    $display("LSL  Result = %0d, Expected = 32", $signed(result));

    // LSLI: 8 << 2 = 32
    instruction = {4'b1001, 4'd4, 4'd0, 8'd2};
    #10;
    $display("LSLI Result = %0d, Expected = 32", $signed(result));

    // LSR: 8 >> 2 = 2
    instruction = {4'b1010, 4'd4, 4'd5, 8'd0};
    #10;
    $display("LSR  Result = %0d, Expected = 2", $signed(result));

    // LSRI: 8 >> 2 = 2
    instruction = {4'b1011, 4'd4, 4'd0, 8'd2};
    #10;
    $display("LSRI Result = %0d, Expected = 2", $signed(result));

    // ASR: -8 >>> 2 = -2
    dut.RF.registers[4] = -32'sd8;
    instruction = {4'b1100, 4'd4, 4'd5, 8'd0};
    #10;
    $display("ASR  Result = %0d, Expected = -2", $signed(result));

    // ASRI: -8 >>> 2 = -2
    instruction = {4'b1101, 4'd4, 4'd0, 8'd2};
    #10;
    $display("ASRI Result = %0d, Expected = -2", $signed(result));

    $display("Simulation completed.");

    $finish;

end
endmodule
