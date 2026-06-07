---
name: teach-me
description: Use this skill when the user invokes /teach-me (with or without a topic argument). Switches into part-by-part teaching mode on the most recent explanation given (or on a new explanation of the provided topic). Presents one logical part at a time, prefixed with [N/T], and waits for questions before advancing. Supports recursive nesting: the user may invoke /teach-me again on an answer given during a teach-me session, creating an inner session; when the inner session ends, the outer session resumes exactly where it paused.
---

# teach-me

Walk the user through a body of content one logical part at a time, answering questions on each part before moving on. Supports arbitrarily deep nesting.

## When this skill fires

- `/teach-me` — apply to the most recent multi-sentence explanation in the conversation.
- `/teach-me <topic>` — first produce a concise explanation of the topic, then immediately enter sentence-by-sentence mode on that explanation.

## How it works

1. **Identify the content.** Either the last explanation you gave, or a freshly written one for the supplied topic.
2. **Determine nesting depth.** Count how many teach-me sessions are currently active in this conversation. Depth 1 = outermost, depth 2 = one level in, etc.
3. **Split into logical parts.** Choose the granularity that fits the content type (see "Splitting rules" below). Number them 1…N.
4. **Present part 1** using the depth-prefixed format (see below).
5. **Wait.** Answer any follow-up questions in plain prose. If the user invokes `/teach-me` on your answer, enter a nested session (depth+1). When that inner session ends, re-present the paused outer part to signal resumption.
6. **Advance** when the user says "proceed", "next", "ok", "continue", or any equivalent signal.
7. **Repeat** for parts 2…N.
8. **End** the session. If this was a nested session, signal return to the outer level by re-presenting the outer part it was paused on (see "Resuming the outer session" below).

## Depth prefix format

Each `›` represents one level of nesting. The prefix is always rendered as an inline code block, then a space, then the sentence text:

| Depth | Rendered output |
|-------|----------------|
| 1 (outermost) | `` `[3/11]` `` Debezium watches the outbox table… |
| 2 | `` `[› 1/4]` `` The WAL is Postgres's write-ahead log… |
| 3 | `` `[›› 1/2]` `` A replication slot is a cursor… |

Always wrap the prefix in backticks. Never write it as plain text.

## Resuming after a digression

Whenever control returns to a session level — either because an inner session ended, or because a plain question was answered — **always re-present the last sentence shown at that level** with a resumption marker before waiting for the user to advance.

When re-presenting, you may add a brief parenthetical that anchors the part to the digression just covered, so the user can see how it fits:

```
↩ `[3/11]` TCP guarantees delivery but not ordering across parallel streams. *(TCP being the transport layer we just covered)*
```

```
↩ `[1/9]` A process is an independent program instance managed by the OS. *(where "independent" means its own memory space — the isolation we just discussed)*
```

Keep the parenthetical short — one clause. Omit it if the digression was brief and the part already makes sense on its own. The `↩` signals "we're back here". After re-presenting, wait for the user to advance normally. Do not auto-advance.

## Other rules

- **Stay on the current part** until the user advances. Don't volunteer the next part.
- **Answer questions in plain prose** — no prefix on answers, only on part presentations.
- **Don't re-read the whole content** after each answer.
- **Adjust context.** If a question reveals a gap, give a brief primer before answering.
- **"skip"** — advance without questions.
- **"back"** — go back one part in the current (innermost) session and re-present it.
- **"exit" / "done" / "back to outer"** — end the current inner session and resume the outer one.
- **Splitting rules — choose granularity by content type:**
  - **Prose / explanation:** split on sentence boundaries (`.`, `?`, `!` + whitespace + uppercase). Keep list items as individual parts. Don't split inside parentheses or quoted phrases. Attach a heading to the part that follows it.
  - **Commit diff:** one part per file changed (or per hunk if a single file has clearly distinct hunks). Lead each part with the filename and a one-line summary of what changed there, then show the diff excerpt.
  - **YAML / config / structured data:** one part per top-level key or logical block (e.g. each alert rule, each job stanza). Attach nested keys to the parent block they belong to.
  - **Code (non-diff):** one part per top-level declaration (function, class, constant block). Attach inline helpers to the caller.
  - **When in doubt:** prefer fewer, coherent parts over many tiny ones — a part should feel like a complete thought, not a fragment.

## Tone

Match the register of the explanation. Technical → stay technical but unpack jargon on request.
