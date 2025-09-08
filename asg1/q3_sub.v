
module HALF_SUB (
  input A, input B,
  output dif_AB, output brrw_AB
);

  // diff = A ^ B
  xor (dif_AB, A, B);

  wire not_A, and_AB, and_C_xor_AB;

  // borrow = ~A | B
  not (not_A, A);
  and (brrw_AB, not_A, B);

endmodule

module FULL_SUB (
  input A, input B, input Din,
  output dif_ABC, output brrw_ABC
);

  wire dif_AB, brrw_AB, brrw2;

  HALF_SUB g1 (A, B, dif_AB, brrw_AB);
  HALF_SUB g2 (dif_AB, Din, dif_ABC, brrw2);
  or (brrw_ABC, brrw_AB, brrw2);

endmodule


// testbench

`timescale 1ns / 1ps

module TEST();

  reg A, B, C;
  wire dif_ABC, brrw_ABC;
  wire dif_AB, brrw_AB;

  HALF_SUB g1 (A, B, dif_AB, brrw_AB);
  FULL_SUB g2 (A, B, C, dif_ABC, brrw_ABC);


  initial begin
    $display("Solution by Adheesh Trivedi\n=====================");
    $monitor(
      {
        " > A=%b, B=%b, C=%b\n",
        " | > Half Add (A, B)\n",
        " | | | s=%b, c=%b\n",
        " | > Full Add (A, B, C)\n",
        " | | | s=%b, c=%b"
      },
      A, B, C, dif_AB, brrw_AB,
      dif_ABC, brrw_ABC
    );
    $dumpfile("q3_sub.vcd");
    $dumpvars(0, TEST);

    A = 0; B = 0; C = 0; #10;
    A = 1; B = 0; C = 0; #10;
    A = 0; B = 1; C = 0; #10;
    A = 1; B = 1; C = 0; #10;
    A = 0; B = 0; C = 1; #10;
    A = 1; B = 0; C = 1; #10;
    A = 0; B = 1; C = 1; #10;
    A = 1; B = 1; C = 1; #10;

  end

endmodule
