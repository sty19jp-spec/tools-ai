# AI Execution Policy

## 原則
- GitHubを唯一の正本とする
- 実装はCursor主導
- ChatGPTは差分監査担当
- Gitの真実はWSLターミナル出力

## Parallel Development Standard

同一リポジトリで並列作業を行う場合は
`git worktree` を使用する。

### 新規作成
git fetch origin
git worktree add -b <branch> ../<dir> origin/main

### 確認
git worktree list

### 禁止
- 並列目的での別clone
- mainへの直接commit
### 削除（後片付け）
git worktree remove ../<dir>
