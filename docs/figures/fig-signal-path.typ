// Signal path: where a web page learns "light" or "dark".
// Crystalline style: pale faceted low-poly field, three cut gems
// (amethyst = system, sapphire = browser, emerald = page).
#let W = 184mm
#let H = 100mm

#let navy = rgb("#13294b")
#let mute = rgb("#4f6687")
#let amethyst = rgb("#8b5cf6")
#let sapphire = rgb("#2563eb")
#let emerald  = rgb("#10b981")
#let amber    = rgb("#d97706")

#set page(width: W, height: H, margin: 0mm, fill: rgb("#e6f1fa"))
#set text(font: "Ubuntu", size: 7pt, fill: navy)

#let at(x, y, body) = place(top + left, dx: x, dy: y, body)
#let centered(x, y, w, body) = at(x - w / 2, y, block(width: w, align(center, body)))
#let caps(s, size: 5pt, fill: mute) = text(size: size, weight: 500, tracking: 0.22em, fill: fill, upper(s))
#let rnd(i) = calc.fract(calc.sin(i * 12.9898) * 43758.5453)

// ── faceted field ────────────────────────────────────────────────────────
#let ice = gradient.linear(rgb("#f4f9fe"), rgb("#d6e8f6"), rgb("#bcd8f0"), angle: 20deg)
#let cols = 13
#let rows = 8
#let pt(c, r) = {
  let j = if c == 0 or c == cols or r == 0 or r == rows { 0 } else { 1 }
  (c * W / cols + j * (rnd(c * 31 + r * 7) - 0.5) * 9mm,
   r * H / rows + j * (rnd(c * 17 + r * 53) - 0.5) * 8mm)
}
#for c in range(cols) {
  for r in range(rows) {
    let (a, b, cc, d) = (pt(c, r), pt(c + 1, r), pt(c + 1, r + 1), pt(c, r + 1))
    for (k, tri) in ((a, b, cc), (a, cc, d)).enumerate() {
      let t = (c + r * 0.6) / (cols + rows * 0.6)
      let shade = ice.sample(t * 100%).darken(rnd(c * 97 + r * 13 + k * 5) * 7%)
      at(0mm, 0mm, polygon(fill: shade, stroke: 0.3pt + white.transparentize(30%), ..tri))
    }
  }
}

// ── gems ─────────────────────────────────────────────────────────────────
#let gem(cx, cy, R, c) = {
  let v(a, r) = (cx + r * calc.cos(a), cy + r * calc.sin(a))
  let shades = (0%, 28%, 50%, 18%, 38%, 8%)
  for k in range(6) {
    let a0 = -90deg + k * 60deg
    let a1 = a0 + 60deg
    at(0mm, 0mm, polygon(fill: c.lighten(shades.at(k)), stroke: 0.4pt + white,
      v(a0, R), v(a1, R), v(a1, R * 0.5), v(a0, R * 0.5)))
  }
  at(0mm, 0mm, polygon(fill: c.lighten(62%), stroke: 0.4pt + white,
    ..range(6).map(k => v(-90deg + k * 60deg, R * 0.5))))
}

#let GY = 44mm
#let R = 12mm
#let X = (36mm, 96mm, 150mm)
#gem(X.at(0), GY, R, amethyst)
#gem(X.at(1), GY, R, sapphire)
#gem(X.at(2), GY, R, emerald)

// ── flows ────────────────────────────────────────────────────────────────
#let hw = R * 0.866
#let tri(x, y, dir, c) = at(0mm, 0mm, polygon(fill: c, stroke: none,
  (x, y), (x - dir * 2mm, y - 1mm), (x - dir * 2mm, y + 1mm)))
#let flow(x0, x1, y, dir, c) = {
  at(0mm, 0mm, line(start: (x0, y), end: (x1, y), stroke: 0.9pt + c))
  tri(if dir > 0 { x1 } else { x0 }, y, dir, c)
}

// system -> browser
#flow(X.at(0) + hw + 2mm, X.at(1) - hw - 2mm, GY, 1, amethyst.darken(10%))
#centered((X.at(0) + X.at(1)) / 2, GY - 9.6mm, 40mm)[#caps(size: 4.6pt, fill: amethyst.darken(10%))[forwards] \ #text(size: 5.4pt, fill: mute)[appearance · contrast · inversion]]

// browser -> page (what scripts and CSS can read)
#let m = (X.at(1) + X.at(2)) / 2
#flow(X.at(1) + hw + 2mm, X.at(2) - hw - 2mm, GY - 3.6mm, 1, sapphire)
#centered(m, GY - 12.4mm, 36mm)[#caps(size: 4.6pt, fill: sapphire)[readable] \ #text(size: 5.4pt, fill: mute)[media queries · system colors]]

// browser paints over the page (invisible to scripts)
#flow(X.at(1) + hw + 2mm, X.at(2) - hw - 2mm, GY + 3.6mm, 1, amber)
#centered(m, GY + 5.6mm, 36mm)[#text(size: 5.4pt, fill: mute)[auto-dark · extensions · filters] \ #caps(size: 4.6pt, fill: amber)[painted over]]

// ── labels ───────────────────────────────────────────────────────────────
#let label(x, name, sub, body) = centered(x, GY + R + 4mm, 48mm)[
  #set par(leading: 0.55em)
  #text(size: 11pt, weight: 700)[#name] \
  #caps(size: 4.6pt)[#sub]
  #v(1mm)
  #text(size: 6.4pt, fill: mute)[#body]
]
#label(X.at(0), "System", "os appearance setting")[Light, dark or automatic by time of day. Contrast themes and color inversion live here too.]
#label(X.at(1), "Browser", "may override")[Passes the system choice on, or replaces it with its own theme or website-appearance setting.]
#label(X.at(2), "Page", "what this checker reads")[Sees only what the browser exposes. A painted-over page still reports its own colors.]

// ── heading + footer ─────────────────────────────────────────────────────
#at(10mm, 9mm, caps(fill: sapphire)[Figure 1 · signal path])
#at(10mm, 14mm, text(size: 16pt, weight: 300)[Where a web page learns #text(weight: 700)[light or dark]])

#at(10mm, 90mm, block(width: W - 20mm, align(center, text(size: 6.2pt, fill: mute)[
  #text(weight: 700, fill: navy)[Why it matters:] the blue path can be measured from a script; the amber path can only be seen, which is why the checker includes a visual self-test.])))
