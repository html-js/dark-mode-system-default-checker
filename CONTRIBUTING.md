# Contributing

Thanks for helping improve the Dark Mode System Default Checker.

The whole tool is one file, `index.html`. Styles and script live inline,
and there is nothing to install or build. To try a change, open the file in
a browser, or run `make serve` and visit the local address it prints.

The most useful reports describe a real setup where the checker said
something surprising. Tell us which appearance setting you chose in the
operating system and in the browser, what the verdict said, and how the two
self-test frames looked. The issue form asks for exactly that. If you attach
the JSON report from the header button, edit out anything you would rather
keep private first, since it includes your user-agent string.

When changing the page, keep it dependency-free and keep every reading
local: the page must never send data anywhere. Wording in the interface and
the docs stays generic, so please describe browsers and operating systems by
behavior instead of by product name. Keep code, comments and documentation
in English.

If your change affects what the page looks like, regenerate the README
images with `make shots`. The figure sources sit in `docs/figures/`, and
`make figures` rebuilds their images.

Please follow the [Code of Conduct](./CODE_OF_CONDUCT.md) in all project
spaces.
