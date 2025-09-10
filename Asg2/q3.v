
module MUX8TO1(
  input [7:0] I,
  input [2:0] S,
  output reg O
);
  always @(I, S) begin
    case (S)
      3'b000: O = I[0];
      3'b001: O = I[1];
      3'b010: O = I[2];
      3'b011: O = I[3];
      3'b100: O = I[4];
      3'b101: O = I[5];
      3'b110: O = I[6];
      3'b111: O = I[7];
      default: O = 1'b0;

    endcase
  end
endmodule


`timescale 1ns / 1ps

module TEST();
  reg [7:0] I;
  reg [2:0] S;
  wire O;

  MUX8TO1 M(I, S, O);

  initial begin
    $display("Solution by Adheesh Trivedi");
    $display("===========================");
    $dumpfile("q3.vcd");
    $dumpvars(0, TEST);

    $display("I        S   O");
    $display("---------------");
    $monitor("%b %b %b", I, S, O);

    I = 8'b00000000; S = 3'b000; #10;
    I = 8'b00000001; S = 3'b000; #10;
    I = 8'b00000010; S = 3'b001; #10;
    I = 8'b00000100; S = 3'b010; #10;
    I = 8'b00001000; S = 3'b011; #10;
    I = 8'b00010000; S = 3'b100; #10;
    I = 8'b00100000; S = 3'b101; #10;
    I = 8'b01000000; S = 3'b110; #10;
    I = 8'b10000000; S = 3'b111; #10;
    I = 8'b11111111; S = 3'b111; #10;
    I = 8'b10101010; S = 3'b101; #10;
    I = 8'b01010101; S = 3'b010; #10;

  end
endmodule
