#import "template/pset.typ": pset
#import "template/funcs.typ": verilogcode, codecaption

#show: pset.with(
	class: "ECS 409: Computer Organization",
	title: "Assignment 3",
	student: "Adheesh Trivedi",
	date: datetime.today(),
	collaborators: (),
)

#let termimg(quesno) = {
	align(center, image("Asg3/imgs/" + quesno + "_terminal.png", width: 80%))
}
#let plotimg(quesno) = {
	align(center, image("Asg3/imgs/" + quesno + "_waveform.png"))
}

= SR Latch with Enable & Reset

Simple SR latch with async enable and reset; holds state when En=0, reset dominates.

#verilogcode(read("Asg3/q1.v"), 1, 200, caption: "SR latch with En & Rst")

== Simulation Output

Q resets when Rst=1 regardless of inputs; when enabled, S=1 sets and R=1 resets.
Transitions match table in outputs (stable hold when En=0; no illegal set when R=1).

#termimg("q1")
#plotimg("q1")

= Improved D Latch with Gate Delays

Behavioral D latch with 1 ns gate delays; shows correct level-sensitive behavior.

#verilogcode(read("Asg3/q2.v"), 1, 200, caption: "Improved D latch (1ns delays)")

== Simulation Output

Q follows D only while CLK=1 after 1 ns delay; holds value when CLK=0.
Edges and printed times (e.g., 10k, 30k ps) match expected delayed response.

#termimg("q2")
#plotimg("q2")

= 3-bit Down Counter (7 to 0)

Counts 7→0 and repeats; synchronous reset initializes to 000.

#verilogcode(read("Asg3/q3.v"), 1, 200, caption: "Mod-8 down counter")

== Simulation Output

Sequence shows 111→110→…→000 then wrap; Rst forces 000 then counts down again.
Printed log confirms two full cycles and final wrap as in outputs.txt.

#termimg("q3")
#plotimg("q3")

= Mod-8 Gray Code Counter with UP

Gray code transitions change one bit per step; UP selects advance or hold.

#verilogcode(read("Asg3/q4.v"), 1, 200, caption: "UP/DOWN Gray code counter")

== Simulation Output

Logs show single-bit changes and holds when UP=0; wrap-around behavior verified.
Waveform matches printed sequence (e.g., 000→001→011→010→110…).

#termimg("q4")
#plotimg("q4")

= Parameterized N-bit Bidirectional Shift Register

Shift left/right under DIR with enable; parameter N configures width.

#verilogcode(read("Asg3/q5.v"), 1, 200, caption: "Parametric bidirectional shifter")

== Simulation Output

Output shifts as DIR changes and En toggles; patterns match table in log.
Reset deassert then enable drives series of shifts, mirroring outputs.txt.

#plotimg("q5")
#termimg("q5")

= 128×16 Single-Port Memory

Synchronous write on WE; combinational read returns stored data.

#verilogcode(read("Asg3/q6.v"), 1, 200, caption: "Single-port RAM 128×16")

== Simulation Output

Writes at addresses 3,5,127,8,9 then reads back matching data (abcd,1234,dead,beef,cafe).
Printed time-stamped table confirms correct read-after-write and later reads.

#plotimg("q6")
#termimg("q6")
