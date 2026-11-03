#import "@preview/theorion:0.6.0": *
#import cosmos.simple: *
#import "@preview/fletcher:0.5.8" as fletcher
#import "template.typ" as base-template

#let theorem = theorem.with(numbering: none)
#let corollary = corollary.with(numbering: none)
#let property = property.with(numbering: none)
#let definition = definition.with(numbering: none)
#let example = example.with(numbering: none)
#let problem = problem.with(numbering: none)
#let theorion-theme(body) = show-theorion({
  let kinds = (
    "theorem", "lemma", "corollary", "axiom", "postulate",
    "definition", "proposition", "assumption", "property",
    "conjecture", "remark", "note", "example", "exercise", "problem",
  )
  let target = figure.where(kind: kinds.first())
  for kind in kinds.slice(1) {
    target = target.or(figure.where(kind: kind))
  }
  // Keep the simple theme's titles and references; mark each statement's extent.
  show target: it => block(
    width: 100%,
    breakable: true,
    inset: (y: 2pt),
    above: 0pt,
    below: 0pt,
    block(
      width: 100%,
      breakable: true,
      stroke: (left: 0.5pt + luma(110)),
      inset: (left: 4pt, y: 1pt),
      above: 0pt,
      below: 0pt,
      it.body,
    ),
  )
  body
})

#let diagram = fletcher.diagram
#let node = fletcher.node
#let edge = fletcher.edge

#let codebook = base-template.codebook
#let code-file = base-template.code-file
#let note-box = base-template.note-box

#let stl1(n, k) = math.vec(
  n, k,
  delim: "[",
  gap: 0.1em,
)

#let stl2(n, k) = math.vec(
  n, k,
  delim: "{",
  gap: 0.1em,
)

#let ps(body) = block(
  width: 100%,
  inset: (x: 10pt, y: 8pt),
  fill: rgb("#f3f6fa"),
  stroke: (
    left: 2pt + rgb("#578989"),
  ),
  radius: 2pt,
)[
  *PS: * #body
]

#let code-info(api, complexity) = block(
  width: 100%,
  inset: (left: 2pt),
  above: 0pt,
  below: 1pt,
  stroke: (left: 0.5pt + luma(150)),
)[
  #set text(size: 6.5pt)
  *接口:* #api \
  *复杂度:* #complexity
]
