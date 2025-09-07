
module MUX4x1 (
  input  [3:0] I,
  input  [1:0] S,
  output Y
);

  wire nS0, nS1;
  not (nS0, S[0]);
  not (nS1, S[1]);

  wire w0, w1, w2, w3;
  and (w0, I[0], nS1, nS0);
  and (w1, I[1], nS1, S[0]);
  and (w2, I[2], S[1], nS0);
  and (w3, I[3], S[1], S[0]);

  wire t1, t2;
  or (t1, w0, w1);
  or (t2, w2, w3);
  or (Y, t1, t2);

endmodule


// testbench

`timescale 1ns / 1ps

module TEST();

  reg [3:0] I;
  reg [1:0] S;
  wire Y;

  MUX4x1 dut (I, S, Y);

  initial begin
    $monitor(
      {
        " > I=%b, S=%d\n",
        " | | Y=%b"
      },
      I, S, Y
    );
    $dumpfile("q4_mux.vcd");
    $dumpvars(0, TEST);

    I = 4'b1010;
    S = 2'b00; #10;
    S = 2'b01; #10;
    S = 2'b10; #10;
    S = 2'b11; #10;

    I = 4'b0111;
    S = 2'b00; #10;
    S = 2'b01; #10;
    S = 2'b10; #10;
    S = 2'b11; #10;

  end

endmodule
