#!/bin/bash
# CatPaw 一键更新脚本

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo ""
echo "╔═══════════════════════════════════════╗"
echo "║     CatPaw 一键更新脚本            ║"
echo "╚═══════════════════════════════════════╝"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查 Git 仓库
if [ ! -d ".git" ]; then
    log_error "当前目录不是 Git 仓库"
    exit 1
fi

# 获取远程仓库
REMOTE=$(git remote | grep -E "origin|gitee" | head -1)
if [ -z "$REMOTE" ]; then
    log_error "未找到远程仓库"
    exit 1
fi

log_info "使用远程仓库：$REMOTE"

# 停止服务
log_info "停止服务..."
./stop.sh 2>/dev/null || pkill -f "web_server.py.*6767" || true
sleep 1

# 拉取更新
log_info "拉取更新..."
git fetch $REMOTE main

# 查看是否有更新
LOCAL=$(git rev-parse HEAD)
REMOTE_COMMIT=$($REMOTE/main)

if [ "$LOCAL" == "$REMOTE_COMMIT" ]; then
    log_success "已是最新版本"
else
    log_info "发现新版本，开始更新..."
    
    # 备份配置
    log_info "备份配置..."
    if [ -d "workspace" ]; then
        cp -r workspace workspace.backup.$(date +%Y%m%d%H%M%S)
    fi
    
    # 拉取更新
    git pull $REMOTE main
    
    log_success "代码已更新"
    
    # 检查依赖更新
    if [ -f "requirements.txt" ]; then
        log_info "检查依赖..."
        
        if [ -d "venv" ]; then
            source venv/bin/activate
            pip install -r requirements.txt -q
        else
            pip3 install -r requirements.txt -q
        fi
        
        log_success "依赖已更新"
    fi
    
    # 恢复配置
    if [ -d "workspace.backup."* ]; then
        log_info "恢复配置..."
        BACKUP_DIR=$(ls -d workspace.backup.* | tail -1)
        if [ -d "$BACKUP_DIR" ]; then
            cp -r $BACKUP_DIR/* workspace/ 2>/dev/null || true
            rm -rf $BACKUP_DIR
        fi
        log_success "配置已恢复"
    fi
fi

# 重启服务
log_info "重启服务..."
./start.sh

echo ""
log_success "更新完成！"
echo ""

# 显示版本信息
if [ -f "VERSION" ]; then
    log_info "当前版本：$(cat VERSION)"
fi

echo ""
echo "🌐 访问地址：http://localhost:6767"
echo ""
