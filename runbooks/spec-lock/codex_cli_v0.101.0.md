# Codex CLI Spec Lock  
## Version: v0.101.0 (research preview)

---

## 1. Scope

本 Spec Lock は codex-cli v0.101.0（research preview）における以下を固定します。

- config キー名
- 配置パス
- 許容値
- 設定レイヤと優先順位
- preview / experimental 扱い
- 既知の制限事項（仕様ではなく注意情報として明示）

設計判断（A/B/D選択）は含めません。

---

## 2. Official Sources（一次情報）

本 Spec は以下を優先根拠として参照します。

- OpenAI Codex CLI 公式Docs（Configuration / Sandbox）
- openai/codex 公式GitHub
- Release: rust-v0.101.0
- 公式Issue（仕様根拠ではなく Known Issues として扱う）

---

## 3. Configuration Layers（責務固定）

### 3.1 User Config

| 項目 | 内容 |
|------|------|
| パス | `~/.codex/config.toml` |
| 役割 | approval / sandbox の基本制御 |
| 強制力 | 低 |
| 備考 | 上位レイヤにより上書きされる可能性があります |

---

### 3.2 User Rules

| 項目 | 内容 |
|------|------|
| パス | `~/.codex/rules/*.rules` |
| 記法 | Starlark |
| decision | allow / prompt / forbidden |
| 役割 | コマンド単位の実行制御 |

`.rules` ファイルは Starlark ベースで `prefix_rule()` 等を定義できます。

---

### 3.3 Managed / Admin Layer

| 項目 | 内容 |
|------|------|
| managed_config.toml | `/etc/codex/managed_config.toml` |
| requirements.toml | `/etc/codex/requirements.toml` |
| 強制力 | 高 |
| 上書き可否 | ユーザー設定より優先します |

※ `requirements.toml` に `prefix_rules` が存在する可能性はありますが、v0.101.0 の公式一次情報で完全確定できないため「未確定」とします。

---

## 4. Key Freeze（キー固定）

### 4.1 approval_policy

| Key | `approval_policy` |
|-----|------------------|
| 設置場所 | config.toml |
| 役割 | コマンド実行前の承認動作を制御します |

#### 確認できる値（公式Docs例）
- `untrusted`
- `on-request`
- `never`

※ `on-failure` は deprecated とされる事例があります。  
※ 値が反映されない報告があるため、Known Limitations を参照します。

---

### 4.2 sandbox_mode

| Key | `sandbox_mode` |
|-----|---------------|
| 設置場所 | config.toml |

#### 確認できる値
- `read-only`
- `workspace-write`
- `danger-full-access`

---

### 4.3 workspace-write 追加設定（例）

```toml
[sandbox_workspace_write]
network_access = true/false
```

---

## 5. prefix_rules 仕様凍結

### 5.1 config.toml 内の prefix_rules

公式Docsで確認できません。  
よって **config.toml に prefix_rules を書く設計は仕様外**とします。

---

### 5.2 .rules 内の prefix_rule()

Starlark形式で記述できます。

例（形式例のみ）：

```starlark
prefix_rule("docker build", decision="forbidden")
```

---

### 5.3 admin_enforced キー

公式Docsで確認できません。  
よって **存在未確認として使用禁止**とします。

---

## 6. Precedence（優先順位固定）

強 → 弱

1. managed_config（MDM等を含む管理層）
2. requirements.toml（管理層）
3. user config.toml
4. CLI flags

project-local `.codex/config.toml` は公式一次情報で保証を確認できないため **非保証（仕様外扱い）**とします。

---

## 7. Known Limitations（既知の制限：仕様ではなく注意）

- `sandbox_mode` が反映されないケースがあります
- `approval_policy` が無視されるケースがあります
- file-edit / MCP 実行時に sandbox 制御が期待通りに働かない報告があります

これらは research preview 由来の可能性があります。

---

## 8. Non-Confirmed Items（未確定）

- `admin_enforced` の存在
- project-local config の正式サポート
- `prefix_rules` の requirements.toml 内正式記法
- CLI が内部で approval を上書きする条件

---

## 9. Verification Plan（WSL）

```bash
codex --version
codex exec "echo test"
```

ヘッダ表示で approval / sandbox を確認します。

---

# End of Spec Lock v0.101.0
