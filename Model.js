// Model.js  -  Grit content and selection logic.
//
// Pure JavaScript, no QML or Qt, so it can be reasoned about and unit-tested
// on its own (the same pattern the built-in clock plugin uses). The QML
// imports this as `Model`. Generated from data/lines.json; keep that file as
// the human-readable master and regenerate this if it changes.

var CATEGORIES = [
  {
    id: "grind",
    name: "Deep work",
    lines: [
      "You don't have to feel like it. You just have to start. Open the file.",
      "Ten minutes. That's the deal. Ten minutes then you can stop. You won't want to.",
      "Tired is a feeling, not a verdict. One more push.",
      "Future you inherits what you do in the next hour. Don't hand them your excuses.",
      "Done beats perfect. Ship the ugly version, fix it after.",
      "The hard part is the chair. You're already in it. Begin.",
      "You've done harder than this on worse days. Go.",
      "Nobody's coming to do it for you. That's not a threat, it's the point. It's yours.",
      "Close the tabs. You know which ones. Give the work your whole head.",
      "Motivation turns up after you start, not before. So start without it.",
      "One task. Not the list, the top of it. Just that.",
      "The thing you're avoiding is usually the thing that matters. Do that one first.",
      "Slow progress is still the door shutting behind everyone who quit.",
      "You don't need a better plan. You need the next line of it done.",
    ]
  },
  {
    id: "gym",
    name: "Training",
    lines: [
      "The session you skip is the one you'll replay tonight. Get in there.",
      "You don't need to want it. You need to get changed and walk in.",
      "Your body can. It's your head negotiating. Overrule it.",
      "Slow reps still built the strongest people you know. Start moving.",
      "Nobody strong got there on the days they felt like it. Today counts double.",
      "It's meant to be hard. That's the entire point. Stop waiting for easy.",
      "You're not too tired. You're not warmed up yet. Big difference.",
      "Discipline is remembering what you want at the exact moment you want to quit.",
      "Walk in unsure. Nobody ever got weaker doing that.",
      "The last rep is the one that changes you. The rest were the entry fee.",
      "Rest at the top of the hill. Never at the bottom.",
      "A bad session you finished beats the perfect one you skipped.",
      "Leave it all in here so it stops rattling round your head out there.",
      "This body carries you every day without asking. Return the favour.",
    ]
  },
  {
    id: "fuel",
    name: "Eat well",
    lines: [
      "Food is fuel, not the enemy. Put something good in.",
      "One solid meal is a win. You don't need a perfect week to start.",
      "Drink some water first. Half the time that was the whole problem.",
      "Fuel the body doing all this work for you. It's on your side, not against you.",
      "A good plate now beats a strict plan you'll ditch by Friday.",
      "You're allowed to enjoy it. That's balance, not failure.",
      "Look after the machine. You only get the one, and it's carrying everything.",
      "Small and steady wins this one. All-or-nothing loses it every time.",
      "Eat like you actually back yourself. That's the whole trick.",
      "Cook the thing. It's nearly always faster than the excuse not to.",
      "One good choice doesn't need a perfect day around it to count.",
      "Fuel the session, fuel the work. Your body isn't a battle to win.",
      "Hungry, tired or flat? Sort the food first, then decide anything else.",
      "Feeding yourself properly is discipline too. Don't skip it to look hard.",
    ]
  },
  {
    id: "reset",
    name: "Rough day",
    lines: [
      "I know you're knackered. Just do the next small thing. That's the whole job right now.",
      "Bad days end. You've got a 100% record of getting through them. Trust the record.",
      "You don't have to carry all of it right now. Just the next hour.",
      "Rest is allowed. Quitting on yourself isn't. Know the difference.",
      "Breathe. Shoulders down. You're further through this than it feels.",
      "Pick one thing and do it. Not the mountain, one thing. That's enough today.",
      "You've survived every worst day so far. The record stands. This is no different.",
      "Talk to yourself like you would a mate saying this to you. You'd never be this harsh.",
      "Lower the bar to getting through today. Still a real target, and you'll clear it.",
      "It's a hard day, not a hard life. Don't let the day tell you otherwise.",
      "Text someone. Carrying it alone isn't strength, it's just heavier.",
      "Nothing here that a proper night's sleep and a fresh start can't dent.",
      "Holding steady today is a win. Take it. Not every day is for advancing.",
      "If all you do is not give up, that counts. Bank it and go again tomorrow.",
    ]
  },
  {
    id: "morning",
    name: "Start the day",
    lines: [
      "Feet on the floor. Everything else is just momentum from there.",
      "Win the morning and the day stops arguing with you.",
      "Make the bed. First task done, and the day owes you nothing yet.",
      "You don't have to be ready. You have to be up. Up is the whole ask.",
      "Coffee, then move. Thinking about it is the slow way to nowhere.",
      "The day you want starts in the next ten minutes, not at some perfect later.",
      "Leave the phone. The day's yours before you hand it to everyone else.",
      "One glass of water, one clear plan. That's a strong open. Go.",
      "Yesterday's filed and gone. This one's clean paper. Don't waste the top of it.",
      "Hit the hardest thing while your head's fresh. It only gets heavier from here.",
      "Nobody feels sharp at this hour. Start moving, the feeling catches up.",
      "A small start beats no start. Pick the first thing up.",
      "Set today's one thing now, before the noise gets a vote.",
      "Up, moving, going. You can review how you feel at lunch.",
    ]
  },
  {
    id: "consistency",
    name: "Keep going",
    lines: [
      "You're not behind. You're in the boring middle where most people quit. Don't.",
      "The magic is showing up on the days you don't want to. Like today.",
      "Consistent beats intense. Turn up again.",
      "Nobody sees the reps. Everybody sees the result. Do the reps.",
      "You've come too far to only come this far.",
      "Boring and steady is how the impressive stuff gets built. No shortcut under it.",
      "Don't break the chain. One more day on the board.",
      "Small things, done daily, quietly become the thing you're proud of.",
      "Momentum is hard to build and easy to drop. Protect it. Do today's bit.",
      "The plan only works if you keep turning up to it. So turn up.",
      "You don't have to be fast. You have to refuse to stop.",
      "Every day you don't quit, you get harder to beat. Compounding is on your side.",
      "Discipline is choosing what you want most over what you want now.",
      "Keep stacking days. That's the whole secret. There isn't a better one.",
    ]
  },
  {
    id: "setback",
    name: "Setbacks",
    lines: [
      "It didn't work. That's data, not a verdict. Go again with better information.",
      "You're allowed a bad result. You're not allowed to stop there.",
      "Failed once isn't failed. It's the first draft of getting it right.",
      "Lick the wounds, then get up. They heal faster on the way up anyway.",
      "Everyone you admire has a stack of these behind them. Add yours and keep walking.",
      "The setback is the tuition. Learn what it charged you for.",
      "Down isn't out. Check the scoreboard, not the last play.",
      "You've been knocked back before and you're still standing here. Notice that.",
      "Fix what you can, bin what you can't, and move.",
      "It stung because you cared. Good. Care again tomorrow and go harder.",
      "The comeback reads better than the setback anyway. Go and write it.",
      "One bad chapter isn't the book. Keep turning the pages.",
      "Get specific about what went wrong, then let the rest of it go.",
      "Falling down is an event. Staying down is a decision. Decide well.",
    ]
  },
  {
    id: "doubt",
    name: "Self-doubt",
    lines: [
      "The voice saying you can't has been wrong before. It's wrong now.",
      "Feeling like a fraud usually means you're doing something that actually matters.",
      "You don't have to believe you can. Just try before you decide you can't.",
      "Confidence comes after the evidence. Go and get the evidence.",
      "Measure against yesterday's you, not somebody's highlight reel.",
      "You're more capable than your worst day tells you. Ask a good day instead.",
      "Doubt's allowed in the room. It doesn't get a vote.",
      "Everyone's winging it. The ones who win just wing it and keep moving.",
      "You've done things you once swore you couldn't. This is one more of those.",
      "Nobody's watching as closely as you fear. Get on with it.",
      "Scared and doing it anyway is the whole definition of brave. That's you, right now.",
      "High standards aren't proof you're falling short. They're why you're any good.",
      "The fraud feeling never fully leaves. Winners just bring it along for the ride.",
      "Start before you feel ready. Ready is built, not waited for.",
    ]
  }
]

// Every line across all categories, for the default 'surprise me' pool.
function allLines() {
  var out = []
  for (var i = 0; i < CATEGORIES.length; i++) out = out.concat(CATEGORIES[i].lines)
  return out
}

function linesFor(id) {
  for (var i = 0; i < CATEGORIES.length; i++)
    if (CATEGORIES[i].id === id) return CATEGORIES[i].lines
  return []
}

// A random line from `lines`, never equal to `last`. Returns the only line
// when there is just one, and "" when the list is empty.
function pick(lines, last) {
  if (!lines || lines.length === 0) return ""
  if (lines.length === 1) return lines[0]
  var next = last, guard = 0
  while (next === last && guard < 50) { next = lines[Math.floor(Math.random() * lines.length)]; guard++ }
  return next
}

if (typeof module !== "undefined") module.exports = { CATEGORIES: CATEGORIES, allLines: allLines, linesFor: linesFor, pick: pick }
