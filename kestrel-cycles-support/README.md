# Agent Take-Home: Kestrel Cycles Support Agent

## Overview

Build a terminal customer-support agent, from scratch, for a fictional bike retailer in about 2–3 hours. The exercise mirrors the first week of shipping an LLM agent to a real client: read a brief, decide what the model should decide and what your code should decide, design the tools and prompt, and explain the trade-offs.

After you submit, you will walk a reviewer through your code for 20 minutes, then extend it live together for 30–45 minutes. Build something you are comfortable changing in front of someone.

| Area | What the reviewer asks |
| --- | --- |
| Craft and code quality | Is the code well structured and easy to follow? How hard is it to add a fourth feature? |
| Use of AI | Does the design show how an LLM belongs inside an application: tools, context, guardrails, failure handling? |
| Conversation design | Does the agent do the right thing, in the right voice, including when the customer is wrong, vague or adversarial? |
| Communication | Are decisions and trade-offs written down and easy to defend? |

## Customer profile: Kestrel Cycles

Kestrel Cycles is a four-year-old, direct-to-consumer bike and gear brand that competes with the big bike makers and outdoor co-ops. Its founder spent a decade running last-mile delivery operations before starting the company, so she cares about order accuracy more than anything else. The team has never shipped generative AI. The COO is openly skeptical: her one condition is that the agent never invents a policy, a product or a discount.

The launch is timed for the holiday rush. December brings gift orders and January brings a wave of returns, so order and return questions will dominate traffic.

### Brand voice

Kestrel wants the agent to sound like a friendly trailside mechanic. Use the brief below in the agent's replies.

- Lean on cycling language: "Let's get you rolling", "Keep the rubber side down!", "Smooth roads ahead".
- Use the occasional bike, trail or mountain emoji, but no more than one or two per reply.
- Clarity beats character. Order numbers, tracking links and discount codes must stand alone on their own line, easy to copy.
- Never blame the customer, never use sarcasm, and drop the playful tone when someone is frustrated or a delivery is late.

## Requirements

Your agent must support three features in a single conversation. A customer may move between them freely.

### 1. Order status, tracking and return eligibility

- Before sharing anything about an order, collect the customer's email and order number. Both must belong to the same order.
- Report the order's status. For orders that have shipped, include a tracking link in this format: `https://track.kestrelcycles.example/{tracking_number}`
- If the customer asks about a return, decide whether each item is eligible. An item is eligible when the order is Delivered, the delivery date is no more than 30 days ago, and the item is not marked `final_sale`.
- When something is not eligible, say why. The agent does not process returns itself; eligible customers get the returns portal link: `https://kestrelcycles.example/returns`
- Use Appendix A (`data/CustomerOrders.json`) as a static dataset.

### 2. Bike and gear recommendations

- Answer product questions and make recommendations using only Appendix B (`data/ProductCatalog.json`) as a static dataset.
- Take into account what the customer tells you: budget, riding style, and rider height for bikes (each frame size lists a height range).
- Never recommend an out-of-stock item without saying it is out of stock. If nothing fits, say so and offer the closest match.

### 3. Night Owl promotion

- Kestrel offers a 15% discount code between 9:00 PM and 11:59 PM Eastern Time.
- If a customer explicitly asks for the Night Owl promotion during that window, generate a unique code in the format `NIGHTOWL-XXXXXX` and tie it to the customer's email.
- Each email gets one code. If the same email asks again, return the code it already has.
- Outside the window, explain when the promotion runs.

### Time and dates

Your code must let a reviewer set the current date and time (for example with an environment variable or a CLI flag), so time-dependent behavior can be tested. Produce your sample transcripts with the clock set to **2026-12-01, 9:30 PM Eastern**.

## Rules, tooling and submission

Keep it small, honest and runnable. The time limit is part of the test: the goal is to see how you build agents, not how much free time you have.

- **Interface:** a chat loop in the terminal. The user types a message and gets a text reply. No UI.
- **Model:** any chat model with tool calling, such as gpt-4.1-mini or Claude Haiku. Use your own API key, load it from an environment variable, and never commit it.
- **Allowed:** the provider's official SDK or raw HTTP, the standard library, a validation library such as pydantic, a test framework. Code copilots (Cursor, Copilot, Claude) are encouraged.
- **Not allowed:** agent frameworks or orchestration libraries (LangChain agents, LangGraph, OpenAI Agents SDK, AutoGen, CrewAI) or agent templates. Write the loop yourself.
- **Data:** load both appendices from JSON files. Do not edit them.
- **Time:** 2–3 hours. If you run out, write down what you would do next rather than keep going.

### What to submit

Send a .zip or a repository link at least 24 hours before your walkthrough, containing:

1. Source code and a one-command way to run it.
2. A README covering how to run it, the main design decisions, the trade-offs you made, and what you would do with another day.
3. Two or three sample transcripts that show each feature, including at least one case where the agent says no.

Questions are welcome. Send them to your mentor before you start; asking good clarifying questions is part of the job.

## Data

| Appendix | File | Contents |
| --- | --- | --- |
| A | [`data/CustomerOrders.json`](data/CustomerOrders.json) | 8 customer orders. All prices in USD. |
| B | [`data/ProductCatalog.json`](data/ProductCatalog.json) | 14 products. All prices in USD; rider heights in centimeters. |
