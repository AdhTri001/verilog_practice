
module MUX2x1 (
  input A,
  input B,
  input S,
  output O
);

  wire not_S;

  not (not_S, S);
  and (and_1, not_S, A);
  and (and_2, S, B);
  or (O, and_1, and_2);

endmodule

module SHIFTER1B (
  input [3:0] I,
  // direction: 0 left, 1 right
  input dir,
  output [3:0] O
);

  MUX2x1 mux0 (
    I[2], I[0],
    dir, O[3]
  );
  MUX2x1 mux1 (
    I[1], I[3],
    dir, O[2]
  );
  MUX2x1 mux2 (
    I[0], I[2],
    dir, O[1]
  );
  MUX2x1 mux3 (
    I[3], I[1],
    dir, O[0]
  );

endmodule

module SHIFTER2B (
  input [3:0] I,
  // direction: 0 left, 1 right
  input dir,
  output [3:0] O
);

  MUX2x1 mux0 (
    I[1], I[1],
    dir, O[3]
  );
  MUX2x1 mux1 (
    I[0], I[0],
    dir, O[2]
  );
  MUX2x1 mux2 (
    I[3], I[3],
    dir, O[1]
  );
  MUX2x1 mux3 (
    I[2], I[2],
    dir, O[0]
  );

endmodule


// testbench

`timescale 1ns / 1ps

module TEST();

  reg [3:0] I;
  reg dir;
  wire [3:0] O1, O2;

  SHIFTER1B sft1 (I, dir, O1);
  SHIFTER2B sft2 (I, dir, O2);

  initial begin
    $monitor(
      {
        " > I = %b, dir = %b\n",
        " | O1 = %b, O2 = %b"
      },
      I, dir, O1, O2
    );
    $dumpfile("q5.vcd");
    $dumpvars(0, TEST);

    I = 4'b0101; dir = 0; #10;
    I = 4'b1011; dir = 1; #10;
    I = 4'b0111; dir = 0; #10;
    I = 4'b0111; dir = 1; #10;

  end

endmodule
