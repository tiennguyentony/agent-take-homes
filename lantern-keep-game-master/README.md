# Agent Take-Home: Lantern Keep Game Master

## Overview

Build an AI game master for a short text adventure, from scratch, in about 2–3 hours. The player types what they want to do in plain English. Your agent narrates what happens, but the game's rules must hold no matter what the player types or what the model would like to say.

It is the same problem as shipping any LLM agent: the model is great at language and unreliable at facts and rules. Your job is to decide what the model owns and what your code owns, and to explain that decision.

After you submit, you will walk a reviewer through your code for 20 minutes, then extend it live together for 30–45 minutes.

| Area | What the reviewer asks |
| --- | --- |
| Craft and code quality | Is the code well structured and easy to follow? Could a designer add a room or an item without touching the agent code? |
| Use of AI | Does the design show how an LLM belongs inside an application: tools, state, context, guardrails, failure handling? |
| Conversation design | Does the narrator stay in voice, stay truthful to the game state, and handle odd or adversarial input gracefully? |
| Communication | Are decisions and trade-offs written down and easy to defend? |

## Client profile: Hollowpine Games

Hollowpine Games is a five-person indie studio that makes cozy, slightly spooky adventure games. They want a playable AI demo of their upcoming game, *Lantern Keep*, at a game expo next month. Hundreds of strangers will play it on a kiosk, and some of them will try to break it.

The lead designer has one hard rule: the AI may describe the world any way it likes, but it may never change the world. Players cannot talk their way into items they don't have, doors that are locked or rooms that don't exist.

### Narrator voice

- Second person, present tense: "You step into the courtyard. Wind tugs at your cloak."
- Cozy-spooky: candlelight, creaking wood, a little humor. Never gory.
- Short. Two to four sentences of description per turn.
- After the description, list the exits and visible items plainly, so the player never has to guess. End each turn with "What do you do?"
- When the player asks for something impossible, stay in character and explain in-world why it doesn't work.

## Requirements

At the start, ask for the player's name, then place them in the starting room. The game is won when the player picks up the Ember Crown.

### 1. Exploration

- The player moves between rooms using the map in Appendix A (`data/KeepMap.json`), a static dataset. Players may say "go north", "head to the kitchen" or "climb down"; your agent should understand all of these.
- Each room's description, exits and visible items come from the map. The narrator may add atmosphere but never new exits, items or rooms.
- Some exits are locked by a key item. The player passes only while carrying that key.
- Some rooms are dark. In a dark room, the player sees no items and can only go back the way they came, unless they carry a lit lantern.
- Never reveal a room the player has not reached yet.

### 2. Items and inventory

- The player can take, drop, examine, use and combine items, defined in Appendix B (`data/Items.json`), a static dataset.
- Inventory has a weight limit of 10. Items marked `takeable: false` stay where they are.
- Two items combine only if Items.json says they do, in either order. Combining replaces both inputs with the result.
- Examining an item returns its description from the data, plus any hint it carries.

### 3. The Midnight Bell

- The bell tower holds a bell rope. If the player explicitly rings the bell between 11:00 PM and 1:00 AM Pacific Time (real time, not game time), the stone slab in the Great Hall slides open, unlocking the crypt.
- At the same moment, generate a unique relic code in the format `BELL-XXXXXX`, tied to the player's name, which expo visitors redeem for a prize. One code per player name; ringing again returns the same code.
- Outside the window, the bell gives a dull clang and nothing else happens.

### Time

Your code must let a reviewer set the current date and time (for example an environment variable or a CLI flag). Produce your sample transcripts with the clock set to **2026-12-01, 11:30 PM Pacific**.

## Rules, tooling and submission

Keep it small, honest and runnable. The time limit is part of the test.

- **Interface:** a game loop in the terminal. The player types, the narrator replies. No UI.
- **Model:** any chat model with tool calling, such as gpt-4.1-mini or Claude Haiku. Load your API key from an environment variable and never commit it.
- **Allowed:** the provider's official SDK or raw HTTP, the standard library, a validation library such as pydantic, a test framework. Code copilots are encouraged.
- **Not allowed:** agent frameworks or orchestration libraries (LangChain agents, LangGraph, OpenAI Agents SDK, AutoGen, CrewAI) or agent templates. Write the loop yourself.
- **Data:** load both appendices from JSON files and do not edit them. The game should still work if a designer adds a room or an item to the JSON.
- **Time:** 2–3 hours. If you run out, write down what you would do next.

### What to submit

Send a .zip or a repository link at least 24 hours before your walkthrough, containing:

1. Source code and a one-command way to run it.
2. A README covering how to run it, the main design decisions, the trade-offs you made, and what you would do with another day.
3. Two or three transcripts: one full playthrough to the Ember Crown, and one where the player tries to cheat.

Send questions to your mentor before you start; asking good clarifying questions is part of the job.

## Data

| Appendix | File | Contents |
| --- | --- | --- |
| A | [`data/KeepMap.json`](data/KeepMap.json) | Starting room and 8 rooms with exits, locks and darkness. |
| B | [`data/Items.json`](data/Items.json) | Inventory weight limit and 10 items. |
