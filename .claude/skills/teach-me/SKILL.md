---
name: teach-me
description: Use this skill when the user invokes /teach-me (with or without a topic argument). Switches into sentence-by-sentence teaching mode on the most recent explanation given (or on a new explanation of the provided topic). Presents one sentence at a time, prefixed with [N/T], and waits for questions before advancing. Supports recursive nesting: the user may invoke /teach-me again on an answer given during a teach-me session, creating an inner session; when the inner session ends, the outer session resumes exactly where it paused.
---

# teach-me

Walk the user through a body of content one sentence at a time, answering questions on each sentence before moving on. Supports arbitrarily deep nesting.

## When this skill fires

- `/teach-me` — apply to the most recent multi-sentence explanation in the conversation.
- `/teach-me <topic>` — first produce a concise explanation of the topic, then immediately enter sentence-by-sentence mode on that explanation.

## How it works

1. **Identify the content.** Either the last explanation you gave, or a freshly written one for the supplied topic.
2. **Determine nesting depth.** Count how many teach-me sessions are currently active in this conversation. Depth 1 = outermost, depth 2 = one level in, etc.
3. **Split into sentences.** Number them 1…N.
4. **Present sentence 1** using the depth-prefixed format (see below).
5. **Wait.** Answer any follow-up questions in plain prose. If the user invokes `/teach-me` on your answer, enter a nested session (depth+1). When that inner session ends, re-present the paused outer sentence to signal resumption.
6. **Advance** when the user says "proceed", "next", "ok", "continue", or any equivalent signal.
7. **Repeat** for sentences 2…N.
8. **End** the session. If this was a nested session, signal return to the outer level by re-presenting the outer sentence it was paused on (see "Resuming the outer session" below).

## Depth prefix format

Each `›` represents one level of nesting. The prefix is always rendered as an inline code block, then a space, then the sentence text:

| Depth | Rendered output |
|-------|----------------|
| 1 (outermost) | `` `[3/11]` `` Debezium watches the outbox table… |
| 2 | `` `[› 1/4]` `` The WAL is Postgres's write-ahead log… |
| 3 | `` `[›› 1/2]` `` A replication slot is a cursor… |

Always wrap the prefix in backticks. Never write it as plain text.

## Resuming the outer session

When an inner session finishes (last sentence presented and user signals done, or user says "exit" / "back to outer"), re-present the outer session's paused sentence with a resumption marker:

```
↩ `[3/11]` Debezium watches the outbox table via CDC (reading the Postgres WAL / replication slot).
```

The `↩` signals "we're back". After this, continue the outer session normally.

## Other rules

- **Stay on the current sentence** until the user advances. Don't volunteer the next sentence.
- **Answer questions in plain prose** — no prefix on answers, only on sentence presentations.
- **Don't re-read the whole explanation** after each answer.
- **Adjust context.** If a question reveals a gap, give a brief primer before answering.
- **"skip"** — advance without questions.
- **"back"** — go back one sentence in the current (innermost) session and re-present it.
- **"exit" / "done" / "back to outer"** — end the current inner session and resume the outer one.
- **Sentence splitting rules:**
  - Split on `.`, `?`, `!` followed by whitespace and an uppercase letter.
  - Keep list items as individual sentences.
  - Don't split inside parentheses or quoted phrases.
  - Attach a heading/label sentence to the sentence that follows it.

## Tone

Match the register of the explanation. Technical → stay technical but unpack jargon on request.
