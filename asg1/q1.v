
module AND(
  input A, input B, input C,
  output and_ABC
);

  wire t;

  and AB(t, A, B);
  and tC(and_ABC, t, C);

endmodule


module OR(
  input A, input B, input C,
  output or_ABC
);

  wire t;

  or AB(t, A, B);
  or tC(or_ABC, t, C);

endmodule


// testbench

`timescale 1ns / 1ps

module TEST();

  reg A, B, C;
  wire and_ABC, or_ABC;

  AND op1(A, B, C, and_ABC);
  OR op2(A, B, C, or_ABC);


  initial begin
    $monitor(
      {
        " > A=%b, B=%b, C=%b\n",
        " | | AND=%b, OR=%b"
      },
      A, B, C, and_ABC, or_ABC
    );
    $dumpfile("q1.vcd");
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
