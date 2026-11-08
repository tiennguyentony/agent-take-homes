# Agent Take-Homes

Three 2–3 hour take-home exercises for practicing AI-agent engineering interviews. Each one asks you to build a tool-calling agent from scratch in the terminal, with no agent frameworks, and then defend and extend it in a live walkthrough.

All three test the same core skill, from different angles: **deciding what the LLM may decide and what the code must decide.**

| Take-home | Domain | Focus | Difficulty |
| --- | --- | --- | --- |
| [Kestrel Cycles Support Agent](kestrel-cycles-support/) | Customer support for a bike retailer | Order lookup, returns, recommendations, a time-limited promo, brand voice | Starter |
| [Lantern Keep Game Master](lantern-keep-game-master/) | AI narrator for a text adventure | Exploration, inventory and a time-gated event, while the narrator stays truthful to the game state | Intermediate |
| [Halvorsen Accounts Payable Agent](halvorsen-accounts-payable/) | Internal finance agent | Invoice matching, spend questions, payment scheduling with roles and an audit log | Advanced |

All companies, people and data are fictional.

## Repo layout

```
<take-home>/README.md     the brief
<take-home>/data/         the JSON datasets (the brief's appendices)
scripts/package_brief.sh  zips one take-home, for sending as a file
```

## How to use it

Your mentor will tell you which take-home to do. Read its brief, build your agent in your own repository, and submit as the brief describes. To send one take-home as a file, run `scripts/package_brief.sh <take-home-folder>`.
