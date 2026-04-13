#!/bin/bash
# CatPaw 推送到 GitHub 和 Gitee

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "======================================"
echo "🚀 CatPaw 推送到 GitHub & Gitee"
echo "======================================"
echo ""

# 检查是否有 git
if ! command -v git &> /dev/null; then
    echo "❌ 错误：需要安装 git"
    exit 1
fi

# 检查是否已提交
if ! git rev-parse HEAD &> /dev/null; then
    echo "❌ 错误：请先提交代码"
    echo "   git add ."
    echo "   git commit -m 'commit message'"
    exit 1
fi

echo "📋 当前分支：$(git branch --show-current)"
echo "📋 最新提交：$(git log --oneline -1)"
echo ""

# GitHub 配置
GITHUB_USER="${GITHUB_USER:-admin}"
GITHUB_REPO="${GITHUB_REPO:-catpaw}"
GITHUB_URL="git@github.com:${GITHUB_USER}/${GITHUB_REPO}.git"

# Gitee 配置
GITEE_USER="${GITEE_USER:-admin}"
GITEE_REPO="${GITEE_REPO:-catpaw}"
GITEE_URL="git@gitee.com:${GITEE_USER}/${GITEE_REPO}.git"

echo "======================================"
echo "📍 GitHub 配置"
echo "======================================"
echo "   用户：$GITHUB_USER"
echo "   仓库：$GITHUB_REPO"
echo "   URL: $GITHUB_URL"
echo ""

echo "======================================"
echo "📍 Gitee 配置"
echo "======================================"
echo "   用户：$GITEE_USER"
echo "   仓库：$GITEE_REPO"
echo "   URL: $GITEE_URL"
echo ""

# 询问是否继续
read -p "是否继续推送？(y/n): " choice

if [ "$choice" != "y" ]; then
    echo "❌ 取消推送"
    exit 0
fi

echo ""
echo "======================================"
echo "⚠️  重要提示"
echo "======================================"
echo ""
echo "在推送之前，请确保："
echo ""
echo "1. 已在 GitHub 创建仓库："
echo "   https://github.com/new"
echo "   仓库名：$GITHUB_REPO"
echo ""
echo "2. 已在 Gitee 创建仓库："
echo "   https://gitee.com/new"
echo "   仓库名：$GITEE_REPO"
echo ""
echo "3. 已配置 SSH Key："
echo "   - GitHub: https://github.com/settings/keys"
echo "   - Gitee: https://gitee.com/profile/sshkeys"
echo ""

read -p "是否已完成上述配置？(y/n): " choice

if [ "$choice" != "y" ]; then
    echo ""
    echo "💡 查看配置指南："
    echo "   cat PUSH_TO_GITHUB_GITEE.md"
    exit 0
fi

# 添加远程仓库
echo ""
echo "======================================"
echo "🔗 配置远程仓库"
echo "======================================"
echo ""

# 检查是否已存在远程
if git remote | grep -q "origin"; then
    echo "⚠️  origin 已存在，更新..."
    git remote set-url origin $GITHUB_URL
else
    echo "✅ 添加 GitHub 远程..."
    git remote add origin $GITHUB_URL
fi

if git remote | grep -q "gitee"; then
    echo "⚠️  gitee 已存在，更新..."
    git remote set-url gitee $GITEE_URL
else
    echo "✅ 添加 Gitee 远程..."
    git remote add gitee $GITEE_URL
fi

echo ""
echo "远程仓库列表:"
git remote -v
echo ""

# 推送到 GitHub
echo "======================================"
echo "🚀 推送到 GitHub"
echo "======================================"
echo ""

git push -u origin main --force

if [ $? -eq 0 ]; then
    echo "✅ GitHub 推送成功!"
    echo "   访问：https://github.com/${GITHUB_USER}/${GITHUB_REPO}"
else
    echo "❌ GitHub 推送失败"
fi

echo ""

# 推送到 Gitee
echo "======================================"
echo "🚀 推送到 Gitee"
echo "======================================"
echo ""

git push -u gitee main --force

if [ $? -eq 0 ]; then
    echo "✅ Gitee 推送成功!"
    echo "   访问：https://gitee.com/${GITEE_USER}/${GITEE_REPO}"
else
    echo "❌ Gitee 推送失败"
fi

echo ""
echo "======================================"
echo "✅ 完成!"
echo "======================================"
echo ""
echo "📍 GitHub: https://github.com/${GITHUB_USER}/${GITHUB_REPO}"
echo "📍 Gitee: https://gitee.com/${GITEE_USER}/${GITEE_REPO}"
echo ""
