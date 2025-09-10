
module PRIOENC8TO3(
  input [7:0] I,
  output reg [2:0] O
);
  always @(I) begin
    if (I[7]) begin O = 3'b111; end
    else if (I[6]) begin O = 3'b110; end
    else if (I[5]) begin O = 3'b101; end
    else if (I[4]) begin O = 3'b100; end
    else if (I[3]) begin O = 3'b011; end
    else if (I[2]) begin O = 3'b010; end
    else if (I[1]) begin O = 3'b001; end
    else if (I[0]) begin O = 3'b000; end
    else begin O = 3'b000; end

  end
endmodule


`timescale 1ns / 1ps

module TEST();
  reg [7:0] I;
  wire [2:0] O;

  PRIOENC8TO3 P(I, O);

  initial begin
    $display("Solution by Adheesh Trivedi");
    $display("===========================");
    $display("I          O  ");
    $display("--------------");
    $monitor("%b %b", I, O);

    I = 8'b00000000; #10;
    I = 8'b00000001; #10;
    I = 8'b00000010; #10;
    I = 8'b00000100; #10;
    I = 8'b00001000; #10;
    I = 8'b00010000; #10;
    I = 8'b00100000; #10;
    I = 8'b01000000; #10;
    I = 8'b10000000; #10;
    I = 8'b11111111; #10;
    I = 8'b10101010; #10;
    I = 8'b01010101; #10;

  end
endmodule