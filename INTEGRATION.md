# multi-agent-shogun 統合ガイド

既存プロジェクトに multi-agent-shogun を導入するためのガイドです。

## クイックスタート（3コマンド）

```bash
# 1. submodule として追加
cd /path/to/your-project
git submodule add https://github.com/honehaniwa/multi-agent-shogun.git .shogun

# 2. 初回セットアップ
./.shogun/first_setup.sh

# 3. 出陣！
./.shogun/shutsujin_departure.sh -p your-project
```

## 詳細ガイド

### 1. 前提条件

以下がインストールされていることを確認してください：

| 必須 | バージョン | 確認コマンド |
|------|-----------|-------------|
| tmux | 2.0+ | `tmux -V` |
| Node.js | 18+ | `node -v` |
| Claude Code | 最新 | `claude --version` |

### 2. submodule として追加

```bash
cd /path/to/your-project
git submodule add https://github.com/honehaniwa/multi-agent-shogun.git .shogun
git commit -m "feat: add multi-agent-shogun as submodule"
```

### 3. 初回セットアップ

```bash
./.shogun/first_setup.sh
```

このスクリプトは以下を確認・設定します：
- tmux インストール確認
- Node.js バージョン確認
- Claude Code インストール確認
- 必要なディレクトリ構造の作成
- Gemini MCP（軍師）の設定確認

### 4. プロジェクト設定

#### config/projects.yaml の編集

```yaml
projects:
  - id: your_project
    name: "Your Project Name"
    path: ".."  # submoduleからの相対パス
    priority: high
    status: active

current_project: your_project
```

#### プロジェクトコンテキストの作成（オプション）

```bash
cp .shogun/templates/context_template.md .shogun/context/your_project.md
# 編集してプロジェクト固有の情報を記載
```

### 5. 出陣（起動）

```bash
# プロジェクト名を指定して起動
./.shogun/shutsujin_departure.sh -p your-project

# セッションにアタッチ
tmux attach-session -t shogun-your-project
```

## オプション

### 起動オプション

```bash
./.shogun/shutsujin_departure.sh [オプション]

オプション:
  -p, --project NAME  プロジェクト名を指定（セッション名に使用）
  -s, --setup-only    tmuxセットアップのみ（Claude起動なし）
  -t, --terminal      Windows Terminal でタブを開く
  -h, --help          ヘルプ表示
```

### 環境変数

| 変数 | 説明 | デフォルト |
|------|------|-----------|
| `SHOGUN_PROJECT_ROOT` | プロジェクトルートを明示的に指定 | 自動検出 |

## 複数プロジェクトの運用

異なるプロジェクトで同時に multi-agent-shogun を使用できます。

```bash
# プロジェクトA
cd /path/to/project-a
./.shogun/shutsujin_departure.sh -p project-a
# セッション名: shogun-project-a, multiagent-project-a

# プロジェクトB（別ターミナルで）
cd /path/to/project-b
./.shogun/shutsujin_departure.sh -p project-b
# セッション名: shogun-project-b, multiagent-project-b
```

### セッション一覧確認

```bash
tmux list-sessions
# 出力例:
# shogun-project-a: 1 windows
# multiagent-project-a: 1 windows
# shogun-project-b: 1 windows
# multiagent-project-b: 1 windows
```

## ディレクトリ構成

submodule導入後のプロジェクト構成：

```
your-project/
├── .git/
├── .gitmodules           # submodule設定
├── .shogun/              # multi-agent-shogun (submodule)
│   ├── CLAUDE.md
│   ├── config/
│   │   ├── settings.yaml
│   │   └── projects.yaml
│   ├── instructions/
│   │   ├── shogun.md
│   │   ├── karo.md
│   │   ├── ashigaru.md
│   │   └── gunshi.md
│   ├── queue/
│   ├── status/
│   ├── dashboard.md
│   ├── shutsujin_departure.sh
│   └── first_setup.sh
├── src/                  # あなたのプロジェクトコード
├── tests/
└── README.md
```

## submodule の更新

最新版に更新する場合：

```bash
cd .shogun
git pull origin main
cd ..
git add .shogun
git commit -m "chore: update multi-agent-shogun"
```

## クローン時の注意

submodule を含むリポジトリをクローンする場合：

```bash
# 方法1: クローン時に --recursive を指定
git clone --recursive https://github.com/your/project.git

# 方法2: クローン後に初期化
git clone https://github.com/your/project.git
cd project
git submodule update --init --recursive
```

## トラブルシューティング

### セッションが既に存在する

```bash
# 手動で削除
tmux kill-session -t shogun-your-project
tmux kill-session -t multiagent-your-project
```

### Node.js バージョンが古い

```bash
# n を使用してアップグレード
npm install -g n
export N_PREFIX="$HOME/.n"
n lts
export PATH="$HOME/.n/bin:$PATH"
```

### Gemini MCP（軍師）が動作しない

```bash
# MCP設定を確認
claude mcp list

# 再設定
claude mcp add gemini -s user -- env GEMINI_API_KEY=YOUR_KEY npx -y @rlabs-inc/gemini-mcp
```

## 関連ドキュメント

- [README.md](README.md) - プロジェクト概要
- [README_ja.md](README_ja.md) - 日本語説明
- [CLAUDE.md](CLAUDE.md) - システム構成・ルール
- [instructions/](instructions/) - 各エージェントの指示書
