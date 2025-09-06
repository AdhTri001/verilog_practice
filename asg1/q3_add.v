
module FULL_ADD (
  input A, input B, input C,
  output sum_ABC, output carry_ABC
);

  wire xor_AB;

  // sum = A ^ B ^ C
  xor (xor_AB, A, B);
  xor (sum_ABC, xor_AB, C);

  wire and_AB, and_C_xor_AB;

  and (and_AB, A, B);
  and (and_C_xor_AB, C, xor_AB);

  // carry = (A & B) | C & (A ^ B)
  or (carry_ABC, and_AB, and_C_xor_AB);

endmodule

module HALF_ADD (
  input A, input B,
  output sum_AB, output carry_AB
);

  FULL_ADD g1 (A, B, 0, sum_AB, carry_AB);

endmodule


// testbench

`timescale 1ns / 1ps

module TEST();

  reg A, B, C;
  wire sum_ABC, carry_ABC;
  wire sum_AB, carry_AB;

  HALF_ADD g1 (A, B, sum_AB, carry_AB);
  FULL_ADD g2 (A, B, C, sum_ABC, carry_ABC);


  initial begin
    $monitor(
      {
        " > A=%b, B=%b, C=%b\n",
        " | > Half Add (A, B)\n",
        " | | | s=%b, c=%b\n",
        " | > Full Add (A, B, C)\n",
        " | | | s=%b, c=%b"
      },
      A, B, C, sum_AB, carry_AB,
      sum_ABC, carry_ABC
    );
    $dumpfile("q3_add.vcd");
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
