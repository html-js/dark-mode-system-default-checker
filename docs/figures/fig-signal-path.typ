// Signal path, crystalline (prism) style: the system preference is a white
// beam, the browser is a glass prism that splits it into the signals a page
// can read, and repainting by auto-dark, add-ons or filters arrives along a
// dashed path the page cannot measure.
#let W = 184mm
#let H = 96mm

#let night = rgb("#07080d")
#let fg    = rgb("#e9edf5")
#let mute  = rgb("#8a93a6")
#let glass = rgb("#9fd8ff")
#let amber = rgb("#ffb454")

#set page(width: W, height: H, margin: 0mm, fill: night)
#set text(font: "Ubuntu", weight: 300, size: 7pt, fill: fg)

#let at(x, y, body) = place(top + left, dx: x, dy: y, body)
#let centered(x, y, w, body) = at(x - w / 2, y, block(width: w, align(center, body)))
#let caps(s, size: 5pt, fill: mute) = text(size: size, weight: 500, tracking: 0.24em, fill: fill, upper(s))
#let seg(a, b, s) = at(0mm, 0mm, line(start: a, end: b, stroke: s))

// Line with a soft glow: wide faint strokes under a crisp core.
#let glow(a, b, c, w: 0.7pt) = {
  for (k, t) in ((5, 92%), (3, 84%), (1.8, 65%)) {
    seg(a, b, (paint: c.transparentize(t), thickness: w * k, cap: "round"))
  }
  seg(a, b, (paint: c, thickness: w, cap: "round"))
}

// ── prism (the browser) ──────────────────────────────────────────────────
#let apex = (92mm, 20mm)
#let bl = (73mm, 56mm)
#let br = (111mm, 56mm)
#at(0mm, 0mm, polygon(apex, bl, br, stroke: 0.8pt + glass.transparentize(10%),
  fill: gradient.linear(glass.transparentize(80%), glass.transparentize(94%), angle: 70deg)))
#seg(apex, (92mm, 56mm), 0.3pt + glass.transparentize(65%))
#seg((92mm, 44mm), bl, 0.3pt + glass.transparentize(75%))
#seg((92mm, 44mm), br, 0.3pt + glass.transparentize(75%))

// ── beam in: the one system preference ───────────────────────────────────
#let src = (40mm, 40mm)
#let entry = (82.5mm, 40mm)
#let exit = (102.2mm, 42mm)
#glow(src, entry, white, w: 0.9pt)
#seg(entry, exit, 0.6pt + white.transparentize(55%))
#at(src.at(0) - 2.4mm, src.at(1) - 2.4mm, circle(radius: 2.4mm, fill: white, stroke: 2pt + white.transparentize(75%)))

// ── spectrum out: seven readable signals ─────────────────────────────────
#let spectrum = ("#ff4d4d", "#ff9f40", "#ffe14d", "#5ce07a", "#4dc3ff", "#5b6cff", "#b067ff").map(rgb)
#for (i, c) in spectrum.enumerate() {
  glow(exit, (140mm, 29mm + i * 3.8mm), c, w: 0.6pt)
}

// ── the page ─────────────────────────────────────────────────────────────
#at(140mm, 25mm, rect(width: 34mm, height: 31mm, radius: 1.4mm,
  fill: white.transparentize(94%), stroke: 0.7pt + fg.transparentize(30%), inset: 3mm)[
  #set par(leading: 0.55em)
  #caps(size: 4.6pt)[03 · page] \
  #text(size: 10.5pt, weight: 500)[Page] \
  #text(size: 5.4pt, fill: mute)[what this checker reads]
  #v(1mm)
  #text(size: 6pt)[Sees only what the browser exposes. A repainted page still reports its own colors.]
])

// ── the system ───────────────────────────────────────────────────────────
#at(10mm, 30mm, block(width: 27mm)[
  #set par(leading: 0.55em)
  #caps(size: 4.6pt)[01 · source] \
  #text(size: 10.5pt, weight: 500)[System] \
  #text(size: 5.4pt, fill: mute)[OS appearance setting]
  #v(1mm)
  #text(size: 6pt)[Light or dark, or switched by time of day.]
])

// ── labels on the light ──────────────────────────────────────────────────
#centered(61mm, 33.4mm, 34mm, caps(size: 4.4pt, fill: fg)[preference])
#centered(118mm, 16.5mm, 46mm)[#caps(size: 4.6pt, fill: rgb("#ffe14d"))[readable] \ #text(size: 5.4pt, fill: mute)[color scheme · contrast · forced colors · inversion \ transparency · motion · system colors]]

#centered(92mm, 58.4mm, 52mm)[
  #set par(leading: 0.55em)
  #caps(size: 4.6pt)[02 · prism] \
  #text(size: 10.5pt, weight: 500, fill: glass)[Browser] \
  #text(size: 5.6pt, fill: mute)[passes the system choice on, or replaces it with its own theme setting]
]

// ── painted-over path: invisible to scripts ──────────────────────────────
#let paint = (paint: amber.transparentize(15%), thickness: 0.6pt, dash: (2pt, 2pt))
#seg((40mm, 76mm), (157mm, 76mm), paint)
#seg((157mm, 76mm), (157mm, 58.6mm), paint)
#at(0mm, 0mm, polygon(fill: amber, stroke: none, (157mm, 56.8mm), (156mm, 59mm), (158mm, 59mm)))
#at(40mm - 1.6mm, 76mm - 1.6mm, rotate(45deg, rect(width: 3.2mm, height: 3.2mm, fill: night, stroke: 0.7pt + amber)))
#centered(98mm, 79.6mm, 110mm, text(size: 5.6pt, fill: mute)[
  #caps(size: 4.6pt, fill: amber)[painted over] #h(1.6mm) auto-dark · extensions · filters repaint the page without telling it])

// ── heading + footer ─────────────────────────────────────────────────────
#at(10mm, 9mm, caps[Figure 1 · signal path])
#at(10mm, 14mm, text(size: 15pt)[Where a page learns #text(fill: mute)[light or dark]])
#at(10mm, 87mm, text(size: 5.8pt, fill: mute)[The spectrum can be measured from a script. The dashed path can only be seen, which is why the checker includes a visual self-test.])
