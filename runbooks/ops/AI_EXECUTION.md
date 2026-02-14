# AI Execution Policy (tools-ai)

This document defines what an AI assistant may and may not do in this repository.
The goal is to keep the repository safe even when AI is used for Git operations.

## Allowed (AI may do)
- Read files and propose changes as diffs/patches.
- Create or update documentation under `runbooks/**` (except protected paths, see below).
- Create branches and commits locally.
- Create Pull Requests (PRs) and update PR descriptions.
- Run local checks (formatters, linters, tests) and report results.

## Not allowed (AI must NOT do)
- Merge PRs into `main` (human-only).
- Push directly to `main` (PR-only workflow).
- Modify or disable security/policy checks.
- Introduce or move secrets into the repository.

## PR workflow rule
- AI may prepare changes up to PR creation.
- A human must review and merge (squash merge) after required checks pass.

## Secrets policy
- Never commit secrets (tokens, API keys, credentials, private keys).
- Never paste secrets into chat logs or issue/PR bodies.
- If a secret is suspected to be exposed, rotate it immediately and remove it from history.

## Protected / dangerous areas (CODEOWNERS review required)
Changes to the following paths require CODEOWNERS approval:
- `.github/workflows/**`
- `Makefile`
- `runbooks/**`

## Notes
- If the AI is unsure whether a change is safe, it must stop and ask for human confirmation.
