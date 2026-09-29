# Grit

A no-nonsense motivation plugin for Omarchy. Click it when you need a push, and it gives you one straight, honest line. No cheese, no fortune-cookie nonsense.

Grit lives in your bar. Press it and a small card appears with a line from whichever category you're in: getting stuck into deep work, showing up to train, eating well, or just getting through a rough day. The tone is a mate in your corner, not an inspirational poster.

## Why it exists

Most motivation apps sound like a greetings card. Grit doesn't. The lines are short, direct and a bit gruff, the sort of thing you'd actually say to yourself to get moving. And you can add your own, so over time it fills up with the words that work for you.

## Features

- One-click boost from your bar
- Categories: Deep work, Training, Eat well, Rough day
- Add your own lines, kept private and local to your machine
- Theme-aware, so it matches your Omarchy colours
- Never nags. It speaks when you ask it to

## Install

```bash
omarchy plugin add https://github.com/brooklynkray/grit --enable
```

Then add the Grit widget to your bar.

## Usage

Click the Grit button in the bar for a line. Click again for another. Switch category from the panel.

## Adding your own lines

Your custom lines are stored locally at:

```
~/.config/omarchy/plugins/brooklynkray.grit/custom.json
```

They stay on your machine and are never sent anywhere. A plugin update will not overwrite them, because they live in a separate file from the built-in lines.

## Categories

| Category | For |
|----------|-----|
| Deep work | Starting, focusing, finishing the thing |
| Training | Showing up to the gym even when you don't fancy it |
| Eat well | A healthy, kind relationship with food, no crash-diet nonsense |
| Rough day | A gentle push when you're running on empty |

## A note on the "Eat well" category

It is deliberately about nourishment and balance, not restriction or punishment. Motivation around food tips into unhealthy territory very easily, so Grit keeps it kind. Please keep that spirit if you add your own lines to it.

## Privacy

Grit does not connect to the internet, collect anything, or phone home. Everything, including your custom lines, stays on your machine.

## Contributing

Issues and pull requests welcome. If you're adding built-in lines, keep the voice: short, honest, direct, no cheese.

## Licence

MIT. See [LICENSE](LICENSE).
