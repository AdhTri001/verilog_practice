
module MUX8x1 (
  input [7:0] I,
  input [2:0] S,
  output Y
);
  wire [7:0] w;
  wire nS2, nS1, nS0;

  not (nS0, S[0]);
  not (nS1, S[1]);
  not (nS2, S[2]);

  and (w[0], I[0], nS2, nS1, nS0);
  and (w[1], I[1], nS2, nS1, S[0]);
  and (w[2], I[2], nS2, S[1], nS0);
  and (w[3], I[3], nS2, S[1], S[0]);
  and (w[4], I[4], S[2], nS1, nS0);
  and (w[5], I[5], S[2], nS1, S[0]);
  and (w[6], I[6], S[2], S[1], nS0);
  and (w[7], I[7], S[2], S[1], S[0]);

  or (Y, w[0], w[1], w[2], w[3], w[4], w[5], w[6], w[7]);

endmodule

/**
  * OP code:
  * 000 - AND
  * 001 - OR
  * 010 - XOR
  * 011 - ADD (Y0 = sum, Y1 = carry)
  * 100 - SUB (Y0 = difference, Y1 = borrow)
  * 101 - MULT (Same as AND for single bit)
  * 110 - X
  * 111 - X
  **/
module ALU (
  input A, B,
  input [2:0] OP,
  output Y0,
  output Y1
);

  wire and_AB, or_AB, xor_AB, not_A, brrw_AB;

  and (and_AB, A, B);
  or (or_AB, A, B);
  xor (xor_AB, A, B);
  not (not_A, A);

  // borrow = ~A | B
  or (brrw_AB, not_A, B);

  MUX8x1 mux (
    {1'bz, 1'bz, and_AB, xor_AB, xor_AB, xor_AB, or_AB, and_AB},
    OP,
    Y0
  );

  MUX8x1 mux2 (
    {1'bz, 1'bz, 1'bz, brrw_AB, carry_AB, 1'bz, 1'bz, 1'bz},
    OP,
    Y1
  );

endmodule


// testbench

`timescale 1ns / 1ps

module TEST();

  reg A, B;
  reg [2:0] OP;
  wire Y0, Y1;

  ALU alu (A, B, OP, Y0, Y1);

  initial begin
    $display("Solution by Adheesh Trivedi\n=====================");
    $monitor(
      {
        " > A=%b, B=%b, OP=%b\n",
        " | Y0=%b, Y1=%b"
      },
      A, B, OP, Y0, Y1
    );
    $dumpfile("q6.vcd");
    $dumpvars(0, TEST);

    // 2 example for each operation
    A = 0; B = 0; OP = 3'b000; #10;
    A = 1; B = 1; OP = 3'b000; #10;
    A = 0; B = 1; OP = 3'b001; #10;
    A = 1; B = 0; OP = 3'b001; #10;
    A = 0; B = 1; OP = 3'b010; #10;
    A = 1; B = 1; OP = 3'b010; #10;
    A = 0; B = 0; OP = 3'b011; #10;
    A = 1; B = 1; OP = 3'b011; #10;
    A = 0; B = 1; OP = 3'b100; #10;
    A = 1; B = 0; OP = 3'b100; #10;
    A = 0; B = 0; OP = 3'b101; #10;
    A = 1; B = 1; OP = 3'b101; #10;

    // No operation defined
    A = 0; B = 1; OP = 3'b110; #10;
    A = 1; B = 0; OP = 3'b111; #10;

  end

endmodule