---
name: fill-application-form
description: Extract a job application form from pasted text or a readable link, draft grounded answers from this repository, and save the questions and responses as a plain-text `.txt` file in `tmp/application-forms`. Use when the user wants field-by-field application answers, not direct browser submission.
---

# Fill Application Form

Use this skill when the user wants a saved question-and-answer draft for a job application form.

The skill accepts either:

- form text pasted directly into the prompt
- a readable URL that contains the application form or vacancy application page

The output is always a plain-text `.txt` file in `tmp/application-forms/`.

## Required Input

Proceed only if one of these is available:

- pasted form text with the questions visible
- a URL that can be opened and read

If neither is available, or the link cannot be read, refuse briefly and ask for pasted form text or a readable link.

## Sources To Read

Read these repo files before drafting answers:

- [README.md](/home/user/repos/sergeia-resume-full-stack/README.md)
- [playbooks/job-search.md](/home/user/repos/sergeia-resume-full-stack/playbooks/job-search.md)
- [playbooks/resume-guidelines.md](/home/user/repos/sergeia-resume-full-stack/playbooks/resume-guidelines.md)
- [playbooks/resume-ats-optimization.md](/home/user/repos/sergeia-resume-full-stack/playbooks/resume-ats-optimization.md)

Then read the most relevant resume artifact:

- full-stack roles: `resumes/Sergei_Afonchenko_Senior_Full_Stack_Developer.pdf` or `.docx`
- backend-heavy roles: `resumes/Sergei_Afonchenko_Backend_Developer.pdf` or `.docx`

For repeat runs, prefer the cached extractor helper before manually parsing the resume:

```bash
bash .agents/skills/fill-application-form/scripts/extract_resume_context.sh resumes/Sergei_Afonchenko_Senior_Full_Stack_Developer.docx
```

The helper:

- normalizes the `.docx` into plain text
- caches the output in `tmp/application-forms/.cache/`
- appends basic timing data and cache-hit status to `tmp/application-forms/.cache/extraction.log.tsv`

If needed, inspect `resumes/invisible_tag_cloud.txt` for keyword coverage that is already supported by the repo.

## Link Handling

If the user gives a URL:

1. Read the page and find the actual application form fields.
2. If the page is JS-heavy or hides the form behind tabs, use `playwriter`.
3. With `playwriter`, read `playwriter skill` first and use a dedicated session.
4. Extract the exact visible field labels and answer options before drafting responses.

Do not submit the application unless the user explicitly asks for submission. This skill is for preparing answers and saving them locally.

## Drafting Rules

- Ground every response in repository artifacts or direct user input.
- Do not invent employment dates, locations, compensation expectations, work authorization, or other sensitive facts.
- If a question cannot be answered confidently from the repo, mark it clearly as `Needs user confirmation`.
- Keep answers concise and usable in copy-paste workflows.
- Prefer the strongest documented evidence: recent roles, measurable outcomes, current stack, LinkedIn, and contact details.
- For yes/no questions, answer directly, but only when the repo supports the claim.
- For open-ended motivation questions, tailor the answer to the role and company rather than reusing generic text.

## Output Format

Save the file as plain text with this structure:

```text
Role: <role if known>
Company: <company if known>
Source: <url or pasted form>

1. <Question>
<draft answer>

2. <Question>
<draft answer>
```

Use `Needs user confirmation` as the full answer when required.

## Saving

Always save the final output into `tmp/application-forms/` as a `.txt` file.

Use this helper:

```bash
bash .agents/skills/fill-application-form/scripts/save_application_form.sh <base-name>
```

Pass the final content on stdin. The script will:

- create `tmp/application-forms/` if needed
- normalize the base name into a safe slug
- force the `.txt` extension
- insert a top-level warning if the draft contains tentative markers such as `Needs user confirmation`
- print the saved file path

Choose a descriptive base name, usually `company-role` when that can be inferred.

## Done Criteria

- The form input was pasted or read from a live link.
- The saved file includes every identified question with a response.
- Unsupported answers are marked `Needs user confirmation` instead of guessed.
- The output is plain text.
- A `.txt` file exists in `tmp/application-forms/`.
