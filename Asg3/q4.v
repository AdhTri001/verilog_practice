`timescale 1ns / 1ps

module GRAY_COUNTER (
  input CLK, input Rst, input UP,
  output reg [2:0] Q
);
  initial Q = 3'b000;

  always @(posedge CLK or posedge Rst) begin
    if (Rst) begin
      Q <= 3'b000;
    // Derived from K-MAPS
    end else if (UP) begin
      Q[0] <= ~ (Q[1] ^ Q[2]);
      Q[1] <= Q[0] ? ~Q[2] : Q[1];
      Q[2] <= Q[0] ? Q[2] : Q[1];
    end
  end
endmodule


module TEST();
  reg CLK, Rst, UP;
  wire [2:0] Q;

  GRAY_COUNTER gc (CLK, Rst, UP, Q);

  initial CLK = 0;

  always begin
    #5; CLK = ~CLK;
  end

  initial begin
    $dumpfile("q4.vcd");
    $dumpvars(0, TEST);
    $display("Solution by Adheesh Trivedi");
    $display("===========================");

    $display("");
    $display("UP Q");
    $display("------");
    $monitor("%b  %b", UP, Q);

    Rst = 1; UP = 1; #6;
    Rst = 0; #44;
    UP = 0; #8;
    UP = 1; #42;

    $finish;
  end
endmodule
