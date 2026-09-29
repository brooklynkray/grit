# Grit build notes (working doc, not shipped)

Notes for building Grit on the Omarchy machine. Delete or keep out of the
release. This captures what's decided and what to do next, so a fresh session
or a later you can pick up without re-deriving it.

## Status

- Content, README, LICENSE, .gitignore, manifest.json: done, prepared off-machine.
- QML (BarWidget.qml, Panel.qml): FIRST DRAFTS ONLY, written from the published
  developer spec and NOT run. Treat them as a starting point, not working code.
  The exact Quickshell imports, panel anchoring and lifecycle conventions must
  be checked against a real built-in plugin.

## First thing to do on the machine

Do NOT trust the draft QML blindly. Start from a known-good built-in:

```bash
omarchy plugin list
omarchy plugin clone <a built-in bar-widget id, e.g. a clock or status widget>
```

Compare the cloned plugin's BarWidget.qml / Panel.qml against the drafts here,
and fix the imports and conventions to match what actually works. Then:

```bash
omarchy plugin validate ./     # from the grit folder
qmllint -I "$OMARCHY_PATH/shell" BarWidget.qml Panel.qml
```

## v1 build order (small, testable steps)

1. Bar button appears and opens a panel that shows ONE random line from
   data/lines.json. Whole skeleton working end to end. Ship-able.
2. Category switch + a "give me another" button, with no-immediate-repeat
   (don't show the same line twice running).
3. "Add your own": a text field that appends to custom.json in the plugin's
   user config dir. This is the killer feature and the meatiest bit, so it
   comes after the skeleton is solid.
4. Theme-aware polish so it matches the user's Omarchy colours.

## Data model

- Built-in lines: data/lines.json (shipped with the plugin).
- User lines: custom.json in the plugin's user config dir. Gitignored. Never
  committed, never leaves the machine, survives plugin updates.
- Merge at load: built-in + custom for the active category.

lines.json shape:

```json
{
  "schemaVersion": 1,
  "categories": [
    { "id": "grind", "name": "Deep work", "lines": ["...", "..."] }
  ]
}
```

custom.json should use the same shape so the merge is trivial.

## Line selection

Pick a random line from the active category, but never repeat the line shown
immediately before. Keep the last-shown id in memory and re-roll if it matches.

## Voice rules (protect these)

Short, direct, a bit gruff, honest. A mate in your corner, not a poster.
No cheese. "Eat well" stays about nourishment and balance, never restriction.

## Later (post-v1)

- Selectable visual skins.
- Optional scheduled nudge (off by default).
- Share a line as an image.
- MIT release + tag v0.1.0, then submit to plugins.omarchy.org.
