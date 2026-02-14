# Codex CLI 導入手順

## 目的
WSL (Ubuntu) 上に OpenAI Codex CLI を npm 経由で導入し、`codex --version` が表示される状態へする。

## 前提
- Ubuntu 24.04 (WSL2) が稼働している
- GitHub repo `tools-ai` がクローン済み
- ブランチは `codex-cli-setup`

## 手順

1. 前提ツールの導入（curl/git/build-essential）
    ```bash
    sudo apt update && sudo apt install -y curl ca-certificates git build-essential
    ```

2. nvm の導入
    ```bash
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    ```

3. Node LTS のインストール
    ```bash
    nvm install --lts
    nvm alias default 'lts/*'
    node -v
    npm -v
    ```

4. Codex CLI のインストール
    ```bash
    npm install -g @openai/codex
    codex --version
    ```

## 検証
- `codex --version` がバージョンを返すこと
- `codex --help` でヘルプが表示されること

## 想定エラー
- `EACCES` エラー → nvm 経由の npm であるか確認
- `codex: command not found` → グローバルパスの確認
