
module COMPARE(input [3:0] A, input [3:0] B, output [3:0] comp_AB, output comp);

  wire t1, t2;

  xnor (comp_AB[3], A[3], B[3]);
  xnor (comp_AB[2], A[2], B[2]);
  xnor (comp_AB[1], A[1], B[1]);
  xnor (comp_AB[0], A[0], B[0]);

  and (t1, comp_AB[3], comp_AB[2]);
  and (t2, t1, comp_AB[1]);
  and (comp, t2, comp_AB[0]);

endmodule


// testbench

`timescale 1ns / 1ps

module TEST();

  reg [3:0] A, B;
  wire [3:0] comp_AB;
  wire comp;

  COMPARE op1(A, B, comp_AB, comp);


  initial begin

    $monitor(
      {
        " > A=%b, B=%b\n",
        " | | A_xnor_B=%b, COMPARE=%b"
      },
      A, B, comp_AB, comp);
    $dumpfile("q2.vcd");
    $dumpvars(0, TEST);

    A = 4'b0101; B = 4'b0101; #10;
    A = 4'b1100; B = 4'b1110; #10;
    A = 4'b1110; B = 4'b1110; #10;
    A = 4'b0010; B = 4'b0100; #10;

  end

endmodule
