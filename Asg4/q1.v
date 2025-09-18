`timescale 1ns / 1ps

module MOORE_FSM ( input A, B, CLK, RST, output Q );

  parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;

  reg [1:0] state, nextstate;

  initial state = S0;

  always @(posedge CLK, posedge RST)
    if (RST) state <= S0;
    else
      state <= nextstate;

  always @(*)
    case (state)
      S0: nextstate = A ? S1 : S0;
      S1: nextstate = B ? S2 : S0;
      S2: nextstate = S0;
      default: nextstate = S0;
    endcase

  assign Q = ( state == S2 );

endmodule

module TEST();

  reg A, B, CLK, RST;
  wire Q;

  MOORE_FSM fsm (A, B, CLK, RST, Q);

  initial CLK = 0;
  always begin
    #5; CLK = ~CLK;
  end

  initial begin
    $display("Solution by Adheesh Trivedi");
    $display("===========================");
    $dumpfile("q1.vcd");
    $dumpvars(0, TEST);

    $display("");
    $display("RST A B Q");
    $display("----------");
    $monitor(" %b  %b %b %b", RST, A, B, Q);

    // S0
    RST = 0; A = 1; B = 0; #10; // S1
    RST = 1; B = 1; #10; // Q = 0 if reset
    RST = 0; #10; // S1
    #12; // S2 => Q = 1
    RST = 1; #5; // S0 => Q = 0
    RST = 0; #3;
    A = 0; B = 0; #10; // S1
    #12; // Stays in S1

    $finish;
  end
endmodule
