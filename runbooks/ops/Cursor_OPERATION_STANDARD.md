# Cursor_OPERATION_STANDARD.md

## 1. 目的

本標準は、Cursorを実装主体として安全・再現可能に運用するための最低限の統一ルールを定める。

正本は GitHub: sty19jp-spec/tools-ai とする。
ChatGPT内の生成物は正本としない。

---

## 2. 実行体制（責務分離）

- 実装主体：Cursor
- 設計判断・監査：ChatGPT
- 実行真実：WSLターミナル出力
- Gitの真実：`git status` および `git --no-pager diff`

Cursorは実装を行うが、最終判断は人間が行う。

---

## 3. 指示方式テンプレ（日本語固定）

Cursorへの指示は必ず以下形式で行う。

目的：
制約：
変更対象：
変更禁止：
参考コマンド：
成功判定条件：

曖昧な指示は禁止する。

---

## 4. 実行原則

### 4.1 1ステップ＝1コマンド

複数コマンドをまとめて実行しない。
1コマンドごとに結果を確認する。

### 4.2 差分確認

差分確認は必ず以下を使用する。

git --no-pager diff

pager付きのdiffは禁止する。

---

## 5. 環境遷移ルール

PowerShell → WSL へ移行する場合は必ず明示する。

wsl

環境を仮定してはいけない。

---

## 6. 停止・中断方法

実行中プロセス停止：
Ctrl+C

Codex CLI終了：
/exit

停止方法を曖昧にしない。

---

## 7. 禁止事項

- SecretsをGitへコミットしない
- Secretsをチャットへ貼らない
- .envを作成しない
- 関係ないファイルを変更しない
- mainへ直接pushしない

---

## 8. 失敗時の戻し方

変更前状態を確認する。

git status
git --no-pager diff

不要変更がある場合は破棄する。

git restore .

未追跡ファイルを削除する場合：

git clean -fd

---

## 9. 並列作業との関係

Parallel Development Standardに従う。

- main直作業禁止
- 作業はブランチで行う
- PR経由でmainへ統合する

---

## 10. 原則

最終目標は「Mergeボタンだけ押す」運用の確立である。
