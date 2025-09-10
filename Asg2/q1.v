
module MULTBY2(input [3:0] I, output [3:0] O, output carry);

  assign O = I << 1;
  assign carry = I[3];

endmodule


`timescale 1ns / 1ps

module TEST();
  reg [3:0] I;
  wire [3:0] O;
  wire carry;

  MULTBY2 M(I, O, carry);

  initial begin
    $display("Solution by Adheesh Trivedi");
    $display("===========================");
    $dumpfile("q1.vcd");
    $dumpvars(0, TEST);

    $display("");
    $display("I    O    Carry");
    $display("---------------");
    $monitor("%b %b %b", I, O, carry);

    I = 4'b0000; #10;
    I = 4'b0001; #10;
    I = 4'b0010; #10;
    I = 4'b0111; #10;
    I = 4'b0100; #10;
    I = 4'b1010; #10;
    I = 4'b1111; #10;

  end
endmodule
