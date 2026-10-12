module register(
input  [3:0]  rs1,
input  [3:0]  rs2,
output [31:0] read_data1,
output [31:0] read_data2
);

reg [31:0] registers [0:15];

// Two asynchronous read ports
assign read_data1 = registers[rs1];
assign read_data2 = registers[rs2];

// Initialize all registers to zero
integer i;

initial begin
    for (i = 0; i < 16; i = i + 1)
        registers[i] = 32'b0;
end

endmodule
