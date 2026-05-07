---
name: teach-me
description: Use this skill when the user invokes /teach-me (with or without a topic argument). Switches into sentence-by-sentence teaching mode on the most recent explanation given (or on a new explanation of the provided topic). Presents one sentence at a time, prefixed with [N/T], and waits for questions before advancing.
---

# teach-me

Walk the user through a body of content one sentence at a time, answering questions on each sentence before moving on.

## When this skill fires

- `/teach-me` — apply to the most recent multi-sentence explanation in the conversation.
- `/teach-me <topic>` — first produce a concise explanation of the topic (as you normally would), then immediately enter sentence-by-sentence mode on that explanation.

## How it works

1. **Identify the content.** Either the last explanation you gave, or a freshly written one for the supplied topic.
2. **Split into sentences.** Number them 1…N. Count total sentences (N).
3. **Present sentence 1** in this exact format:

   ```
   [1/N] <sentence text>
   ```

4. **Wait.** The user may ask any number of follow-up questions. Answer each one, staying on that sentence.
5. **Advance** when the user says "proceed", "next", "ok", "continue", or any equivalent signal — or when there are no more questions and the user indicates they're done.
6. **Repeat** for sentences 2…N with the same `[N/T]` prefix.
7. **End** after the last sentence. No summary, no "we're done" fanfare — just stop.

## Rules

- **Always prefix** every sentence presentation with `[current/total]`. Never drop this.
- **Stay on the current sentence** until the user signals to move on. Don't volunteer the next sentence early.
- **Answer questions in plain prose**, no prefix needed. The prefix is only for sentence presentations.
- **Don't re-read the whole explanation** after each answer. Just answer and wait.
- **Adjust context.** If a question reveals the user lacks background, give a brief plain-English primer before answering. Don't assume shared vocabulary.
- **If the user says "skip"**, advance without questions.
- **If the user says "back"**, go back one sentence and re-present it.
- **Sentence splitting rules:**
  - Split on `.`, `?`, `!` followed by whitespace and an uppercase letter.
  - Keep list items (step 1, step 2 …) as individual sentences.
  - Don't split inside parentheses or quoted phrases.
  - If a "sentence" is a heading or label (e.g. "**Step 1 — Inventory:**"), attach it to the sentence that follows it.

## Tone

Match the register of the explanation. Technical explanation → stay technical but unpack jargon on request. High-level overview → keep it approachable.
