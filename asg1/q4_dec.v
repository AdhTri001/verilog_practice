
module DEC (
  input A, input B, input C,
  output [7:0] D
);

  wire not_A, not_B, not_C;
  not (not_A, A);
  not (not_B, B);
  not (not_C, C);

  and (D[0], not_A, not_B, not_C);
  and (D[1], not_A, not_B, C);
  and (D[2], not_A, B, not_C);
  and (D[3], not_A, B, C);
  and (D[4], A, not_B, not_C);
  and (D[5], A, not_B, C);
  and (D[6], A, B, not_C);
  and (D[7], A, B, C);

endmodule


// testbench

`timescale 1ns / 1ps

module TEST();

  reg A, B, C;
  wire [7:0] D;

  DEC dut (A, B, C, D);

  initial begin
    $display("Solution by Adheesh Trivedi\n=====================");
    $monitor(
      {
        " > A=%b, B=%b, C=%b\n",
        " | | D=%b"
      },
      A, B, C, D
    );
    $dumpfile("q4_dec.vcd");
    $dumpvars(0, TEST);

    A = 0; B = 0; C = 0; #10;
    A = 0; B = 0; C = 1; #10;
    A = 0; B = 1; C = 0; #10;
    A = 0; B = 1; C = 1; #10;
    A = 1; B = 0; C = 0; #10;
    A = 1; B = 0; C = 1; #10;
    A = 1; B = 1; C = 0; #10;
    A = 1; B = 1; C = 1; #10;

  end

endmodule
