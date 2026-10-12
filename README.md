# 32-bit ALU with Register File and Instruction Decoder

A **32-bit Arithmetic Logic Unit (ALU)** designed and simulated using Verilog HDL in Xilinx Vivado. The project implements a register-based datapath with a 16 × 32-bit register file, instruction decoding, immediate operand selection, and support for 14 arithmetic, logical, and shift operations.

The design executes each instruction combinationally, without requiring a program memory, processor pipeline, or result write-back mechanism.

## Overview

The objective of this project is to design a simple instruction-driven ALU system that accepts a 20-bit instruction, retrieves operands from a register file, selects between register and immediate operands, and generates a 32-bit result.

### Key Features

* 32-bit ALU supporting 14 operations.
* 16 general-purpose registers, each 32 bits wide.
* Two asynchronous register-file read ports.
* 4-bit opcode-based instruction decoding.
* 8-bit signed immediate with 32-bit sign extension.
* Register-based and immediate-based arithmetic and shift operations.
* Combinational datapath for single-cycle operation.
* Modular RTL design using Verilog HDL.
* Behavioral simulation and functional verification in Xilinx Vivado.

## Architecture

The design consists of five primary RTL modules.

| Module                  | Description                                                                   |
| ----------------------- | ----------------------------------------------------------------------------- |
| `top.v`                 | Integrates the decoder, register file, operand selector, and ALU.             |
| `alu.v`                 | Performs arithmetic, logical, and shift operations.                           |
| `register_file.v`       | Stores 16 registers of 32 bits each and provides two asynchronous read ports. |
| `instruction_decoder.v` | Extracts instruction fields and identifies immediate operations.              |
| `operand_select.v`      | Sign-extends the immediate and selects the ALU's second operand.              |

### Datapath

```text
                20-bit Instruction
                        |
                        v
               +------------------+
               | Instruction      |
               | Decoder          |
               +------------------+
                  |  |  |  |
                 OP RS1 RS2 IMM
                     |  |   |
                     v  v   |
               +----------------+
               | Register File  |
               | 16 x 32-bit    |
               +----------------+
                   |        |
                   |        v
                   |   +----------------+
                   |   | Operand Select  |<--- Immediate
                   |   | Register / IMM  |
                   |   +----------------+
                   |        |
                   v        v
                 ALU A    ALU B
                    \       /
                     \     /
                   +---------+
                   |   ALU   |
                   | 32-bit  |
                   +---------+
                        |
                        v
                  32-bit Result
```

## Instruction Format

Each instruction is 20 bits wide.

| Field             | Bit positions |  Width | Description                          |
| ----------------- | ------------- | -----: | ------------------------------------ |
| Opcode            | `[19:16]`     | 4 bits | Selects the ALU operation.           |
| Source Register 1 | `[15:12]`     | 4 bits | Selects the first operand.           |
| Source Register 2 | `[11:8]`      | 4 bits | Selects the second register operand. |
| Immediate         | `[7:0]`       | 8 bits | Supplies a signed immediate operand. |

**Total instruction width: 20 bits.**

A 4-bit register address can select any of the 16 registers, from R0 to R15.

### Immediate Handling

The immediate field represents a signed 8-bit integer in two's-complement format. It is sign-extended to 32 bits before being supplied to the ALU.

For example:

```text
8-bit immediate:       11111101
Signed decimal value:  -3

32-bit sign extension:
11111111 11111111 11111111 11111101
```

The corresponding Verilog expression is:

```verilog
assign sign_extended_imm = {{24{imm[7]}}, imm};
```

For immediate operations, the operand-selection logic chooses this sign-extended value instead of the second register's output.

## Supported ALU Operations

The ALU supports 14 operations, encoded using a 4-bit opcode.

| Opcode | Mnemonic | Operation                 | Description                           |
| ------ | -------- | ------------------------- | ------------------------------------- |
| `0000` | ADD      | `A + B`                   | Register addition                     |
| `0001` | ADDI     | `A + IMM`                 | Addition with immediate               |
| `0010` | SUB      | `A - B`                   | Register subtraction                  |
| `0011` | SUBI     | `A - IMM`                 | Subtraction with immediate            |
| `0100` | NEG      | `-A`                      | Two's-complement negation             |
| `0101` | AND      | `A & B`                   | Bitwise AND                           |
| `0110` | OR       | `A \| B`                  | Bitwise OR                            |
| `0111` | XOR      | `A ^ B`                   | Bitwise XOR                           |
| `1000` | LSL      | `A << B[4:0]`             | Logical shift left                    |
| `1001` | LSLI     | `A << IMM[4:0]`           | Logical shift left with immediate     |
| `1010` | LSR      | `A >> B[4:0]`             | Logical shift right                   |
| `1011` | LSRI     | `A >> IMM[4:0]`           | Logical shift right with immediate    |
| `1100` | ASR      | `$signed(A) >>> B[4:0]`   | Arithmetic shift right                |
| `1101` | ASRI     | `$signed(A) >>> IMM[4:0]` | Arithmetic shift right with immediate |

Opcodes `1110` and `1111` are reserved and produce zero in the current ALU implementation.

### Shift Operations

* **LSL:** Shifts bits left and fills vacated positions with zeros.
* **LSR:** Shifts bits right and fills vacated positions with zeros.
* **ASR:** Shifts bits right while preserving the sign by replicating the most significant bit.

For 32-bit operands, the ALU uses the lower five bits of the shift amount, allowing shift amounts from 0 to 31.

## Repository Structure

```text
32-bit-ALU/
│
├── alu.v
├── register_file.v
├── instruction_decoder.v
├── operand_select.v
├── top.v
├── tb_top.v
└── README.md
```

## Implementation Details

### 1. ALU

The ALU is implemented using combinational Verilog logic and a `case` statement to select the required operation.
The immediate variants share the same arithmetic or shift logic as their register-based counterparts. The operand-selection module determines which value is supplied as operand B.

### 2. Register File

The register file contains 16 registers, each 32 bits wide, providing a total storage capacity of 512 bits.

reg [31:0] registers [0:15];

assign read_data1 = registers[rs1];
assign read_data2 = registers[rs2];

The two asynchronous read ports allow both source operands to be available without waiting for a clock edge.

The current implementation does not include a write port because the assignment does not require writing ALU results back to the register file.

### 3. Instruction Decoder

The decoder extracts the opcode, two register addresses, and immediate field from the instruction.

It also identifies the five immediate operations:

ADDI
SUBI
LSLI
LSRI
ASRI

### 4. Operand Selection
The operand-selection module performs sign extension and selects the ALU's second operand.

assign alu_B = is_immediate
             ? sign_extended_imm
             : read_data2;

This enables the same ALU to handle both register-based and immediate-based operations.

Tools and Technologies
Hardware Description Language: Verilog HDL
Design and Simulation: Xilinx Vivado
Verification: Behavioral simulation using a Verilog testbench
Target: FPGA-oriented RTL design
Simulation and Verification

The design was behaviorally simulated in Xilinx Vivado using tb_top.v.

The testbench initializes register values, applies instructions directly, and checks the resulting ALU outputs.

Example Test Cases
Instruction	Inputs	Expected Result
ADD	R1 = 10, R2 = 20	30
ADDI	R1 = 10, IMM = -3	7
SUB	R2 = 20, R1 = 10	10
SUBI	R1 = 10, IMM = -3	13
NEG	R1 = 10	-10
AND	R1 = 10, R2 = 20	0
OR	R1 = 10, R2 = 20	30
XOR	R1 = 10, R2 = 20	30
LSL	R4 = 8, R5 = 2	32
LSLI	R4 = 8, IMM = 2	32
LSR	R4 = 8, R5 = 2	2
LSRI	R4 = 8, IMM = 2	2
ASR	R4 = -8, R5 = 2	-2
ASRI	R4 = -8, IMM = 2	-2

Verification status: The behavioral simulation passed for the initial testbench covering all 14 supported operations.

The testbench initializes internal register-file values using hierarchical references for simulation. These assignments are verification-only and do not create a hardware write port.

Running the Project in Vivado
Create or open a Vivado RTL project.
Add alu.v, register_file.v, instruction_decoder.v, operand_select.v, and top.v as design sources.
Add tb_top.v as a simulation source.
Set top as the design top module.
Set tb_top as the simulation top module.
Select Run Simulation → Run Behavioral Simulation.
Run the simulation and inspect the output messages and waveforms.
Optionally run synthesis to inspect the synthesized RTL implementation.

No program memory or processor pipeline is required for this assignment.

Design Scope and Limitations

The project focuses on the ALU datapath and its associated instruction-decoding and register-selection mechanisms.

The current implementation intentionally excludes:

Program counter and instruction-fetch logic.
Program memory.
Pipeline stages.
ALU result write-back.
Register-file write port.
Clocked execution and pipeline control.
Dedicated carry, zero, negative, and overflow flags.

The register file uses simulation initialization and asynchronous reads. A practical FPGA implementation may require a different initialization strategy depending on the target device and system requirements.

Future Improvements

Potential extensions include:

Automated PASS/FAIL checks for every test case.
Additional corner-case and boundary-condition testing.
A register-file write port and synchronous reset.
Status flags for zero, carry, negative, and overflow.
A clocked instruction-execution interface.
Integration with a simple processor datapath.
FPGA synthesis reports and resource-utilization analysis.
Learning Outcomes

This project provides practical experience with:

Combinational logic design in Verilog.
ALU architecture and opcode encoding.
Register-file organization and addressing.
Signed arithmetic and two's-complement representation.
Sign extension of immediate operands.
Multiplexer-based operand selection.
Hierarchical RTL design and module integration.
Functional verification using Vivado behavioral simulation.

Author-:
Kaustubh Srivastava

Electronics & VLSI Engineering
Sardar Vallabhbhai National Institute of Technology (SVNIT), Surat

Developed as a digital design assignment to explore RTL implementation, datapath architecture, and functional verification using Verilog HDL.
