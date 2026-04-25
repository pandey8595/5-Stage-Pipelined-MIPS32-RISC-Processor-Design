`timescale 1ns / 1ps

module test_mips32;

  reg clk1, clk2;
  integer k;

  // DUT Instantiation
  MIPS32_designcode mips (clk1, clk2);

  // 🔷 Two-phase clock generation
  initial begin
    clk1 = 0;
    clk2 = 0;

    forever begin
      #5 clk1 = 1;
      #5 clk1 = 0;
      #5 clk2 = 1;
      #5 clk2 = 0;
    end
  end

  // 🔷 Initialization block
  initial begin

    // Initialize register file
    for (k = 0; k < 32; k = k + 1)
      mips.Reg[k] = k;

    // Load instructions into memory
    mips.Mem[0] = 32'h2801000a; // ADDI R1,R0,10
    mips.Mem[1] = 32'h28020014; // ADDI R2,R0,20
    mips.Mem[2] = 32'h28030019; // ADDI R3,R0,25
    mips.Mem[3] = 32'h0ce77800; // Dummy
    mips.Mem[4] = 32'h0ce77800; // Dummy
    mips.Mem[5] = 32'h00222000; // ADD R4,R1,R2
    mips.Mem[6] = 32'h0ce77800; // Dummy
    mips.Mem[7] = 32'h00832800; // ADD R5,R4,R3
    mips.Mem[8] = 32'hfc000000; // HLT

    // Initialize control signals
    mips.HALTED = 0;
    mips.PC = 0;
    mips.TAKEN_BRANCH = 0;

    // Wait for execution
    #300;

    // Display results
    $display("\nFinal Register Values:");
    for (k = 0; k < 6; k = k + 1)
      $display("R%0d = %0d", k, mips.Reg[k]);

    $finish;
  end

  // 🔷 Dump waveform
  initial begin
    $dumpfile("mips.vcd");
    $dumpvars(0, test_mips32);
  end

  // 🔷 Stop when HALT occurs
  always @(posedge clk1) begin
    if (mips.HALTED == 1'b1) begin
      $display("Processor Halted at time %0t", $time);
      $finish;
    end
  end

endmodule
