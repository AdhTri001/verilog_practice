#import "pset.typ": pset
#import "funcs.typ": verilogcode


#show: pset.with(
  class: "ECS 409: Computer Organization",
  title: "Assignment 1",
  student: "Adheesh Trivedi",
  date: datetime.today(),
  collaborators: (),
)

= 3-Input `AND` and `OR` Gates

== Verilog Code

Below is the verilog code for the 3-input `AND` and `OR` gates.

#let code = read("asg1/q1.v");

#grid(
  columns: 2,
  verilogcode(code, 2, 8, caption: "3-input AND gate"),
  verilogcode(code, 12, 8, caption: "3-input OR gate"),
)

== Testbench

Below is the verilog testbench code and the result of the simulation
for the 3-input `AND` and `OR` gates.

#grid(
  columns: 2,
  verilogcode(code, 24, 19),
  // To fill the block al the way to the bottom, we add some newlines
  verilogcode(code + "\n" * 10, 43, 20),
)