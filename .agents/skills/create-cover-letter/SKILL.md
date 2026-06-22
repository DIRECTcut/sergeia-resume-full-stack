---
name: create-cover-letter
description: Create a tailored cover letter for a specific vacancy using the resumes and playbooks in this repository. Use when the user provides a vacancy as pasted text, a readable local file link/path, or a readable URL and wants the result saved as a plain-text `.txt` file in `tmp/cover-letters`. Refuse if the vacancy input is missing or cannot be read.
---

# Create Cover Letter

Use this skill when the user wants a cover letter tailored to a concrete vacancy and grounded in the guidance and resume artifacts in this repository.

## Required Input

Proceed only if the vacancy is available in one of these forms:

- pasted directly into the prompt
- a local file path or file link that can be read
- a URL that can be opened and read

If none of these is provided, or the linked source is not readable, refuse briefly and ask for one of the supported inputs.

## Sources To Read

Read these repo files before drafting:

- [README.md](/home/user/repos/sergeia-resume-full-stack/README.md)
- [playbooks/job-search.md](/home/user/repos/sergeia-resume-full-stack/playbooks/job-search.md)
- [playbooks/resume-guidelines.md](/home/user/repos/sergeia-resume-full-stack/playbooks/resume-guidelines.md)
- [playbooks/resume-ats-optimization.md](/home/user/repos/sergeia-resume-full-stack/playbooks/resume-ats-optimization.md)

Then read the most relevant resume artifact for the role:

- full-stack roles: `resumes/Sergei_Afonchenko_Senior_Full_Stack_Developer.docx`
- backend-heavy roles: `resumes/Sergei_Afonchenko_Backend_Developer.docx`

If needed, inspect `resumes/invisible_tag_cloud.txt` for additional ATS-aligned keywords that are already supported by the repo.

## Drafting Rules

- Focus on documented strengths and directly confirmed user experience.
- Do not invent tools, languages, frameworks, domains, or achievements.
- Omit weaknesses by default unless the user explicitly asks for a gap analysis.
- Tailor the letter to the vacancy’s core responsibilities, not every bullet.
- Prefer backend, product impact, reliability, collaboration, and measurable outcomes when those are supported by the resume.
- Keep the tone concise and professional.
- Default to plain text, not Markdown.

## Output Shape

Default to `4` short paragraphs:

1. Target role and broad fit
2. Relevant technical and delivery strengths
3. Why this company or product area is a good fit
4. Short close

Keep it practical. Do not spend excessive time polishing unless the user asks.

## Saving

Always save the final letter into `tmp/cover-letters/` as a `.txt` file.

Use `scripts/save_cover_letter.sh` from this skill:

```bash
bash .agents/skills/create-cover-letter/scripts/save_cover_letter.sh <base-name>
```

Pass the final cover letter on stdin. The script will:

- create `tmp/cover-letters/` if needed
- normalize the base name into a safe slug
- force the `.txt` extension
- print the saved file path

Choose a descriptive base name, usually `company-role` when that can be inferred from the vacancy.

## Done Criteria

- Vacancy source was provided and readable.
- Letter is tailored to the specific vacancy.
- Claims are supported by repo artifacts or direct user confirmation.
- Output is plain text.
- A `.txt` file exists in `tmp/cover-letters/`.
