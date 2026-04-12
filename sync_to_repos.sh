#!/bin/bash
# OpenTalon GitHub/Gitee 同步脚本
# 使用方法：./sync_to_repos.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "======================================"
echo "🚀 OpenTalon 代码同步"
echo "======================================"
echo ""

# 配置 Git 用户信息
echo "📝 配置 Git 用户信息..."
git config user.email "admin@opentalon.local"
git config user.name "OpenTalon Admin"

# 检查是否有未提交的更改
if ! git diff --cached --quiet || ! git diff --quiet; then
    echo "⚠️  检测到未提交的更改"
    read -p "是否提交当前更改？(y/n): " choice
    if [ "$choice" = "y" ]; then
        git add .
        git commit -m "Update: $(date '+%Y-%m-%d %H:%M')"
    fi
fi

# 检查是否已初始化
if [ ! -d ".git" ]; then
    echo "📦 初始化 Git 仓库..."
    git init
    git branch -m main
    git add .
    git commit -m "Initial commit: OpenTalon v0.3.0"
fi

echo ""
echo "======================================"
echo "📍 远程仓库配置"
echo "======================================"
echo ""
echo "请在 GitHub 和 Gitee 创建新仓库，然后输入仓库地址："
echo ""
echo "💡 建议仓库名称:"
echo "   - GitHub: opentalon-python 或 opentalon-md"
echo "   - Gitee:  opentalon-python 或 opentalon-md"
echo "   (避免与官方 opentalon/opentalon 冲突)"
echo ""

read -p "GitHub 仓库地址 (如：https://github.com/yourname/opentalon-python.git): " GITHUB_URL
read -p "Gitee 仓库地址 (如：https://gitee.com/yourname/opentalon-python.git): " GITEE_URL

echo ""
echo "🔗 配置远程仓库..."

# 添加或更新 GitHub 远程
if git remote | grep -q "^github$"; then
    git remote set-url github "$GITHUB_URL"
else
    git remote add github "$GITHUB_URL"
fi

# 添加或更新 Gitee 远程
if git remote | grep -q "^gitee$"; then
    git remote set-url gitee "$GITEE_URL"
else
    git remote add gitee "$GITEE_URL"
fi

echo "✅ GitHub 远程：$GITHUB_URL"
echo "✅ Gitee 远程：$GITEE_URL"

echo ""
echo "📤 推送到 GitHub..."
git push -u github main --force

echo ""
echo "📤 推送到 Gitee..."
git push -u gitee main --force

echo ""
echo "======================================"
echo "✅ 同步完成!"
echo "======================================"
echo ""
echo "📍 仓库地址:"
echo "   GitHub: $GITHUB_URL"
echo "   Gitee:  $GITEE_URL"
echo ""
echo "💡 后续同步只需运行:"
echo "   git push github main"
echo "   git push gitee main"
echo ""
