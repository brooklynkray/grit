# Grit: project status (2026-09-29)

Self-contained record of the Grit plugin, kept separate from In the Dark
(the cybersecurity recon tool). Different project, different repo.

## What it is

Grit: a no-nonsense motivation plugin for Omarchy. A bar widget you click,
and a panel shows one short, honest motivational line. Categories, add your
own, theme-aware. No cheese, that is the whole point.

## Decisions made today

- **Name:** Grit. British English for toughness and not giving up, which
  matches the push-through purpose.
- **Voice:** short, direct, a bit gruff, warm, never cheesy. The "Eat well"
  category stays about nourishment and balance, never restriction.
- **Content:** 112 lines across 8 categories, in data/lines.json.
- **Verbosity:** two modes named after the output, not the user. Guided
  (default, explanations on) and Concise (a `--concise` flag). A remembered
  preference is deferred until there is somewhere local to store it.
- **Chosen over:** a nightstand clock (already exists, omarchy-standby) and a
  security posture widget (a real open gap and my field, but a vitamin not a
  painkiller for daily use). Motivation won: warm, shareable, a genuine gap,
  and I would use it myself.
- **Plugin shape:** bar-widget plus panel. Distributed as a public git repo,
  listed on plugins.omarchy.org.

## Done (off-machine)

- Repo scaffold: README, LICENSE (MIT), .gitignore, manifest.json.
- Content: 112 lines, 8 categories (data/lines.json).
- Design: a clickable HTML prototype at design/prototype.html. This is the
  visual target the QML gets built to match.
- Docs: this file and BUILD_NOTES.md.

## Next (on-machine)

1. `omarchy plugin list`, then clone a built-in bar-widget as a scaffold.
2. Build the QML to match the prototype, in the steps in BUILD_NOTES.md.
3. Capture a GIF, push to GitHub (repo: grit), tag v0.1.0, submit to the
   marketplace.
4. Launch post (r/omarchy and the Omarchy community).

## Files

- manifest.json        plugin manifest (brooklynkray.grit)
- BarWidget.qml        DRAFT, untested, reconcile against a cloned built-in
- Panel.qml            DRAFT, untested, same
- data/lines.json      112 lines, 8 categories
- design/prototype.html  the visual target (open in a browser)
- README.md            marketplace-ready
- LICENSE              MIT
- BUILD_NOTES.md       build plan and conventions
- STATUS.md            this file
