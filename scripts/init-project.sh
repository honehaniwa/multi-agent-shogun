#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════════
# init-project.sh - プロジェクト初期化スクリプト
# submodule導入後にプロジェクト固有の設定を生成する
# ═══════════════════════════════════════════════════════════════════════════════
#
# 使用方法:
#   ./.shogun/scripts/init-project.sh [オプション]
#
# オプション:
#   -n, --name NAME       プロジェクト名（必須）
#   -p, --path PATH       プロジェクトパス（デフォルト: ..）
#   -h, --help            ヘルプ表示

set -e

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SHOGUN_DIR="$(dirname "$SCRIPT_DIR")"

# デフォルト値
PROJECT_NAME=""
PROJECT_PATH=".."

# 色付きログ
log_info() {
    echo -e "\033[1;33m[INFO]\033[0m $1"
}

log_success() {
    echo -e "\033[1;32m[OK]\033[0m $1"
}

log_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
}

# オプション解析
while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--name)
            PROJECT_NAME="$2"
            shift 2
            ;;
        -p|--path)
            PROJECT_PATH="$2"
            shift 2
            ;;
        -h|--help)
            echo ""
            echo "🏯 multi-agent-shogun プロジェクト初期化スクリプト"
            echo ""
            echo "使用方法: ./scripts/init-project.sh [オプション]"
            echo ""
            echo "オプション:"
            echo "  -n, --name NAME   プロジェクト名（必須）"
            echo "  -p, --path PATH   プロジェクトパス（デフォルト: ..）"
            echo "  -h, --help        このヘルプを表示"
            echo ""
            echo "例:"
            echo "  ./scripts/init-project.sh -n myapp"
            echo "  ./scripts/init-project.sh -n myapp -p /path/to/project"
            echo ""
            exit 0
            ;;
        *)
            log_error "不明なオプション: $1"
            exit 1
            ;;
    esac
done

# プロジェクト名の確認
if [ -z "$PROJECT_NAME" ]; then
    log_error "プロジェクト名を指定してください: -n NAME"
    exit 1
fi

echo ""
echo "  ╔══════════════════════════════════════════════════════════════╗"
echo "  ║  🏯 multi-agent-shogun プロジェクト初期化                     ║"
echo "  ╚══════════════════════════════════════════════════════════════╝"
echo ""

log_info "プロジェクト名: $PROJECT_NAME"
log_info "プロジェクトパス: $PROJECT_PATH"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════
# 1. config/projects.yaml の生成
# ═══════════════════════════════════════════════════════════════════════════════
log_info "config/projects.yaml を生成中..."

cat > "$SHOGUN_DIR/config/projects.yaml" << EOF
# multi-agent-shogun プロジェクト設定
# 自動生成: $(date "+%Y-%m-%d %H:%M:%S")

projects:
  - id: ${PROJECT_NAME}
    name: "${PROJECT_NAME}"
    path: "${PROJECT_PATH}"
    priority: high
    status: active
    # notion_url: ""  # Notion連携する場合はURLを設定
    # github_repo: "" # GitHubリポジトリURL

current_project: ${PROJECT_NAME}
EOF

log_success "config/projects.yaml を生成しました"

# ═══════════════════════════════════════════════════════════════════════════════
# 2. context/{project}.md の生成
# ═══════════════════════════════════════════════════════════════════════════════
log_info "context/${PROJECT_NAME}.md を生成中..."

mkdir -p "$SHOGUN_DIR/context"

cat > "$SHOGUN_DIR/context/${PROJECT_NAME}.md" << EOF
# ${PROJECT_NAME} プロジェクトコンテキスト

> 生成日: $(date "+%Y-%m-%d")
> このファイルはプロジェクト固有の情報を記載する

## プロジェクト概要

<!-- プロジェクトの目的・概要を記載 -->

## 技術スタック

<!-- 使用している技術・フレームワークを記載 -->
- 言語:
- フレームワーク:
- データベース:
- その他:

## ディレクトリ構成

\`\`\`
${PROJECT_NAME}/
├── src/
├── tests/
└── ...
\`\`\`

## 重要なファイル

<!-- 頻繁に参照するファイルを記載 -->
- \`src/main.py\` - エントリーポイント
- \`config/\` - 設定ファイル

## コーディング規約

<!-- プロジェクト固有のルールを記載 -->

## 注意事項

<!-- エージェントが知っておくべき注意点を記載 -->
EOF

log_success "context/${PROJECT_NAME}.md を生成しました"

# ═══════════════════════════════════════════════════════════════════════════════
# 完了メッセージ
# ═══════════════════════════════════════════════════════════════════════════════
echo ""
echo "  ╔══════════════════════════════════════════════════════════════╗"
echo "  ║  ✅ プロジェクト初期化完了！                                  ║"
echo "  ╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "  生成されたファイル:"
echo "    - config/projects.yaml"
echo "    - context/${PROJECT_NAME}.md"
echo ""
echo "  次のステップ:"
echo "    1. context/${PROJECT_NAME}.md を編集してプロジェクト情報を記載"
echo "    2. 出陣: ./shutsujin_departure.sh -p ${PROJECT_NAME}"
echo ""
