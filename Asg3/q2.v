`timescale 1ns / 1ps

module d_latch (
  input D, CLK,
  output reg Q
);
  reg N1, N2, not_CLK;

  initial Q = 0;

  always @(D or CLK or not_CLK or N1 or N2 or Q) begin
    #1 N1 = D & CLK;
    #1 not_CLK = ~CLK;
    #1 N2 = not_CLK & Q;
    #1 Q = N1 | N2;
  end

endmodule


module TEST();
  reg D, CLK;
  wire Q;

  d_latch dl (D, CLK, Q);

  initial CLK = 0;
  always begin
    #10; CLK = ~CLK;
  end

  initial begin
    $dumpfile("q2.vcd");
    $dumpvars(0, TEST);
    $display("Solution by Adheesh Trivedi");
    $display("===========================");

    $display("");
    $display("Time  D CLK Q");
    $display("---------------");
    $monitor("%5t %b  %b  %b", $time, D, CLK, Q);

    D = 0; #9;
    D = 1; #13;
    D = 0; #16;
    D = 1; #21;
    D = 0; #26;

    $finish;
  end
endmodule
