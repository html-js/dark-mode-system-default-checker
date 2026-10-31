// Reading the forced-dark self-test, crystalline (prism) style: three glass
// cards, one per outcome. Frame A declares no color-scheme, frame B declares
// "only light". Same palette as fig-signal-path.typ.
#let W = 184mm
#let H = 96mm

#let night = rgb("#07080d")
#let fg    = rgb("#e9edf5")
#let mute  = rgb("#8a93a6")
#let glass = rgb("#9fd8ff")
#let ink   = rgb("#1a1d26")

#set page(width: W, height: H, margin: 0mm, fill: night)
#set text(font: "Ubuntu", weight: 300, size: 7pt, fill: fg)

#let at(x, y, body) = place(top + left, dx: x, dy: y, body)
#let caps(s, size: 5pt, fill: mute) = text(size: size, weight: 500, tracking: 0.24em, fill: fill, upper(s))
#let seg(a, b, s) = at(0mm, 0mm, line(start: a, end: b, stroke: s))

#let glow(a, b, c, w: 0.7pt) = {
  for (k, t) in ((5, 92%), (3, 84%), (1.8, 65%)) {
    seg(a, b, (paint: c.transparentize(t), thickness: w * k, cap: "round"))
  }
  seg(a, b, (paint: c, thickness: w, cap: "round"))
}

// one miniature test frame
#let frame(x, y, dark, tag) = {
  at(x, y, rect(width: 19mm, height: 12mm, radius: 1mm,
    fill: if dark { ink } else { white },
    stroke: 0.6pt + glass.transparentize(35%)))
  at(x, y + 13.4mm, block(width: 19mm, align(center, caps(size: 4pt)[#tag])))
}

#let CW = 52mm
#let CY = 26mm
#let card(x, n, c, title, a-dark, b-dark, body) = {
  at(x, CY, rect(width: CW, height: 54mm, radius: 1.4mm,
    fill: white.transparentize(95%), stroke: 0.6pt + fg.transparentize(55%)))
  glow((x + 4mm, CY), (x + CW - 4mm, CY), c, w: 0.7pt)
  at(x + 4mm, CY + 4mm, block(width: CW - 8mm)[
    #set par(leading: 0.55em)
    #caps(size: 4.6pt, fill: c)[#n · outcome] \
    #text(size: 10.5pt, weight: 500)[#title]
  ])
  frame(x + 5mm, CY + 17mm, a-dark, "A · none")
  frame(x + 28mm, CY + 17mm, b-dark, "B · only light")
  at(x + 4mm, CY + 37mm, block(width: CW - 8mm, text(size: 6pt)[#body]))
}

#card(10mm, "01", rgb("#5ce07a"), "Both white", false, false,
  [No forced darkening. What a page declares is what you see.])
#card(66mm, "02", rgb("#4dc3ff"), "Only A dark", true, false,
  [The browser darkens pages that do not opt out. Its auto-dark mode is on.])
#card(122mm, "03", rgb("#b067ff"), "Both dark", true, true,
  [Something below the page repaints everything, usually an extension or system color inversion.])

// ── heading + footer ─────────────────────────────────────────────────────
#at(10mm, 9mm, caps[Figure 2 · visual self-test])
#at(10mm, 14mm, text(size: 15pt)[Forced dark frames #text(fill: mute)[read by eye]])
#at(10mm, 87mm, text(size: 5.8pt, fill: mute)[Both frames paint a plain white box. Scripts cannot read repainted pixels, so this check is done by looking.])
