
module ENC4TO2(
  input [3:0] I,
  output reg [1:0] O
);
  always @(I) begin
    case (I)
      4'b0001: begin O = 2'b00; end
      4'b0010: begin O = 2'b01; end
      4'b0100: begin O = 2'b10; end
      4'b1000: begin O = 2'b11; end

    endcase
  end
endmodule


`timescale 1ns / 1ps

module TEST();
  reg [3:0] I;
  wire [1:0] O;

  ENC4TO2 E(I, O);

  initial begin
    $display("Solution by Adheesh Trivedi");
    $display("===========================");
    $dumpfile("q2_enc.vcd");
    $dumpvars(0, TEST);

    $display("I    O");
    $display("-------");
    $monitor("%b %b", I, O);

    I = 4'b0001; #10;
    I = 4'b0010; #10;
    I = 4'b0100; #10;
    I = 4'b1000; #10;

  end
endmodule
