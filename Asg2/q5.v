
module CARRY_LOOKAHEAD4 (
  input [3:0] A,
  input [3:0] B,
  input Ci,
  output reg [3:0] S,
  output reg Co
);
  reg [3:0] P, G;
  reg [3:0] C;
  integer i;

  always @(*) begin
    G = A & B;
    P = A ^ B;
    C[0] = Ci;

    // Ci+1 = Gi | Pi & Ci
    for (i = 0; i < 3; i++) begin
      C[i+1] = G[i] | (P[i] * C[i]);
    end
    Co = G[3] | (P[3] * C[3]);
    S = P ^ C;

  end
endmodule


`timescale 1ns / 1ps

module TEST();
  reg [3:0] A, B;
  reg Ci;
  wire [3:0] S;
  wire Co;

  CARRY_LOOKAHEAD4 CLA(A, B, Ci, S, Co);

  initial begin
    $display("Solution by Adheesh Trivedi");
    $display("===========================");
    $dumpfile("q5.vcd");
    $dumpvars(0, TEST);

    $display("A    B    Ci | S    Co");
    $display("----------------------");
    $monitor("%b %b %b  | %b %b", A, B, Ci, S, Co);

    A = 4'b0000; B = 4'b0000; Ci = 0; #10;
    A = 4'b0001; B = 4'b0001; Ci = 0; #10;
    A = 4'b0010; B = 4'b0011; Ci = 0; #10;
    A = 4'b0100; B = 4'b0101; Ci = 0; #10;
    A = 4'b1010; B = 4'b1001; Ci = 0; #10;
    A = 4'b1111; B = 4'b1111; Ci = 0; #10;

    A = 4'b0000; B = 4'b0000; Ci = 1; #10;
    A = 4'b0001; B = 4'b0001; Ci = 1; #10;
    A = 4'b0010; B = 4'b0011; Ci = 1; #10;
    A = 4'b0100; B = 4'b0101; Ci = 1; #10;
    A = 4'b1010; B = 4'b1001; Ci = 1; #10;
    A = 4'b1111; B = 4'b1111; Ci = 1; #10;

  end
endmodule
