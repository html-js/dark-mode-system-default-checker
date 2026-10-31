# Changelog

This file records what changed in each release. It follows the
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) style, and version
numbers follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-10-31

First public release. The checker ships as a single dependency-free page
that reports whether the browser asks websites for light or dark mode and
which layer of the setup made that choice.

It reads the color-scheme preference along with contrast, forced colors,
inversion and related media features, and updates live when any of them
change. CSS system colors are resolved for each color scheme. A pair of
test frames reveals automatic force-dark modes by eye, and page restyling by
add-ons is flagged. The full reading can be copied as JSON.

Product names were removed from the interface text in favor of generic
descriptions, and the browser identity is now shown exactly as the browser
reports itself.

[0.1.0]: https://github.com/html-js/dark-mode-system-default-checker/releases/tag/v0.1.0
