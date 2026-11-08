# Agent Take-Home: Halvorsen Accounts Payable Agent

## Overview

Build an internal accounts-payable (AP) agent, from scratch, in about 2–3 hours. The agent's users are the finance team, not customers. They ask it to check invoices against purchase orders, answer questions about vendors and spend, and schedule approved invoices for the weekly payment run.

This is money leaving the company, so mistakes are expensive and every decision must be explainable to an auditor. Your job is to decide what the model may decide, what your code must decide, and how you prove which was which.

After you submit, you will walk a reviewer through your code for 20 minutes, then extend it live together for 30–45 minutes.

| Area | What the reviewer asks |
| --- | --- |
| Craft and code quality | Is the code well structured and easy to follow? Could finance change a policy number without touching the agent? |
| Use of AI | Does the design show how an LLM belongs inside a high-stakes workflow: tools, deterministic rules, permissions, untrusted input, failure handling? |
| Conversation design | Are answers precise, sourced to document IDs, and honest about what the agent cannot do? |
| Communication | Are decisions and trade-offs written down and easy to defend? |

## Client profile: Halvorsen Industrial

Halvorsen Industrial is a 600-person manufacturer of commercial HVAC parts. Its AP team of three processes about 1,200 invoices a month and falls behind every quarter-end close. Last year a vendor-impersonation email nearly redirected a $48,000 payment to a fraudster, so the CFO has two conditions for any AI tool: it must never move money on its own judgment, and every decision must be traceable to a written rule.

### Users and roles

The user's role is set when the program starts (for example `--role clerk`), never by anything typed in the chat.

| Role | May do |
| --- | --- |
| Clerk | Check invoices, ask questions, schedule invoices up to $10,000.00 |
| Controller | Everything a clerk can do, plus schedule invoices above $10,000.00 |

### Output standards

- Plain, precise, professional. No emojis, no jokes, no filler.
- Always cite document IDs (invoice, PO, vendor) next to the facts that come from them.
- Money always has a currency and two decimals: `USD 2,650.00`. Never round.
- When the agent is unsure or something is missing, it says so and names the person or team who can resolve it.
- Summaries of several invoices go in a compact table.

## Requirements

The agent supports three features and an audit log. Use Appendices A, B and C as static datasets.

### 1. Invoice matching

When asked to check one or more invoices, apply these rules and report the result per invoice, with the reason for every exception.

1. The invoice must reference a PO. The PO's vendor and currency must match the invoice's.
2. For each invoice line (matched to the PO line with the same `line` number), the invoiced quantity must not exceed the quantity received.
3. The invoiced unit price may be at most 2.0% above the PO unit price. Lower prices are fine.
4. An invoice is a duplicate when an earlier-received invoice has the same vendor, the same total, and the same invoice number after removing punctuation and spaces and ignoring case.

The result is one of: **Matched**, **Matched with note** (a price variance within tolerance), or **Exception** (any rule failed).

### 2. Vendor and spend questions

Answer questions such as "What are Apex's payment terms?", "How much has Northstar invoiced us this month?" or "What is due in the next 30 days?". The due date is the invoice date plus the vendor's net days. Every number in the answer must come from the data, computed in code.

### 3. Payment run scheduling

- Halvorsen pays vendors in a weekly run every Thursday. The cutoff is **2:00 PM Central Time** on Thursday. Anything scheduled before the cutoff joins that day's run; anything after joins the next Thursday's run.
- An invoice can be scheduled only if it is Matched or Matched with note, the user's role allows the amount, and the vendor's bank details have not changed in the last 30 days unless that change has been verified.
- Apply early-payment discounts automatically. For terms "2/10 Net 30", the payment is 2% lower when the run date is no more than 10 days after the invoice date.
- Before scheduling, show the user what will be paid (invoice, vendor, amount, discount, run date) and wait for an explicit confirmation.
- Give each scheduled invoice a unique payment ID in the format `PMT-XXXXXXXX`. Scheduling an invoice that is already scheduled returns its existing payment ID and never adds it twice.

### Audit log

Write every check, scheduling decision and refusal to an append-only JSON Lines file: timestamp, role, action, document IDs, which rules passed or failed, and the outcome.

### Time

Your code must let a reviewer set the current date and time (for example an environment variable or a CLI flag). Produce your sample transcripts with the clock set to **Thursday 2026-12-03, 1:30 PM Central**.

## Rules, tooling and submission

Keep it small, honest and runnable. The time limit is part of the test.

- **Interface:** a chat loop in the terminal, started with a role flag. No UI.
- **Model:** any chat model with tool calling, such as gpt-4.1-mini or Claude Haiku. Load your API key from an environment variable and never commit it.
- **Allowed:** the provider's official SDK or raw HTTP, the standard library, a validation library such as pydantic, a test framework. Code copilots are encouraged.
- **Not allowed:** agent frameworks or orchestration libraries (LangChain agents, LangGraph, OpenAI Agents SDK, AutoGen, CrewAI) or agent templates. Write the loop yourself.
- **Data:** load the three appendices from JSON files and do not edit them. Keep policy numbers (tolerance, approval limit, cutoff, bank-change window) in one place that is easy to change.
- **Payments are simulated.** "Scheduling" means recording it in your program's state; nothing real is paid.
- **Time:** 2–3 hours. If you run out, write down what you would do next.

### What to submit

Send a .zip or a repository link at least 24 hours before your walkthrough, containing:

1. Source code and a one-command way to run it.
2. A README covering how to run it, the main design decisions, the trade-offs you made, and what you would do with another day.
3. Two or three transcripts, including one run as a clerk and one as a controller, plus the audit log they produced.

Send questions to your mentor before you start; asking good clarifying questions is part of the job.

## Data

| Appendix | File | Contents |
| --- | --- | --- |
| A | [`data/Vendors.json`](data/Vendors.json) | 5 vendors with payment terms and bank-change status. |
| B | [`data/PurchaseOrders.json`](data/PurchaseOrders.json) | 6 purchase orders. `qty_received` is what the warehouse has logged as delivered. |
| C | [`data/Invoices.json`](data/Invoices.json) | 8 invoices. `invoice_id` is Halvorsen's internal ID; `invoice_number` is the vendor's. `notes` is free text copied from the vendor's document. |
