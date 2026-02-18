# Codex MVP Guardrails 設定と運用

このRunbookは、Codex MVP用のガードレール設定を実装し、安全に運用するための手順を定義します。

---

## 0. 前提（このRunbookが守るルール）

- 正本（Source of Truth）は GitHub: `sty19jp-spec/tools-ai`
- `main` へ直pushしません。**PR = Pull Request（変更提案とレビューの単位）** 経由で入れます。
- **CI = Continuous Integration（自動検査）** を必須ゲートにします。
- **Secrets（Token / API Key / 秘密鍵）を絶対に扱いません**。Gitに入れません。チャットにも貼りません。
- `.env` は作成しません。

---

## 1. 対象環境

- Windows 11 + WSL2
- Ubuntu 24.04 LTS（想定）
- Codex CLI が導入済み（`codex --version` で確認）

---

## 2. 設定の構成

### 2.1 設定担保と運用担保の分離

- **設定担保（テンプレート）**: `runbooks/codex/config.toml.template`
  - Git管理下に置き、変更履歴を追跡します
  - Secretsを含みません
  - リポジトリの正本として機能します

- **運用担保（実体設定）**: `~/.codex/config.toml`
  - 各ユーザーのホームディレクトリに配置します
  - Git管理外です（`.gitignore` で除外）
  - テンプレートをコピーして作成します
  - 必要に応じてユーザー固有の設定を追加できます

### 2.2 必須要件

1. **approval_policy**: `"on-request"` に固定
   - すべての実行前に承認を要求します

2. **admin-enforced prefix_rules**: デフォルトブロック
   - `docker build`: ブロック
   - `docker run`: ブロック

3. **単一正本ディレクトリ**:
   - `/home/shun/outputs`: 出力ディレクトリ（Git追跡対象外）
   - `/home/shun/state`: 状態管理ディレクトリ（Git追跡対象外）

---

## 3. 設定手順

### 3.1 テンプレートの確認

```bash
cd ~/tools-ai
cat runbooks/codex/config.toml.template
```

### 3.2 実体設定ファイルの作成

```bash
# ~/.codex ディレクトリが存在しない場合は作成
mkdir -p ~/.codex

# テンプレートを実体設定ファイルにコピー
cp ~/tools-ai/runbooks/codex/config.toml.template ~/.codex/config.toml

# 設定ファイルの内容を確認
cat ~/.codex/config.toml
```

### 3.3 .gitignore の確認

以下のパスが `.gitignore` に含まれていることを確認します：

```
/home/shun/outputs
/home/shun/state
```

---

## 4. 検証手順と成功判定

### 4.1 設定ファイルの検証

```bash
# 設定ファイルが存在することを確認
test -f ~/.codex/config.toml && echo "OK: config.toml exists" || echo "NG: config.toml not found"

# 設定ファイルの内容を確認
codex config show 2>/dev/null || cat ~/.codex/config.toml
```

### 4.2 approval_policy の検証

```bash
# approval_policy が "on-request" であることを確認
grep -E '^approval_policy\s*=\s*"on-request"' ~/.codex/config.toml && echo "OK: approval_policy is on-request" || echo "NG: approval_policy mismatch"
```

### 4.3 prefix_rules の検証

```bash
# docker build がブロックされていることを確認
grep -A1 '"docker build"' ~/.codex/config.toml | grep -q 'action = "block"' && echo "OK: docker build is blocked" || echo "NG: docker build rule not found"

# docker run がブロックされていることを確認
grep -A1 '"docker run"' ~/.codex/config.toml | grep -q 'action = "block"' && echo "OK: docker run is blocked" || echo "NG: docker run rule not found"
```

### 4.4 ディレクトリの検証

```bash
# 出力ディレクトリがGit追跡対象外であることを確認
cd ~/tools-ai
git check-ignore /home/shun/outputs && echo "OK: outputs is ignored" || echo "NG: outputs is not ignored"

# 状態管理ディレクトリがGit追跡対象外であることを確認
git check-ignore /home/shun/state && echo "OK: state is ignored" || echo "NG: state is not ignored"
```

### 4.5 成功判定

以下のすべてが満たされた場合、設定は成功です：

- [ ] `~/.codex/config.toml` が存在する
- [ ] `approval_policy = "on-request"` が設定されている
- [ ] `docker build` がブロックされている
- [ ] `docker run` がブロックされている
- [ ] `/home/shun/outputs` が `.gitignore` に含まれている
- [ ] `/home/shun/state` が `.gitignore` に含まれている

---

## 5. 運用

### 5.1 Codex の起動

```bash
codex
```

### 5.2 停止方法

Codex を停止するには、以下のいずれかの方法を使用します：

- **Ctrl+C**: 実行中のコマンドを中断
- **/exit**: Codex セッションを終了（対話モードの場合）

### 5.3 設定の更新

設定を変更する場合は：

1. `runbooks/codex/config.toml.template` を編集（PR経由）
2. マージ後、`~/.codex/config.toml` を手動で更新

---

## 6. トラブルシューティング

### 6.1 設定ファイルが見つからない

```bash
# ディレクトリが存在するか確認
ls -la ~/.codex

# テンプレートから再作成
cp ~/tools-ai/runbooks/codex/config.toml.template ~/.codex/config.toml
```

### 6.2 設定が反映されない

```bash
# Codex を再起動
# 設定ファイルの構文を確認（TOML形式）
cat ~/.codex/config.toml
```

### 6.3 ディレクトリがGit追跡されている

```bash
# .gitignore を確認
cd ~/tools-ai
cat .gitignore | grep -E "(outputs|state)"

# 既に追跡されている場合は削除（注意: ファイルは残ります）
git rm --cached /home/shun/outputs/* 2>/dev/null || true
git rm --cached /home/shun/state/* 2>/dev/null || true
```

---

## 7. 完了条件

- [ ] `runbooks/codex/config.toml.template` が存在する
- [ ] `~/.codex/config.toml` が作成されている
- [ ] `.gitignore` に `/home/shun/outputs` と `/home/shun/state` が追加されている
- [ ] 検証手順がすべて成功する
- [ ] `policy-check` が通る
- [ ] PR が作られ、CIが通る状態になる

---

## 8. 注意事項

- **Secrets は絶対に扱いません**
- `.env` ファイルは作成しません
- 実体設定ファイル（`~/.codex/config.toml`）は Git 管理外です
- テンプレートファイル（`runbooks/codex/config.toml.template`）のみ Git 管理下です
