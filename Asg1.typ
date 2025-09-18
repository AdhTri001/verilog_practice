#import "template/pset.typ": pset
#import "template/funcs.typ": verilogcode, codecaption, termimg_generic, plotimg_generic


#show: pset.with(
  class: "ECS 409: Computer Organization",
  title: "Assignment 1",
  student: "Adheesh Trivedi",
  date: datetime.today(),
  collaborators: (),
)

#let asgno = "asg1";
#let termimg(quesno) = termimg_generic(asgno, quesno);
#let plotimg(quesno) = plotimg_generic(asgno, quesno);

= 3-Input `AND` and `OR` Gates

Structural versions built only from primitive gates (`AND`, `OR`) plus wires.

== Verilog Code

Each module forms the 3-input function by first combining A & B, then feeding C.

Below is the verilog code for the 3-input `AND` and `OR` gates.

#let code = read("asg1/q1.v");

#grid(
  columns: 2,
  verilogcode(code, 2, 11, caption: "3-input AND gate"),
  verilogcode(code, 15, 11, caption: "3-input OR gate"),
)

== Testbench

Drives all 8 input combinations (every 10 ns), monitors outputs, and dumps VCD.

#grid(
  columns: 2,
  verilogcode(code, 30, 18),
  // To fill the block al the way to the bottom, we add some newlines
  verilogcode(code + "\r\n" * 10, 48, 19),
)

#codecaption("Testbench code")

== Simulation Result

Outputs match truth tables: AND is 1 only at A=B=C=1; OR is 1 for any high input.
Sequence below confirms every combination exactly once (ascending by binary value).

#image(
  termimg("q1")
)
#codecaption("Terminal output of the simulation")

#image(
  plotimg("q1")
)
#codecaption("Waveform (timing + annotated values)")


= 4-Bit Magnitude Comparator

Structural comparator built from four bitwise XNORs feeding a cascade of AND gates to assert equality only when every bit matches.

== Verilog Code

The equality vector is formed first, then reduced via AND tree for the single compare output.

#let code2 = read("asg1/q2.v");

#grid(
  columns: 2,
  verilogcode(code2, 2, 17, caption: "COMPARE module"),
  verilogcode(code2, 23, 31, caption: "Testbench"),
)

== Simulation Result

Each stimulus pair matches the expected XNOR bit mask; COMPARE=1 only when all four bits are equal (0101==0101 and 1110==1110 cases).

#image(plotimg("q2"))
#codecaption("Waveform (bitwise matches and final compare)")

#image(termimg("q2"))
#codecaption("Terminal output of the simulation")


= Half/Full Adder & Half/Full Subtractor

Structural ripple-style constructions: FULL_ADD uses two XORs plus AND/OR network; HALF_ADD is a FULL_ADD with Cin=0.
Subtractor is implemented the other way, with borrow logic using two HALF_SUB stages and OR for final borrow in FULL_SUB.

== Verilog Code (Addition)

#let code3a = read("asg1/q3_add.v");

#grid(
  columns: 2,
  verilogcode(code3a, 2, 20, caption: "FULL_ADD"),
  verilogcode(code3a, 23, 8, caption: "HALF_ADD"),
)

== Testbench (Addition)

#grid(
  columns: 2,
  verilogcode(code3a, 35, 21),
  verilogcode(code3a + "\r\n" * 10, 56, 22),
)
#codecaption("Adder testbench code")

== Simulation Result (Addition)

All 8 input combinations confirm HALF_ADD and FULL_ADD sums and carries match truth table (carry only when ≥2 inputs high).

#image(termimg("q3_add"), width: 80%)
#codecaption("Adder terminal output")

#image(plotimg("q3_add"))
#codecaption("Adder waveform")

== Verilog Code (Subtraction)

#let code3s = read("asg1/q3_sub.v");

#grid(
  columns: 2,
  verilogcode(code3s, 2, 15, caption: "HALF_SUB"),
  verilogcode(code3s, 18, 15, caption: "FULL_SUB"),
)

== Testbench (Subtraction)

#grid(
  columns: 2,
  verilogcode(code3s, 34, 21),
  verilogcode(code3s + "\r\n" * 10, 55, 22),
)
#codecaption("Subtractor testbench code")

== Simulation Result (Subtraction)

Borrow asserted exactly when needed for A−B−C.

#image(plotimg("q3_sub"))
#codecaption("Subtractor waveform")

#image(termimg("q3_sub"), width: 80%)
#codecaption("Subtractor terminal output")


= 3-to-8 Decoder & 4-to-1 Multiplexer

Decoder uses input and their complements to drive one-hot outputs. MUX selects among four inputs using minterms and OR reduction.

== Verilog Code (Decoder)

#let code4d = read("asg1/q4_dec.v");

#grid(
  columns: 2,
  verilogcode(code4d, 2, 20, caption: "3-to-8 Decoder"),
  verilogcode(code4d, 26, 33, caption: "Decoder Testbench"),
)

== Simulation Result (Decoder)

Output word cycles through single high bit in binary order confirming one-hot behavior for all input combinations. The graph for the output shows exponential growth as each successive bit is set.

#image(plotimg("q4_dec"))
#codecaption("Decoder waveform")

#image(termimg("q4_dec"), width: 80%)
#codecaption("Decoder terminal output")


== Verilog Code (Multiplexer)

#let code4m = read("asg1/q4_mux.v");

#grid(
  columns: 2,
  verilogcode(code4m, 2, 22, caption: "4-to-1 MUX"),
  verilogcode(code4m, 28, 39, caption: "MUX Testbench"),
)

== Simulation Result (Multiplexer)

For two input patterns, each select value routes the correct bit to Y; waveform shows gating signals and OR tree result.

#image(termimg("q4_mux"), width: 70%)
#codecaption("MUX terminal output")

#image(plotimg("q4_mux"))
#codecaption("MUX waveform")

= 4-Bit Barrel Shifter (1- & 2-bit Rotational Shifts)

Two independent shifters are built from the same `MUX2x1` primitive: `SHIFTER1B` performs a 1-bit circular rotate, `SHIFTER2B` performs a 2-bit circular rotate. Direction (`dir`) selects left (0) or right (1) rotation; wiring of multiplexer inputs determines which original bit appears at each output position after the rotate distance.

== Verilog Code

#let code5 = read("asg1/q5.v");

#grid(
  columns: 3,
  verilogcode(code5, 2, 15, caption: "MUX2x1"),
  verilogcode(code5, 18, 25, caption: "1-bit Shifter"),
  verilogcode(code5, 44, 25, caption: "2-bit Shifter"),
)

== Testbench

#grid(
  columns: 2,
  verilogcode(code5, 73, 18),
  verilogcode(code5 + "\r\n" * 10, 91, 19),
)
#codecaption("Shifter testbench code (O1=1-bit rotate, O2=2-bit rotate)")

== Simulation Result

Results match expected circular permutations. Separate modules clarify distinct wiring for 1- vs 2-bit paths.

#image(termimg("q5"))
#codecaption("Shifter terminal output (includes both distances)")

#image(plotimg("q5"))
#codecaption("Shifter waveform (shows O1 & O2 evolution)")

= Simple 1-Bit ALU

ALU composes bitwise primitives and two 8:1 multiplexers to select outputs per opcode. Y0 carries primary result; Y1 provides carry/borrow for arithmetic cases; undefined opcodes yield don't care (x).

== Verilog Code

#let code6 = read("asg1/q6.v");

#grid(
  columns: 2,
  verilogcode(code6, 2, 24, caption: "MUX8x1"),
  verilogcode(code6, 38, 30, caption: "ALU"),
)

== Testbench

#grid(
  columns: 2,
  verilogcode(code6, 72, 21),
  verilogcode(code6 + "\r\n" * 10, 93, 22),
)
#codecaption("ALU testbench code")

== Simulation Result

All defined opcodes produce correct logical/arithmetic outputs (AND, OR, XOR, ADD, SUB, MULT alias) with carry/borrow (or borrow) reflected on Y1; undefined opcodes show don't-care (x) outputs as routed via unused MUX inputs.

Why no waveform figure: The waveform would be cluttered and hard to read due to the many signals and rapid changes and don't cares (x). The terminal output fully characterizes the ALU's single-bit combinational behavior across some input combinations and opcodes, making it a more effective summary of functionality.

#image(termimg("q6"))
#codecaption("ALU terminal output")