
#let lines(text, n, len) = {
  // Split the string into lines
  let lines = text.split("\n")

  // Slice from n to m (inclusive), with bounds checking for end
  let sliced = lines.slice(n - 1, calc.min(n + len, lines.len()) - 1)

  // Join them back
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
    pad(top: -.5em,
      align(
        caption,
        center
      )
    )
  }
}