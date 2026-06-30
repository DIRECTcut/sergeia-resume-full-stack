## Repo purpose

Refer to `README.md`.

## Repo structure

- `playbooks` - md playbook files for handling specific aspects of job search
- `resumes` - concrete resume artifacts/templates. Mostly treat as disposable artifacts
- `AGENTS.md` - this document
- `README.md` - high level project description

## Agent guidelines

Dont make far-fetched assumptions - ask user when in doubt, unless directly instructed otherwise

When a required local dependency or helper library is missing, the agent may install it into an isolated environment (for example, a Python `venv`) instead of requiring a system-wide install. Prefer isolated, reversible installs and avoid changing global system packages unless the user explicitly asks for that.

Credential handling:
- Do not open `.env` files or print secret values unless the user explicitly asks for that exact content.
- Prefer passing credentials through existing environment files or shell sourcing without echoing values.
- Do not commit secrets; keep real credentials in ignored local `.env` files and commit only placeholder `.env.example` files.

Use `.venv` for installation of python packages. `.venv` is git ignored. For other languages/tools, use same pattern where appropriate.

Keep the repo structured. If new information comes in that does not fit into the existing structure, it needs to be expanded/updated. Confirm your intention with the user in this case before proceeding.