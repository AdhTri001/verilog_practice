`timescale 1ns / 1ps

module SR_LATCH (
  input S, R, En, Rst,
  output reg Q
);
  always @(*) begin
    // Asynchronous Reset dominates
    if (Rst) Q = 0;
    else if (En) begin
      if (S & ~R) begin
        Q = 1;
      end else if (~S & R) begin
        Q = 0;
      end
    end
  end
endmodule


module TEST();
  reg S, R, En, Rst;
  wire Q;

  SR_LATCH uut (S, R, En, Rst, Q);

  initial begin
    $dumpfile("q1.vcd");
    $dumpvars(0, TEST);
    $display("Solution by Adheesh Trivedi");
    $display("===========================");

    $display("");
    $display("S R En Rst Q");
    $display("-------------");
    $monitor("%b %b %b  %b   %b", S, R, En, Rst, Q);

    // Asynchronous Reset
    S = 0; R = 0; En = 0; Rst = 1; #5;
    Rst = 0; #5;
    // Set
    S = 1; R = 0; En = 1; #5;
    S = 0; #5;
    // Reset
    S = 0; R = 1; En = 1; #5;
    R = 0; En = 0; #5;
    // Not Enabled
    S = 1; R = 0; #5;
    // Enabled again
    En = 1; #5;
    S = 0; #10;

  end
endmodule
