---
name: clean-transcription
description: Turn rough transcript text into a short, actionable Markdown playbook saved in `transcripts/cleaned`, preserving the speaker's practical advice while removing noise and weak structure.
---

# Clean Transcription

## Overview

Use this skill when transcript text is messy but the goal is not a literal transcript. The output should be a concise Markdown playbook that captures practical takeaways, split into short sections, written for action rather than narration.

## What To Produce

- Create a new `.md` file in `transcripts/cleaned`.
- Distill the transcript into practical takeaways only.
- Keep it short, but still full enough to be useful without reopening the source transcript.
- Structure it with short section headings.
- Prefer headings like `Resume`, `Search`, `Outreach`, `Interviews`, `Routine`, `Traps`.
- Avoid verbose headings like `Writing a resume` or `How to search for jobs effectively`.
- Make the document read like a playbook.

## Workflow

### 1. Check For Ambiguity

Ask the user a short question if any of these are unclear:

- which transcript to use
- what to name the output file
- whether the user wants multiple transcripts merged

If those points are clear from context, proceed without asking.

### 2. Read The Transcript

- Read the transcript from the user-provided text or source file.
- Ignore platform boilerplate, timestamps, filler words, repeated fragments, and transcription artifacts.
- Preserve the actual advice, priorities, caveats, and examples.

### 3. Extract Practical Takeaways

- Focus on decisions, tactics, routines, warnings, heuristics, and examples that can guide action.
- Remove chatter, rhetorical repetition, and off-topic digressions.
- Convert long spoken explanations into compact bullets.
- Keep the speaker's intent, but rewrite for clarity and usefulness.

### 4. Shape It As A Playbook

- Start with a short title that matches the topic.
- Split the content into clear sections based on the transcript's themes.
- Use concise bullets under each section.
- Make every bullet actionable, specific, or evaluative.
- Prefer direct wording over explanation-heavy prose.

### 5. Save The Output

- Write the final Markdown file into `transcripts/cleaned`.
- Use a filename derived from the source transcript when possible.
- If the source is `transcripts/raw/topic_name.txt`, default to `transcripts/cleaned/topic_name.md`.

## Style Rules

- Short headings only.
- Actionable wording first.
- No transcript-style speaker labels unless the user explicitly asks for them.
- No long intro.
- No fluffy conclusion.
- No attempt to preserve exact spoken phrasing when a clearer rewrite is better.
- Keep the final result compact enough to scan quickly.

## Output Shape

Use this pattern unless the transcript strongly requires a different split:

```md
# Topic

## Mindset

- ...

## Resume

- ...

## Search

- ...

## Outreach

- ...

## Interviews

- ...

## Routine

- ...

## Traps

- ...
```

Not every section is required. Include only sections supported by the transcript.

## Done Criteria

- A new file exists in `transcripts/cleaned`.
- The document is short, readable, and actionable.
- Headings are compact.
- The content reads like a playbook, not a cleaned verbatim transcript.
