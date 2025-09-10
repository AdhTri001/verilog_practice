
module DEC2TO4(
  input [1:0] I,
  output reg [3:0] O
);
  always @(I) begin
    case (I)
      2'b00: begin O = 4'b0001; end
      2'b01: begin O = 4'b0010; end
      2'b10: begin O = 4'b0100; end
      2'b11: begin O = 4'b1000; end

    endcase
  end
endmodule


`timescale 1ns / 1ps

module TEST();
  reg [1:0] I;
  wire [3:0] O;

  DEC2TO4 D(I, O);

  initial begin
    $display("Solution by Adheesh Trivedi");
    $display("===========================");
    $dumpfile("q2_dec.vcd");
    $dumpvars(0, TEST);

    $display("I  O");
    $display("-------");
    $monitor("%b %b", I, O);

    I = 2'b00; #10;
    I = 2'b01; #10;
    I = 2'b10; #10;
    I = 2'b11; #10;

  end
endmodule
