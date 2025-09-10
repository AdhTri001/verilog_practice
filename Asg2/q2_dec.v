
module DEC2TO4(
  input [1:0] I,
  output reg [3:0] O,
  output reg valid
);
  always @(I) begin
    case (I)
      2'b00: begin O = 4'b0001; valid = 1; end
      2'b01: begin O = 4'b0010; valid = 1; end
      2'b10: begin O = 4'b0100; valid = 1; end
      2'b11: begin O = 4'b1000; valid = 1; end
      default: begin O = 4'b0000; valid = 0; end

    endcase
  end
endmodule


`timescale 1ns / 1ps

module TEST();
  reg [1:0] I;
  wire [3:0] O;
  wire valid;

  DEC2TO4 D(I, O, valid);

  initial begin
    $display("Solution by Adheesh Trivedi");
    $display("===========================");
    $display("I  O    Valid");
    $display("-------------");
    $monitor("%b %b %b", I, O, valid);

    I = 2'b00; #10;
    I = 2'b01; #10;
    I = 2'b10; #10;
    I = 2'b11; #10;

  end
endmodule
