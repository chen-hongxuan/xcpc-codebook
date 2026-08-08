#let code-line(it, highlights: ()) = {
  let number = box(
    width: 2.5em,
    align(right, text(size: 7pt, fill: luma(135), str(it.number))),
  )
  let separator = box(width: 0.4pt, height: 0.85em, fill: luma(185))
  let body = [#number#h(0.5em)#separator#h(0.75em)#it.body]

  if highlights.contains(it.number) {
    box(width: 100%, fill: rgb("e9fbfb"), body)
  } else {
    body
  }
}

#let code-file(path, lang: "cpp", highlights: ()) = {
  show raw.line: it => code-line(it, highlights: highlights)
  raw(read(path), lang: lang, block: true)
}

#let note-box(body) = block(
  width: 100%,
  breakable: true,
  stroke: 0.35pt + luma(145),
  inset: 7pt,
  above: 5pt,
  below: 8pt,
  radius: 2pt,
  body,
)

#let codebook(
  title: "XCPC Standard Code Library",
  short-title: "XCPC Codebook",
  school: "Your University",
  team: "Your Team",
  members: ("Member A", "Member B", "Member C"),
  updated: datetime.today().display("[year]-[month]-[day]"),
  body,
) = {
  set document(title: title, author: members)
  set text(
    font: (
      (name: "Libertinus Serif", covers: "latin-in-cjk"),
      "Noto Serif CJK SC",
    ),
    size: 10pt,
    lang: "zh",
  )
  set par(justify: true, leading: 0.5em, spacing: 4pt)
  set heading(numbering: "1.1")
  set raw(tab-size: 2)

  show heading.where(level: 1): set text(size: 20pt, weight: "bold")
  show heading.where(level: 2): set text(size: 14pt, weight: "bold")
  show heading.where(level: 3): set text(size: 11.2pt, weight: "bold")
  show raw: set text(
    font: "Maple Mono NF",
    size: 8.5pt,
  )
  show raw.where(block: true): block.with(
    width: 100%,
    breakable: true,
    stroke: 0.35pt + luma(145),
    inset: (x: 6pt, y: 4pt),
    above: 5pt,
    below: 9pt,
    radius: 2pt,
  )
  show raw.line: it => code-line(it)

  let running-header = context {
    stack(
      spacing: 1pt,
      [
        #set text(size: 8.3pt, fill: luma(45))
        #school
        #h(1fr)
        #short-title
        #h(1fr)
        Page #counter(page).display("1")
      ],
      line(length: 100%, stroke: 0.35pt + luma(45)),
    )
  }

  set page(
    paper: "a4",
    margin: (left: 18mm, right: 18mm, top: 17mm, bottom: 15mm),
    columns: 1,
    header-ascent: 35%,
    header: running-header,
  )

  page(
    paper: "a4",
    margin: 18mm,
    columns: 1,
    header: none,
    footer: none,
  )[
    #align(center)[
      #v(8mm)
      #text(size: 11pt, weight: "semibold")[#school]
      #v(20mm)
      #text(size: 28pt, weight: "bold")[#title]
      #v(5mm)
      #text(size: 12pt, fill: luma(80))[Printable Team Reference Document]
      #v(31mm)
      #rect(
        width: 112mm,
        height: 58mm,
        stroke: 0.8pt + luma(70),
        inset: 10mm,
      )[
        #align(left)[
          #text(size: 9pt, weight: "bold")[Team]\
          #text(size: 13pt)[#team]
          #v(6mm)
          #text(size: 9pt, weight: "bold")[Members]\
          #text(size: 10pt)[#members.join(" / ")]
        ]
      ]
      #v(1fr)
      #text(size: 7pt, fill: luma(100))[Last updated: #updated]
    ]
  ]

  counter(page).update(1)
  page(
    paper: "a4",
    margin: (left: 18mm, right: 18mm, top: 17mm, bottom: 15mm),
    columns: 1,
    header: none,
    footer: none,
  )[
    #set text(size: 9.5pt)
    #set par(leading: 0.4em)
    #heading(level: 1, numbering: none, outlined: false)[目录 / Contents]
    #outline(title: none, depth: 3, indent: 1em)
  ]

  counter(page).update(2)
  body
}
