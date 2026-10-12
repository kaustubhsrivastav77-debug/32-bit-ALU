module alu(
    input [31:0] A,
    input [31:0] B,
    input [3:0] opcode,
    output reg [31:0] result
    );
    
localparam ADD  = 4'b0000;
localparam ADDI = 4'b0001;
localparam SUB  = 4'b0010;
localparam SUBI = 4'b0011;
localparam NEG  = 4'b0100;
localparam AND_ = 4'b0101;
localparam OR   = 4'b0110;
localparam XOR_ = 4'b0111;
localparam LSL  = 4'b1000;
localparam LSLI = 4'b1001;
localparam LSR  = 4'b1010;
localparam LSRI = 4'b1011;
localparam ASR  = 4'b1100;
localparam ASRI = 4'b1101;

always @(*) begin
    case(opcode)

        ADD:
            result = A + B;

        ADDI:
            result = A + B;

        SUB:
            result = A - B;

        SUBI:
            result = A - B;

        NEG:
            result = -A;

        AND_:
            result = A & B;

        OR:
            result = A | B;

        XOR_:
            result = A ^ B;

        LSL:
            result = A << B;

        LSLI:
            result = A << B;

        LSR:
            result = A >> B;

        LSRI:
            result = A >> B;

        ASR:
            result = $signed(A) >>> B;

        ASRI:
            result = $signed(A) >>> B;

        default:
            result = 32'b0;

    endcase
end
endmodule
