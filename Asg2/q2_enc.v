
module ENC4TO2(
  input [3:0] I,
  output reg [1:0] O,
  output reg valid
);
  always @(I) begin
    case (I)
      4'b0001: begin O = 2'b00; valid = 1; end
      4'b0010: begin O = 2'b01; valid = 1; end
      4'b0100: begin O = 2'b10; valid = 1; end
      4'b1000: begin O = 2'b11; valid = 1; end
      default: begin O = 2'b00; valid = 0; end

    endcase
  end
endmodule


`timescale 1ns / 1ps

module TEST();
  reg [3:0] I;
  wire [1:0] O;
  wire valid;

  ENC4TO2 E(I, O, valid);

  initial begin
    $display("Solution by Adheesh Trivedi");
    $display("===========================");
    $display("I    O  Valid");
    $display("-------------");
    $monitor("%b %b %b", I, O, valid);

    I = 4'b0000; #10;
    I = 4'b0001; #10;
    I = 4'b0010; #10;
    I = 4'b0011; #10;
    I = 4'b0100; #10;
    I = 4'b0101; #10;
    I = 4'b0110; #10;
    I = 4'b0111; #10;
    I = 4'b1000; #10;
    I = 4'b1111; #10;

  end
endmodule