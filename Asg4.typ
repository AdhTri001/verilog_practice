#import "template/pset.typ": pset
#import "template/funcs.typ": verilogcode, codecaption

#show: pset.with(
	class: "ECS 409: Computer Organization",
	title: "Assignment 4",
	student: "Adheesh Trivedi",
	date: datetime.today(),
	collaborators: (),
)

#let termimg(quesno) = {
	align(center, image("Asg4/imgs/" + quesno + "_terminal.png", width: 80%))
}
#let plotimg(quesno) = {
	align(center, image("Asg4/imgs/" + quesno + "_waveform.png", width: 90%))
}

= Moore FSM

Moore state machine per spec; output depends only on state, reset returns to initial.

#verilogcode(read("Asg4/q1.v"), 1, 200, caption: "Moore FSM Implementation")

== Simulation Output

Output Q asserted only after required state sequence; reset clears immediately.
Trace matches transitions in terminal log (see consistent Q after stable inputs).

#termimg("q1")
#plotimg("q1")

= Mealy FSM

Mealy machine: output reacts instantly to input changes plus current state.

#verilogcode(read("Asg4/q2.v"), 1, 200, caption: "Mealy FSM Implementation")

== Simulation Output

Q pulses earlier vs Moore (input-driven), immediate response visible pre-state settle.
Reset cycles force Q low; matches log timing stamps and waveform edges.

#termimg("q2")
#plotimg("q2")

= 1101 Sequence Detector

Detects overlapping 1101 patterns; emits 1-cycle Z pulse on detection.

#verilogcode(read("Asg4/q3.v"), 1, 220, caption: "1101 Overlap Detector")

== Simulation Output

Z asserted exactly when last bit completes 1101; overlapping occurrences retained.
Reset returns to S0; intermediate misses show proper partial-state progression.

#termimg("q3")
#plotimg("q3")

= Modular Equation FSM (2N(PA)+N(PB)≡1 mod4)

Counts PA (weight2) + PB (weight1) modulo 4, asserts O on residue 1.

#verilogcode(read("Asg4/q4.v"), 1, 260, caption: "Mod-4 Weighted Counter FSM")

== Simulation Output

O high exactly when (2N(PA)+N(PB)) mod4 =1; other cycles low; reset clears counts.
State/output pattern in log aligns with theoretical residue progression.

#termimg("q4")
#plotimg("q4")
