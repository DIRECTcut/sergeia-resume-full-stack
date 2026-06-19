---
name: recruiter-reply
description: Draft short replies to recruiter outreach messages on LinkedIn or email. Use when the user shares a recruiter's message and wants a response, especially for cold outreach. Always reply in the recruiter's language unless the user explicitly asks for a different one.
---

# Recruiter Reply

## Overview

Use this skill when the user pastes a recruiter or hiring manager message and wants a reply they can send back.

The default goal is:

- polite
- short
- interested but not overcommitted
- written in the same language as the inbound message

## Workflow

### 1. Identify Intent

Figure out what the user likely wants:

- ask for more details
- express interest and continue the conversation
- decline politely
- ask about compensation, stack, location, visa, or remote policy
- say not now but keep in touch

If the user's preferred intent is unclear, default to a short, positive reply that asks for more details.

### 2. Match Language

- Detect the language of the recruiter's message from the text itself.
- Write the reply in that same language.
- If the message mixes languages, prefer the language used in the greeting and main body.
- Only switch languages if the user explicitly asks.

### 3. Match Tone

- Mirror the recruiter's formality level.
- Keep the reply natural and human.
- Do not sound overeager, robotic, or overly polished.

### 4. Keep It Short

Default to `1-3` sentences.

Prefer:

- thanks for reaching out
- brief signal of interest or polite decline
- one next-step question if continuing

### 5. Avoid Weak Output

Do not:

- invent facts about the user
- promise availability, interviews, or salary expectations unless the user said so
- overuse exclamation marks
- write long paragraphs by default
- translate into English when the recruiter wrote in another language

## Default Reply Pattern

Use this structure unless the user asks for something else:

```text
Greeting + thanks.
Brief interest signal or polite decline.
Short next-step question if continuing.
```

## Examples

### Cold outreach, continue

Input intent:

- recruiter reached out cold
- user is open to hearing more

Output shape:

```text
Hi [Name], thanks for reaching out. This sounds interesting. Could you share a few more details?
```

### Cold outreach, decline

```text
Hi [Name], thanks for reaching out. I appreciate it, but this is not something I want to pursue right now.
```

### Interested, but need basics

```text
Hi [Name], thanks for reaching out. I'd be glad to learn more. Could you share the role details, location, and compensation range?
```

## Done Criteria

- The reply matches the recruiter's language.
- The text sounds natural.
- The message is short unless the user asked for more.
- No unsupported claims were added.
