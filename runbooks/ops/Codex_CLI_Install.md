# Codex CLI 導入（WSL・CUI安全運用）

このRunbookは、WSL（Ubuntu）上で Codex CLI を導入し、`sty19jp-spec/tools-ai` のリポジトリ作業で**安全に使う**ための手順を定義します。

---

## 0. 前提（このRunbookが守るルール）

- 正本（Source of Truth）は GitHub: `sty19jp-spec/tools-ai`
- `main` へ直pushしません。**PR = Pull Request（変更提案とレビューの単位）** 経由で入れます。
- **CI = Continuous Integration（自動検査）** を必須ゲートにします。
- Secrets（Token / API Key / 秘密鍵）を **Gitに入れません**。チャットにも貼りません。
- 端末貼り付けが不安定なため、長文ヒアドキュメントでRunbookを編集しません。

---

## 1. 対象環境

- Windows 11 + WSL2
- Ubuntu 24.04 LTS（想定）
- 作業ディレクトリ：`~/tools-ai`

---

## 2. 事前確認

以下が揃っていることを確認します。

- `gh` がログイン済み（`gh auth status`）
- `nvm` が導入済み（`nvm --version`）
- Node.js が導入済み（`node --version`）

---

## 3. Codex CLI の導入（npm global）

### 3.1 導入

```bash
npm i -g codex-cli
```

### 3.2 動作確認

```bash
codex --version
```

---

## 4. 安全運用（repo作業の基本）

### 4.1 ブランチ運用

- 作業は必ずブランチで行い、PRで `main` に入れます。

```bash
cd ~/tools-ai
git switch -c codex-cli-setup
```

### 4.2 policy-check を最初に回す

このリポジトリは `policy-check` をゲートにします。

```bash
cd ~/tools-ai
make policy-check 2>/dev/null || ./policy-check
```

---

## 5. Secrets を扱うときの決まり

- `.env` を作る場合は **Git管理外**にします。
- `.env` の値を **チャットに貼りません**。
- `git status -sb` で **意図しない追加ファイル**がないことを確認します。

推奨：`.env` は手入力か、パスワードマネージャから貼り付けます。

---

## 6. Codex CLI を repo 作業に使うときのコツ

### 6.1 まずは「読み取り専用」から始める

- いきなり書き換えさせず、最初は **状況把握（要約・観察）**に使います。

例：
- 変更点の説明（`git diff` の読み解き）
- policy-check の失敗理由の整理

### 6.2 変更は小さく刻み、必ず差分レビューする

- `git diff` を毎回見て、意図した差分だけにします。
- 1PR = 1目的 に寄せます。

---

## 7. PR 作成（gh CLI）

```bash
cd ~/tools-ai
gh pr create --fill
```

- merge は原則人間が行います（squash merge）。

---

## 8. トラブルシューティング

### 8.1 `codex` が見つからない

- `npm -g bin` が PATH に入っていない可能性があります。
- いったん新しいシェルを開き直してから再確認します。

### 8.2 貼り付けが壊れる

- 長文の貼り付けを避け、**python生成**に寄せます。
- どうしても貼る場合は短い塊に分割します。

---

## 9. 完了条件

- `codex --version` が表示されます。
- `policy-check` が通ります。
- PR が作られ、CIが通る状態になります。
