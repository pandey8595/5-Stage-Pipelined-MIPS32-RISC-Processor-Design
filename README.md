# 5-Stage-Pipelined-MIPS32-RISC-Processor-Design
This repository contains the details and the code for the MIPS32 ISA based RISC Processor, which is implemented in 5 stage pipelined configuration.

Table of contents

▫️ MIPS32
▫️ Addressing Modes
▫️ Instructions considered
▫️ Instruction Encoding
▫️ Stages of Execution
▫️ Non Pipelined DataPath
▫️ Pipelined DataPath
▫️ Verilog Design Code
▫️ Example Program Testbench Code
▫️ EDAplayground Link
▫️ Known issues and problems
▫️ References




▫️MIPS32
32 x 32 bit GPRs [R0 to R31]
R0 hardwired to logic0
32 bit Program Counter (PC)
No flag registers (carry, zero, sign..etc)
Few Addresing Modes
Only Load and Store instructions can access memory
We assume memory word size is 32 bits (word addressable)


▫️ Addressing Modes

| Addressing Mode          | Example Instruction | Description                       |
| ------------------------ | ------------------- | --------------------------------- |
| Register Addressing      | `ADD R1, R2, R3`    | Operands are in registers         |
| Immediate Addressing     | `ADDI R1, R2, 200`  | One operand is constant           |
| Base Addressing          | `LW R5, 150(R7)`    | Memory access using base + offset |
| PC Relative Addressing   | `BEQZ R3, Label`    | Branch relative to PC             |
| Pseudo Direct Addressing | `J Label`           | Jump to target address            |

🔷 Instruction Set Implemented

⚠️ Note: This project implements a subset of MIPS32 instructions for simplicity and educational purposes.

📥 Load and Store Instructions

LW R2, 124(R8)    // R2 = Mem[R8 + 124]
SW R5, -10(R25)   // Mem[R25 - 10] = R5

➕ Arithmetic & Logic Instructions (Register Type)

ADD R1, R2, R3     // R1 = R2 + R3  

ADD R1, R2, R0    // R1 = R2 + 0


SUB R12, R10, R8  // R12 = R10 - R8

AND R20, R1, R5   // R20 = R1 & R5

OR  R11, R5, R6   // R11 = R5 | R6

MUL R5, R6, R7    // R5 = R6 * R7

SLT R5, R11, R12  // If R11 < R12 → R5 = 1 else 0

➗ Arithmetic & Logic Instructions (Immediate Type)
ADDI R1, R2, 25   // R1 = R2 + 25

SUBI R5, R1, 150  // R5 = R1 - 150

SLTI R2, R10, 10  // If R10 < 10 → R2 = 1 else 0

🔀 Branch Instructions

BEQZ R1, Loop     // Branch to Loop if R1 == 0

BNEQZ R5, Label   // Branch to Label if R5 != 0

🔁 Jump Instruction
J Loop            // Unconditional jump to Loop

⛔ Miscellaneous Instruction

HLT               // Halt processor execution



🔷 Key Features
32-bit MIPS architecture
5-stage pipelined design
Supports multiple addressing modes
Handles basic arithmetic, memory, and control instructions
Designed using Verilog HDL



🔷 Note
This implementation is intended for:
🎓 Academic learning
🧠 Understanding pipelined processor design
⚙️ Verilog-based CPU architecture practice


▫️ Instruction Encoding


<img width="966" height="542" alt="Instruction Encoding" src="https://github.com/user-attachments/assets/13fc1322-3be9-4e14-98bb-0a09a5b6f83e" />



shamt : shift amount, funct : opcode extension for additional functions.

Some instructions require two register operands rs & rt as input, while some require only rs.

This requirement is only identified only after the instruction is decoded.

While decoding is going on, we can prefetch the registers in parallel, which may or may not be used later.

Similarly, the 16-bit and 26-bit immediate data are retrieved and signextended to 32-bits in case they are required later.


▫️ Stages of Execution
The instruction execution cycle contains the following 5 stages in order:

IF : Instruction Fetch
ID : Instruction Decode / Register Fetch
EX : Execution / Effective Address Calculation
MEM : Memory Access / Branch Completion
WB : Register Write-back
micro operations not shown here.

▫️ Non Pipelined DataPath

<img width="1156" height="556" alt="Non pipelined path" src="https://github.com/user-attachments/assets/86810128-06d9-4c1a-af9f-7889bb3b6954" />



▫️ Pipelined DataPath
<img width="1442" height="727" alt="Pipelined Path" src="https://github.com/user-attachments/assets/d43bcb52-2200-456e-825d-3d3e0722c787" />



▫️ Example Program Testbench Code

Steps:

1.Initialize register R1 with 10.
2.Initialize register R2 with 20.
3.Initialize register R3 with 25.
4.Add the three numbers and store the sum in R5.


Instruction Encoding Table


| Assembly Instruction      | Machine Code                            | Hex Code     |
| ------------------------- | --------------------------------------- | ------------ |
| `ADDI R1, R0, 10`         | `001010 00000 00001 0000000000001010`   | `0x2801000a` |
| `ADDI R2, R0, 20`         | `001010 00000 00010 0000000000010100`   | `0x28020014` |
| `ADDI R3, R0, 25`         | `001010 00000 00011 0000000000011001`   | `0x28030019` |
| `OR R7, R7, R7` *(dummy)* | `000011 00111 00111 00111 00000 000000` | `0x0ce77800` |
| `OR R7, R7, R7` *(dummy)* | same as above                           | `0x0ce77800` |
| `ADD R4, R1, R2`          | `000000 00001 00010 00100 00000 000000` | `0x00222000` |
| `OR R7, R7, R7` *(dummy)* | same as above                           | `0x0ce77800` |
| `ADD R5, R4, R3`          | `000000 00100 00011 00101 00000 000000` | `0x00832800` |
| `HLT`                     | `111111 00000 00000 00000 00000 000000` | `0xfc000000` |



🔷 Expected Output

R1 = 10
R2 = 20
R3 = 25
R4 = 30
R5 = 55


🔷 Waveform


<img width="1825" height="576" alt="Waveform" src="https://github.com/user-attachments/assets/d54b06e3-b55f-410f-971f-e51f609dea2f" />



▫️ Known problems and issues
Following pipelining hazards are present in the given design :

Structural Hazards due to shared hardware.
Data Hazards due to instruction data dependency.
Control hazards due to branch instructions.



▫️ References



[NPTEL & IIT KGP 'Hardware Modeling using Verilog'- Prof. Indranil Sengupta
](https://www.youtube.com/playlist?list=PLtlic7FZ6H4e-t0mKz7n84p-puk3KAT7N)




