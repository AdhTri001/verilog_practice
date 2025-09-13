`timescale 1ns / 1ps

module COUNTER(
  input wire CLK, Rst,
  output reg [2:0] Q
);
  initial Q = 3'b000;

  always @(posedge CLK or posedge Rst) begin
    // Prioritize reset
    if (Rst) begin
      Q <= 3'b000;
    end else begin
      Q <= Q - 1;
    end
  end
endmodule


module TEST();
  reg CLK, Rst;
  wire [2:0] Q;

  COUNTER uut (CLK, Rst, Q);

  always begin
    #5;
    CLK = ~CLK;
  end

  initial begin
    $dumpfile("q3.vcd");
    $dumpvars(0, TEST);
    $display("Solution by Adheesh Trivedi");
    $display("===========================");

    $display("");
    $display("Rst  Q");
    $display("-------");
    $monitor("%2b  %b", Rst, Q);

    CLK = 0; Rst = 1; #10;
    Rst = 0;
    #57;

    Rst = 1; #10;
    Rst = 0; #80;

    $finish;
  end
endmodule
