#!/bin/bash
# CatPaw 安装脚本测试

set -e

echo "======================================"
echo "🧪 CatPaw 安装脚本测试"
echo "======================================"
echo ""

cd /root/.copaw/workspaces/default/catpaw

# 测试 1: 语法检查
echo "测试 1: 语法检查..."
bash -n install.sh
echo "✅ 语法检查通过"
echo ""

# 测试 2: 检查系统要求
echo "测试 2: 检查系统要求..."
python3 --version
pip3 --version
git --version
curl --version | head -1
echo "✅ 系统要求检查通过"
echo ""

# 测试 3: 检查配置文件模板
echo "测试 3: 检查配置文件..."
if [ -f "llm_config.example.json" ]; then
    echo "✅ LLM 配置示例存在"
    cat llm_config.example.json
else
    echo "⚠️  LLM 配置示例不存在"
fi
echo ""

# 测试 4: 检查依赖文件
echo "测试 4: 检查依赖文件..."
if [ -f "requirements.txt" ]; then
    echo "✅ requirements.txt 存在"
    cat requirements.txt
else
    echo "ℹ️  无 requirements.txt，使用基本依赖"
fi
echo ""

# 测试 5: 检查启动脚本
echo "测试 5: 检查启动脚本..."
ls -la setup_and_start.sh start.sh start_web.sh 2>/dev/null || echo "⚠️  部分启动脚本不存在"
echo ""

# 测试 6: 检查文档
echo "测试 6: 检查文档..."
ls -la QUICKSTART.md INSTALL_GUIDE.md README.md 2>/dev/null || echo "⚠️  部分文档不存在"
echo ""

# 测试 7: 模拟创建配置目录
echo "测试 7: 测试配置目录创建..."
TEST_CONFIG_DIR=~/.catpaw_test_$$
mkdir -p "$TEST_CONFIG_DIR"
echo '{"test": true}' > "$TEST_CONFIG_DIR/llm_config.json"
if [ -f "$TEST_CONFIG_DIR/llm_config.json" ]; then
    echo "✅ 配置目录创建成功"
    cat "$TEST_CONFIG_DIR/llm_config.json"
    rm -rf "$TEST_CONFIG_DIR"
    echo "✅ 测试目录已清理"
else
    echo "❌ 配置目录创建失败"
fi
echo ""

# 测试 8: 检查 Python 脚本
echo "测试 8: 检查 Python 脚本..."
if [ -f "catpaw.py" ]; then
    python3 -m py_compile catpaw.py && echo "✅ catpaw.py 语法正确"
else
    echo "⚠️  catpaw.py 不存在"
fi

if [ -f "configure_llm.py" ]; then
    python3 -m py_compile configure_llm.py && echo "✅ configure_llm.py 语法正确"
else
    echo "⚠️  configure_llm.py 不存在"
fi
echo ""

echo "======================================"
echo "✅ 所有测试完成！"
echo "======================================"
