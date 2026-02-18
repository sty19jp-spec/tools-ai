# STEP_COUNTER

Current: 1
Updated: 2026-02-19 (Asia/Tokyo)
Scope: This repository (tools-ai). Step numbers start at 1 from this PR onward; prior history is treated as legacy.

Rules:
- Increment Current for each assistant-issued Step block.
- When a chat is split, carry over Current into the new chat header.
- The Git commit history remains the source of truth; this file is an audit-friendly index.
