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

Read [playbooks/salary-or-rate-negotiation.md](/home/user/repos/sergeia-resume-full-stack/playbooks/salary-or-rate-negotiation.md) when the recruiter asks about salary expectations, compensation, or hourly rate.

## Workflow

### 1. Identify Intent

Figure out what the user likely wants:

- ask for more details
- express interest and continue the conversation
- decline politely
- ask about compensation, stack, location, visa, or remote policy
- say not now but keep in touch

If the user's preferred intent is unclear, default to a short, positive reply that asks for more details.

### 2. Answer Every Question

- If the recruiter asked multiple questions, answer all of them in the reply.
- Do not ignore earlier questions just because the final question is about compensation.
- Keep answers concise, but still cover every prompt the recruiter included.
- If one question requires more detail than fits comfortably in a short reply, answer briefly and offer to expand.

### 3. Match Language

- Detect the language of the recruiter's message from the text itself.
- Write the reply in that same language.
- If the message mixes languages, prefer the language used in the greeting and main body.
- Only switch languages if the user explicitly asks.

### 4. Match Tone

- Mirror the recruiter's formality level.
- Keep the reply natural and human.
- Do not sound overeager, robotic, or overly polished.

### 5. Handle Salary Or Rate Questions

- When asked for salary expectations or hourly rate, never give a number first.
- Use the guidance in `playbooks/salary-or-rate-negotiation.md`.
- Ask for the employer's range, budget, or compensation band instead.
- Keep the answer calm and matter-of-fact, not evasive.

### 6. Keep It Short

Default to `1-3` sentences.

If the recruiter asked several concrete questions, it is acceptable to go longer than `3` sentences so long as the reply stays compact and answers everything.

Prefer:

- thanks for reaching out
- brief signal of interest or polite decline
- one next-step question if continuing

### 7. Save The Result

- Write the final reply into `./tmp`.
- Use a short descriptive filename based on the company, recruiter, or scenario when possible.
- Prefer markdown files that contain a fenced `text` block.

### 8. Avoid Weak Output

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
Answer each recruiter question in compact form.
Ask for the employer's range instead of giving a salary number first.
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

### Multiple questions, including rate

```text
Hi [Name], thanks for sharing the details. The role sounds interesting and relevant to my background.

I've worked on end-to-end features, from problem framing and technical design through implementation, testing, deployment, and production follow-up. I'm strongest on the backend and application architecture side, though I've also worked extensively with React and TypeScript on the frontend. I've worked on systems that needed to scale and handle near real-time data, with the main challenges usually being performance, observability, and database bottlenecks. I also have experience designing APIs and working with PostgreSQL, including data modeling and query optimization.

When requirements are unclear or changing, I usually work closely with product and design to reduce ambiguity, align on tradeoffs, and move iteratively. As for rate, I'd prefer to first understand the range you have budgeted for the role and the contract setup.
```

## Done Criteria

- The reply matches the recruiter's language.
- The text sounds natural.
- Every recruiter question was answered.
- Salary or rate questions do not get a number-first answer.
- The message is short unless answering all questions requires more space.
- No unsupported claims were added.
- A file with the drafted reply exists in `./tmp`.
