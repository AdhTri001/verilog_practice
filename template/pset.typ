/**
 * Taken from PSET template
 * https://github.com/carreter/problemst
 *
 * MIT License
 *
 * Copyright (c) 2024 Willow Carretero Chavez
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#let pset(
  class: "6.100",
  title: "PSET 0",
  student: "Alyssa P. Hacker",
  date: datetime.today(),
  subproblems: "1.1.a.i",
  collaborators: (),
  doc,
) = {
  [
    /* Convert collaborators to a string if necessary */
    #let collaborators = if type(collaborators) == array { collaborators.join(", ") } else { collaborators }

    /* Problem + subproblem headings */
    #set heading(
      numbering: (..nums) => {
        nums = nums.pos()
        if nums.len() == 1 {
          [Problem #nums.at(0):]
        } else {
          numbering(subproblems, ..nums)
        }
      },
    )
    #show heading: it => {
      if (counter(heading).get().first() > 1 and counter(heading).get().len() == 1) {
        pagebreak();
      }
      it
    }

    /* Set metadata */
    #set document(title: [#class - #title], author: student, date: date)

    /* Set up page numbering and continued page headers */
    #set page(
      numbering: "1",
      header: context {
        if counter(page).get().first() > 1 [
          #set text(style: "italic")
          #class -- #title
          #h(1fr)
          #student
          #if collaborators != none { [w/ #collaborators] }
          #block(line(length: 100%, stroke: 0.5pt), above: 0.6em)
        ]
      },
      margin: .5in
    )

    /* Add numbering and some color to code blocks */
    #show raw.where(block: true): it => {
      block(width: 100% - 0.5em, radius: 0.3em, stroke: luma(50%), inset: 1em, fill: luma(98%))[
        // Comented the numbering
        // #show raw.line: l => context {
        //   box(width: measure([#it.lines.last().count]).width, align(right, text(fill: luma(50%))[#l.number]))
        //   h(0.5em)
        //   l.body
        // }
        #it
      ]
    }

    /* Make the title */
    #align(
      center,
      {
        text(size: 1.6em, weight: "bold")[#class -- #title \ ]
        text(size: 1.2em, weight: "semibold")[#student \ ]
        emph[
          #date.display("[year]-[month]-[day]")
          #if collaborators != none {
            [
              \ Collaborators: #collaborators
            ]
          }
        ]
        box(line(length: 100%, stroke: 1pt))
      },
    )

    #doc
  ]
}