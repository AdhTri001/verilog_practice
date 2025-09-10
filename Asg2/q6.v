
module HALF_ADDER (
  input A,
  input B,
  output S,
  output C
);
  assign S = A ^ B;
  assign C = A & B;

endmodule


module FULL_ADDER (
  input A,
  input B,
  input Ci,
  output S,
  output Co
);

  assign S = A ^ B ^ Ci;
  assign Co = A & B | ((A | B) & Ci);

endmodule

module WALLACE_TREE_MULT4 (
  input [3:0] A,
  input [3:0] B,
  output [7:0] M
);

  // Partial products
  wire [3:0] P0, P1, P2, P3;

  // Generate partial products
  assign P0 = A & {4{B[0]}};
  assign P1 = A & {4{B[1]}};
  assign P2 = A & {4{B[2]}};
  assign P3 = A & {4{B[3]}};

  // Intermediate wires for carries and sums
  wire c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11; // added c11
  wire s1, s2, s3, s4, s5, s6; // removed unused s7,s8,s9

  // First bit (no addition needed)
  assign M[0] = P0[0];

  // Second bit
  HALF_ADDER ha1 (P0[1], P1[0], M[1], c1);

  // Third bit - first level
  FULL_ADDER fa1 (P0[2], P1[1], P2[0], s1, c2);
  HALF_ADDER ha2 (s1, c1, M[2], c3);

  // Fourth bit - first level
  FULL_ADDER fa2 (P0[3], P1[2], P2[1], s2, c4);
  FULL_ADDER fa3 (s2, c2, P3[0], s3, c5);
  HALF_ADDER ha3 (s3, c3, M[3], c6);

  // Fifth bit - first level
  FULL_ADDER fa4 (P1[3], P2[2], P3[1], s4, c7);
  FULL_ADDER fa5 (s4, c4, c5, s5, c8);
  HALF_ADDER ha4 (s5, c6, M[4], c9);

  // Sixth bit
  FULL_ADDER fa6 (P2[3], P3[2], c7, s6, c10);
  FULL_ADDER fa7 (s6, c8, c9, M[5], c11);

  // Seventh bit
  FULL_ADDER fa8 (P3[3], c10, c11, M[6], M[7]);

endmodule


`timescale 1ns / 1ps

module TEST();
  reg [3:0] A, B;
  wire [7:0] M;

  WALLACE_TREE_MULT4 WTM(A, B, M);

  initial begin
    $display("Solution by Adheesh Trivedi");
    $display("===========================");
    $display("A  B  | M");
    $display("-----------");
    $monitor("%d %d | %d", A, B, M);

    A = 4'b0000; B = 4'b0000; #10;
    A = 4'b0100; B = 4'b0101; #10;
    A = 4'b1010; B = 4'b1001; #10;
    A = 4'b1111; B = 4'b1111; #10;
    A = 4'b0001; B = 4'b0001; #10;
    A = 4'b0010; B = 4'b0011; #10;
    A = 4'b0110; B = 4'b0011; #10;
    A = 4'b1001; B = 4'b1110; #10;

  end
endmodule