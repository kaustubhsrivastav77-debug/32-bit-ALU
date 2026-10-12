module alu_tb;

reg [31:0] A;
reg [31:0] B;
reg [3:0] opcode;

wire [31:0] result;

alu dut(
    .A(A),
    .B(B),
    .opcode(opcode),
    .result(result)
);

initial
begin

    // ADD
    A = 32'd10;
    B = 32'd5;
    opcode = 4'b0000;
    #10;

    // ADDI
    A = 32'd10;
    B = 32'd7;
    opcode = 4'b0001;
    #10;

    // SUB
    A = 32'd10;
    B = 32'd5;
    opcode = 4'b0010;
    #10;

    // SUBI
    A = 32'd10;
    B = 32'd7;
    opcode = 4'b0011;
    #10;

    // NEG
    A = 32'd10;
    B = 32'd0;
    opcode = 4'b0100;
    #10;

    // AND
    A = 32'hF0F0F0F0;
    B = 32'h0F0F0F0F;
    opcode = 4'b0101;
    #10;

    // OR
    A = 32'hF0F0F0F0;
    B = 32'h0F0F0F0F;
    opcode = 4'b0110;
    #10;

    // XOR
    A = 32'hF0F0F0F0;
    B = 32'h0F0F0F0F;
    opcode = 4'b0111;
    #10;

    // LSL
    A = 32'b0001;
    B = 32'd2;
    opcode = 4'b1000;
    #10;

    // LSLI
    A = 32'b0001;
    B = 32'd3;
    opcode = 4'b1001;
    #10;

    // LSR
    A = 32'b1000;
    B = 32'd2;
    opcode = 4'b1010;
    #10;

    // LSRI
    A = 32'b1000;
    B = 32'd1;
    opcode = 4'b1011;
    #10;

    // ASR
    A = 32'hFFFFFFF0;
    B = 32'd2;
    opcode = 4'b1100;
    #10;

    // ASRI
    A = 32'hFFFFFFF0;
    B = 32'd3;
    opcode = 4'b1101;
    #10;
    $finish;
    
begin
    $monitor("T=%0t | opcode=%b | A=%h | B=%h | result=%h",
             $time, opcode, A, B, result);
end

end
endmodule
