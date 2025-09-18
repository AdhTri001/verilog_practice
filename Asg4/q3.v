`timescale 1ns / 1ps

// Detects the substring "1101" in the input stream
module SUBSTR_FSM ( input I, CLK, RST, output Q );

  parameter S0 = 3'b000;
  parameter S1 = 3'b001;
  parameter S2 = 3'b010;
  parameter S3 = 3'b011;
  parameter S4 = 3'b100;

  reg [2:0] state, nextstate;

  initial state = S0;

  always @(posedge CLK, posedge RST)
    if (RST) state <= S0;
    else
      state <= nextstate;

  always @(*)
    case (state)
      S0: nextstate = I ? S1 : S0;
      S1: nextstate = I ? S2 : S0;
      S2: nextstate = I ? S2 : S3;
      S3: nextstate = I ? S4 : S0;
      S4: nextstate = S4;
      default: nextstate = S0;
    endcase

  assign Q = ( state == S4 );

endmodule

module TEST();

  reg I, CLK, RST;
  wire Q;

  SUBSTR_FSM fsm (I, CLK, RST, Q);

  initial CLK = 0;
  always begin
    #5; CLK = ~CLK;
  end

  initial begin
    $display("Solution by Adheesh Trivedi");
    $display("===========================");
    $dumpfile("q3.vcd");
    $dumpvars(0, TEST);

    $display("");
    $display("RST I Q");
    $display("----------");
    $monitor(" %b  %b %b", RST, I, Q);

    // Input sequence: 1101101
    RST = 0; I = 1; #10; // S1
    I = 1; #10; // S2
    I = 0; #10; // S3
    I = 1; #10; // S4
    I = 1; #10; // S4
    I = 0; #10; // S4
    I = 1; #12; // S4
    RST = 1; #5; // S0
    // Input sequence: 1011
    RST = 0; I = 1; #13; // S1
    I = 0; #10; // S2
    I = 1; #10; // S3
    I = 1; #12; // S4

    $finish;
  end
endmodule
