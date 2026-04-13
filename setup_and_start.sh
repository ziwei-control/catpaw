#!/bin/bash
# CatPaw 快速配置脚本
# 一键配置云模型并启动

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "======================================"
echo "🤖 CatPaw 快速配置"
echo "======================================"
echo ""

# 检查 LLM 配置
CONFIG_FILE=~/.catpaw/llm_config.json

if [ ! -f "$CONFIG_FILE" ]; then
    echo "⚠️  未检测到 LLM 配置"
    echo ""
    echo "请选择配置方式:"
    echo ""
    echo "  1. 交互式配置 (推荐)"
    echo "     python3 configure_llm.py"
    echo ""
    echo "  2. 手动编辑配置"
    echo "     vim ~/.catpaw/llm_config.json"
    echo ""
    echo "  3. 查看配置指南"
    echo "     cat CLOUD_MODEL_SETUP.md"
    echo ""
    read -p "是否启动配置向导？(y/n): " choice
    
    if [ "$choice" = "y" ]; then
        python3 configure_llm.py
    else
        echo ""
        echo "💡 提示：配置完成后运行 ./start.sh 启动"
        exit 0
    fi
else
    echo "✅ 检测到 LLM 配置"
    python3 catpaw.py configure
    echo ""
    read -p "是否修改配置？(y/n): " choice
    
    if [ "$choice" = "y" ]; then
        python3 configure_llm.py
    fi
fi

echo ""
echo "======================================"
echo "🚀 启动 CatPaw"
echo "======================================"
echo ""

python3 catpaw.py cli
