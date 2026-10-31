// Reading the forced-dark self-test: frame A declares no color-scheme,
// frame B declares "only light". Three outcomes, three cut gems.
// Crystalline style, same palette as fig-signal-path.typ.
#let W = 184mm
#let H = 100mm

#let navy = rgb("#13294b")
#let mute = rgb("#4f6687")
#let amethyst = rgb("#8b5cf6")
#let sapphire = rgb("#2563eb")
#let emerald  = rgb("#10b981")
#let ink      = rgb("#0f1115")

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
  (c * W / cols + j * (rnd(c * 23 + r * 11) - 0.5) * 9mm,
   r * H / rows + j * (rnd(c * 41 + r * 29) - 0.5) * 8mm)
}
#for c in range(cols) {
  for r in range(rows) {
    let (a, b, cc, d) = (pt(c, r), pt(c + 1, r), pt(c + 1, r + 1), pt(c, r + 1))
    for (k, tri) in ((a, b, cc), (a, cc, d)).enumerate() {
      let t = (c + r * 0.6) / (cols + rows * 0.6)
      let shade = ice.sample(t * 100%).darken(rnd(c * 89 + r * 19 + k * 3) * 7%)
      at(0mm, 0mm, polygon(fill: shade, stroke: 0.3pt + white.transparentize(30%), ..tri))
    }
  }
}

// ── small gem (marker for each outcome) ─────────────────────────────────
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

// ── a pair of miniature frames: A (no color-scheme) and B (only light) ──
#let frame(x, y, dark, tag) = {
  at(x, y, rect(width: 17mm, height: 11mm, radius: 1.2mm,
    fill: if dark { ink } else { white },
    stroke: 0.5pt + mute.lighten(30%)))
  at(x, y + 12.2mm, block(width: 17mm, align(center, caps(size: 4.2pt)[#tag])))
}
#let pair(cx, y, a-dark, b-dark) = {
  frame(cx - 19mm, y, a-dark, "A · none")
  frame(cx + 2mm, y, b-dark, "B · only light")
}

#let X = (36mm, 92mm, 148mm)
#let FY = 30mm
#let GY = 62mm

#pair(X.at(0), FY, false, false)
#pair(X.at(1), FY, true, false)
#pair(X.at(2), FY, true, true)

#gem(X.at(0), GY, 6.5mm, emerald)
#gem(X.at(1), GY, 6.5mm, sapphire)
#gem(X.at(2), GY, 6.5mm, amethyst)

#let label(x, name, body) = centered(x, GY + 9mm, 50mm)[
  #set par(leading: 0.55em)
  #text(size: 10pt, weight: 700)[#name] \
  #v(0.6mm)
  #text(size: 6.4pt, fill: mute)[#body]
]
#label(X.at(0), "Both white", [No forced darkening. What the page declares is what you see.])
#label(X.at(1), "Only A dark", [The browser darkens pages that do not opt out. Its auto-dark mode is on.])
#label(X.at(2), "Both dark", [Something below the page repaints everything: an extension, a filter or OS inversion.])

// ── heading + footer ─────────────────────────────────────────────────────
#at(10mm, 9mm, caps(fill: sapphire)[Figure 2 · visual self-test])
#at(10mm, 14mm, text(size: 16pt, weight: 300)[Reading the #text(weight: 700)[forced dark] frames])

#at(10mm, 91mm, block(width: W - 20mm, align(center, text(size: 6.2pt, fill: mute)[
  #text(weight: 700, fill: navy)[Note:] both frames paint a plain white box. Scripts cannot read the repainted pixels, so this check is done by eye.])))
