#import "template/pset.typ": pset
#import "template/funcs.typ": verilogcode, codecaption

#show: pset.with(
  class: "ECS 409: Computer Organization",
  title: "Assignment 2",
  student: "Adheesh Trivedi",
  date: datetime.today(),
  collaborators: (),
)

#let asgno = "asg2";
#let termimg(quesno) = {
  align(center, image("Asg2/imgs/" + quesno + "_terminal.png", width: 80%))
}
#let plotimg(quesno) = {
  align(center, image("Asg2/imgs/" + quesno + "_waveform.png"))
}

= Multiply 4-bit by 2

Behavioral code multiplies input by 2 using shift.

#verilogcode(read("Asg2/q1.v"), 2, 200, caption: "4-bit x2 multiplier")
#termimg("q1")
#plotimg("q1")

= 4-to-2 Encoder & 2-to-4 Decoder

Encoder and decoder implemented behaviorally.

#verilogcode(read("Asg2/q2_enc.v"), 2, 200, caption: "4-to-2 Encoder")

#pagebreak()

#verilogcode(read("Asg2/q2_dec.v"), 2, 200, caption: "2-to-4 Decoder")

#plotimg("q2_enc")
#plotimg("q2_dec")

#termimg("q2_enc")
#termimg("q2_dec")

= 8-to-1 Multiplexer

Case statement selects one of 8 inputs.

#verilogcode(read("Asg2/q3.v"), 2, 200, caption: "8-to-1 MUX")
#termimg("q3")
#plotimg("q3")

= 8-to-3 Priority Encoder

If-else logic encodes highest active input.

#verilogcode(read("Asg2/q4.v"), 2, 200, caption: "8-to-3 Priority Encoder")
#termimg("q4")
#plotimg("q4")

= 4-bit Carry Look-Ahead Adder

Adder uses carry look-ahead logic for fast sum.

#verilogcode(read("Asg2/q5.v"), 2, 200, caption: "Carry Look-Ahead Adder")
#termimg("q5")
#plotimg("q5")

= 4-bit Wallace Tree Multiplier

Wallace tree structure for fast multiplication.

#verilogcode(read("Asg2/q6.v"), 2, 200, caption: "Wallace Tree Multiplier")
#plotimg("q6")
#termimg("q6")
