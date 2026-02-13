# Chat004 Runbook – tools-ai Policy Gate

## Source of Truth
- This repository (sty19jp-spec/tools-ai) is the single source of truth.
- Runbooks under /runbooks define operational standards.

## Operating Model
- All changes must go through Pull Request.
- Direct push to main is prohibited.
- Merge button only operation.

## Policy Gate
- CI must check:
  - No .env committed
  - No secrets detected
  - Required structure exists
  - Workflow file integrity

## Tool Creation Rule
- New tool must be created via:
  make new-tool name=<toolname>
# test 2026-02-13T21:05:52+09:00
