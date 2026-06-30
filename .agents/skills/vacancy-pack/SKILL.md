---
name: vacancy-pack
description: Create a bundled vacancy artifact pack from pasted vacancy text, a readable local file/path, or a readable URL. Use when the user wants one folder containing the normalized vacancy, visible application fields, a tailored cover letter, a draft application-form answer file, and the exact hr-breaker step or status for that vacancy.
---

# Vacancy Pack

Use this skill when the user wants a single bundled set of artifacts for one vacancy.

The output goes into:

- `tmp/vacancy-packs/<company-role>/`

Do not submit the application unless the user explicitly asks for submission. This skill is for preparing artifacts, not browser submission.

## Required Input

Proceed only if the vacancy is available as one of:

- pasted vacancy text
- a readable local file path or file link
- a readable URL

If no readable vacancy source is available, refuse briefly and ask for one.

## Existing Repo Workflows

Reuse the repository workflows that already exist instead of reimplementing them:

- `create-cover-letter`
- `fill-application-form`
- `run-hr-breaker`

Use their documented save paths and constraints as the source of truth.

## Workflow

### 1. Read the vacancy

If the vacancy is a URL:

1. Read the page.
2. If the page is JS-heavy, hides the form behind tabs, or requires interaction to expose fields, use `playwriter`.
3. With `playwriter`, read `playwriter skill` first and use a dedicated session.
4. Extract both:
   - normalized vacancy details
   - exact visible application fields and answer options

If the vacancy is pasted text or a local file, normalize it into a local Markdown file.

### 2. Choose the resume

Pick the most relevant base resume:

- full-stack roles: `resumes/Sergei_Afonchenko_Senior_Full_Stack_Developer.pdf` and `.docx`
- backend-heavy roles: `resumes/Sergei_Afonchenko_Backend_Developer.pdf` and `.docx`

Do not guess unsupported claims from the resume. Prefer grounded recent experience and measurable outcomes.

### 3. Create the bundle folder

Create:

- `tmp/vacancy-packs/<company-role>/`

Use a safe slug inferred from the company and role when possible.

Save at minimum:

- `vacancy.md`
- `application-form-fields.txt`
- `README.txt`

`README.txt` should briefly describe the bundle contents and any gated steps.

### 4. Generate the cover letter

Create a tailored plain-text cover letter using the vacancy and the relevant resume context.

Save it both:

- through the cover-letter workflow in `tmp/cover-letters/`
- copied into the bundle as `cover-letter.txt`

### 5. Generate application-form answers

Create a field-by-field draft answer file grounded in the repo artifacts and the live form fields.

Rules:

- include every identified visible question
- answer directly only when the repo supports the claim
- use `Needs user confirmation` when the answer is not supported
- do not invent location, work authorization, compensation, availability, or sensitive screening answers

Save it both:

- through the application-form workflow in `tmp/application-forms/`
- copied into the bundle as `application-form.txt`

### 6. Handle hr-breaker

Prepare the repo-local ATS optimization step using the supported wrapper:

- `scripts/setup-hr-breaker.sh`
- `scripts/run-hr-breaker.sh`

If policy permits a live run, execute it according to `run-hr-breaker`.

If policy blocks the live run because it would send resume/vacancy contents to an external LLM/API, save:

- `hr-breaker-status.txt`

That file must include:

- status
- reason if blocked
- prepared resume path
- prepared vacancy path
- exact command to run locally
- expected output location

### 7. Final validation

Before finishing, verify the bundle contains the expected files and that each saved artifact points to real repo paths.

## Output Shape

The bundle should normally contain:

- `README.txt`
- `vacancy.md`
- `application-form-fields.txt`
- `cover-letter.txt`
- `application-form.txt`
- `hr-breaker-status.txt` or other hr-breaker result note

## Done Criteria

- Vacancy source was readable.
- A bundle folder exists in `tmp/vacancy-packs/`.
- The normalized vacancy and visible form fields were saved.
- The cover letter was saved locally and copied into the bundle.
- The application-answer draft was saved locally and copied into the bundle.
- The hr-breaker step was either executed or documented with exact status and command.
