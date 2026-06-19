---
name: transcribe-youtube-video
description: Transcribe a YouTube video URL into plain text using the Tactiq browser flow via playwriter, then save the result into `transcripts/raw/<video-id>.txt`. Use when the user gives a YouTube video URL and wants the transcript stored locally in this repository.
---

# Transcribe YouTube Video

## Overview

Use this skill when the input is a YouTube video URL and the goal is a saved local transcript file.

This repository's proven workflow is:

1. use `playwriter` with the user's Chrome session
2. open Tactiq's YouTube transcript entry page
3. submit the YouTube URL through the page form
4. extract the rendered transcript from the result page
5. save it to `transcripts/raw/<video-id>.txt`

Do not guess alternate sites or alternate flows unless this one is blocked.

## Required Setup

Before using `playwriter`, run:

```bash
playwriter skill
```

If `playwriter` fails with relay startup errors such as:

- `listen EPERM: operation not permitted 127.0.0.1:19988`
- `Failed to start CDP relay server after 5 seconds`

then retry the same `playwriter` commands outside the sandbox with escalated permissions. Treat that as an environment issue, not a website issue.

## Input Rules

Expected input:

- one YouTube video URL

Output path:

- `transcripts/raw/<video-id>.txt`

Filename rule:

- extract the `v` query parameter from a URL like `https://www.youtube.com/watch?v=O8n8eKp1DBo`
- use only the video ID as the basename
- example: `O8n8eKp1DBo` -> `transcripts/raw/O8n8eKp1DBo.txt`

If the URL format is unclear, inspect it and derive the canonical video ID before writing the file.

## Exact Workflow

### 1. Create Your Own Playwriter Session

Run:

```bash
playwriter session new
```

Use your own session ID for every later command.

### 2. Open The Correct Tactiq Entry Page

Open:

```text
https://tactiq.io/tools/youtube-transcript
```

Do not start at:

```text
https://tactiq.io/tools/run/youtube_transcript
```

That `run` page is the result view, not the URL-entry page.

### 3. Submit The URL Through The Form

Use these selectors:

- input: `input[name=yt]`
- submit: `input[type=submit]`

Fill the input with the full YouTube URL and submit it.

Expected result:

- the page navigates to `/tools/run/youtube_transcript?...`

### 4. Do Not Rely On The Site Download Button

The visible result page includes `Copy` and `Download`, but the site `Download` control may not emit a real browser download event.

Preferred source of truth:

- the rendered transcript rows in the DOM

Use this selector on the result page:

- transcript rows: `a[data-start]`

Extract each row's text content, trim it, keep only non-empty lines, and join them with `\n`.

### 5. Save The Transcript Locally

Ensure `transcripts/raw/` exists, then write:

```text
transcripts/raw/<video-id>.txt
```

Save plain UTF-8 text with a trailing newline.

## Recommended Playwriter Pattern

Use multiple short calls instead of one large opaque call.

Recommended sequence:

1. `playwriter session new`
2. open `https://tactiq.io/tools/youtube-transcript`
3. verify the entry form exists
4. submit the YouTube URL
5. verify the page moved to `/tools/run/youtube_transcript?...`
6. extract `a[data-start]` rows
7. write `transcripts/raw/<video-id>.txt`
8. read back the first lines and file size to verify success

## Verification

After writing the file, verify:

- the output file exists
- the file is non-empty
- the first lines look like transcript text

Useful checks:

```bash
sed -n '1,40p' transcripts/raw/<video-id>.txt
wc -l -c transcripts/raw/<video-id>.txt
```

## Known Working Behavior

This workflow was already proven in this repo with:

- input URL: `https://www.youtube.com/watch?v=O8n8eKp1DBo`
- output file: `transcripts/raw/O8n8eKp1DBo.txt`

Observed site behavior:

- the Tactiq entry form lives on `https://tactiq.io/tools/youtube-transcript`
- submission redirects to `https://tactiq.io/tools/run/youtube_transcript?...`
- transcript content is present in DOM nodes matching `a[data-start]`
- direct browser download may fail even when the transcript is fully rendered

## Done Criteria

- The transcript is saved under `transcripts/raw/<video-id>.txt`.
- The saved file was extracted from the rendered result page, not guessed or summarized.
- The file was read back locally to verify it exists and contains transcript text.
