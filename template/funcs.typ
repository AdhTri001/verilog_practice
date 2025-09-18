/**
 * Helper functions for the assignment solution documents.
 */

#let codecaption(text) = {
  pad(top: -.5em,
    align(
      text,
      center
    )
  )
}

#let lines(text, n, len) = {
  // Split the string into lines
  let lines = text.split("\n")

  if lines.len() <= n {
    return ""
  }

  // Slice from n to m (inclusive), with bounds checking for end
  let sliced = lines.slice(n - 1, calc.min(n + len, lines.len()) - 1)

  sliced.join("\n")
}

#let verilogcode(text, n, m, caption: none) = {
  let snippet = lines(text, n, m)

  raw(
    snippet,
    lang: "verilog",
    block: true,
  )
  if caption != none {
    codecaption(caption)
  }
}

#let termimg_generic(asgno, quesno) = {
  return str(asgno + "/imgs/" + quesno + "_terminal.png")
}

#let plotimg_generic(asgno, quesno) = {
  return str(asgno + "/imgs/" + quesno + "_waveform.png")
}