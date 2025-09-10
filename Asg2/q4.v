
module PRIOENC8TO3(
  input [7:0] I,
  output reg [2:0] O,
  output reg valid
);
  always @(I) begin
    if (I[7]) begin O = 3'b111; end
    else if (I[6]) begin O = 3'b110; valid = 1; end
    else if (I[5]) begin O = 3'b101; valid = 1; end
    else if (I[4]) begin O = 3'b100; valid = 1; end
    else if (I[3]) begin O = 3'b011; valid = 1; end
    else if (I[2]) begin O = 3'b010; valid = 1; end
    else if (I[1]) begin O = 3'b001; valid = 1; end
    else if (I[0]) begin O = 3'b000; valid = 1; end
    else begin O = 3'b000; valid = 0; end

  end
endmodule


`timescale 1ns / 1ps

module TEST();
  reg [7:0] I;
  wire [2:0] O;
  wire valid;

  PRIOENC8TO3 P(I, O, valid);

  initial begin
    $display("Solution by Adheesh Trivedi");
    $display("===========================");
    $dumpfile("q4.vcd");
    $dumpvars(0, TEST);

    $display("I          O  Valid");
    $display("-------------------");
    $monitor("%b %b %b", I, O, valid);

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
