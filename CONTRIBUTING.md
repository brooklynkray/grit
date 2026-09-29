# Contributing to Grit

Thanks for taking an interest. Grit is meant to be filled with lines that
actually move people, so good contributions are welcome.

## The voice

Every line should be firm, honest and real. It should make someone think
"yeah, fair one", never make them wince. No fortune-cookie nonsense, no
hollow "you've got this". If in doubt, read the existing lines.

The **Eat well** category is deliberately about nourishment and balance,
never restriction or punishment. Keep that spirit.

## Adding built-in lines

1. Edit `data/lines.json`, the human-readable master.
2. Regenerate `Model.js` to match (the QML imports `Model.js`, not the JSON).
3. Keep the two in sync: a line in one must be in the other.

## Development

- Deploy loop: copy the changed file into
  `~/.config/omarchy/plugins/brooklynkray.grit/`, then run
  `omarchy-restart-shell` (the shell caches plugin code until a restart).
- Validate the manifest with `omarchy plugin validate .`.
- Lint QML changes with `qmllint`.

## Pull requests

- One change per branch, named `feat/...`, `fix/...` or `docs/...`.
- Small, focused commits with clear messages.
- Say what you changed and how you tested it.
