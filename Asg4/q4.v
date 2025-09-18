`timescale 1ns / 1ps

module MODULER_2A_B_FSM ( input A, B, CLK, RST, output O );

  parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  parameter S3 = 2'b11;

  reg [1:0] state, nextstate;

  initial state = S0;

  always @(posedge CLK, posedge RST)
    if (RST) state <= S0;
    else
      state <= nextstate;

  always @(*)
    nextstate = state + 2 * A + B;

  assign O = ( state == S1 );

endmodule

module TEST();

  reg A, B, CLK, RST;
  wire Q;

  MODULER_2A_B_FSM fsm (A, B, CLK, RST, Q);

  initial CLK = 0;
  always begin
    #5; CLK = ~CLK;
  end

  initial begin
    $display("Solution by Adheesh Trivedi");
    $display("===========================");
    $dumpfile("q4.vcd");
    $dumpvars(0, TEST);

    $display("");
    $display("RST A B Q");
    $display("----------");
    $monitor(" %b  %b %b %b", RST, A, B, Q);

    RST = 0; A = 0; B = 1; #12;
    RST = 1; #5;
    RST = 0; #3;
    A = 1; B = 0; #10;
    A = 0; B = 0; #10;
    A = 1; B = 1; #10;
    A = 1; B = 0; #12;

    $finish;
  end
endmodule
