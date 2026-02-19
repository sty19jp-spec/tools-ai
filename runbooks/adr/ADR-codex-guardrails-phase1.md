# ADR: Codex Guardrails Phase 1（個人運用）

- Status: Accepted
- Date: 2026-02-19
- Scope: tools-ai / Codex CLI Guardrails（T2前の方式決定）

## Context

目的は「Codex が docker build/run を実行して環境を破壊するリスクを低減する」ことである。

検討した方式：
- A: ~/.codex/rules/*.rules
- B: /etc/codex/requirements.toml
- D: wrapper script

個人運用フェーズであり、将来WSLが3台程度に増える可能性がある。
D（wrapper）は重いため採用しない。

## Decision

Phase 1 では以下を採用する：

- A単独（.rules）
- Updateラッパー方式
- codex execpolicy check による更新時検証

B（requirements.toml）は企業展開フェーズまで保留とする。

## Rationale

- .rules はユーザー領域で管理でき、配布が容易。
- 将来3台構成でも dotfiles で再現しやすい。
- execpolicy check によりルール適用の破綻を検知可能。
- Update後〜検証前の空白は許容する。
- Dは運用コストが重いため採用しない。

## Risk Acceptance

- .rules は experimental であることを受容する。
- docker 実行経路変更リスクは Update検証で吸収する。
- 完全強制保証は Phase 2 で再検討する。

## Verification

Update時に必ず以下を実行する：

- codex --version
- codex execpolicy check ...（docker関連数本）

更新検証を Updateラッパーに組み込む。
