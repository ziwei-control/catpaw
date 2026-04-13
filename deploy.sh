#!/bin/bash
# CatPaw 一键部署脚本
# 从 GitHub 或 Gitee 克隆并自动部署启动

set -e

echo ""
echo "╔═══════════════════════════════════════╗"
echo "║     CatPaw 一键部署脚本            ║"
echo "║     Markdown is the Soul              ║"
echo "╚═══════════════════════════════════════╝"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
INSTALL_DIR="${INSTALL_DIR:-/home/admin/projects/catpaw}"
REPO_SOURCE="${REPO_SOURCE:-github}"  # github 或 gitee
GITHUB_REPO="https://github.com/ziwei-control/catpaw.git"
GITEE_REPO="https://gitee.com/pandac0/catpaw.git"
PYTHON_CMD="${PYTHON_CMD:-python3}"
PIP_CMD="${PIP_CMD:-pip3}"

# 日志函数
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

# 检查是否以 root 运行
check_root() {
    if [ "$EUID" -eq 0 ]; then
        log_warning "不建议使用 root 用户运行，建议使用普通用户"
    fi
}

# 检查系统要求
check_requirements() {
    log_info "检查系统要求..."
    
    # 检查 Python
    if ! command -v $PYTHON_CMD &> /dev/null; then
        log_error "Python 3 未安装"
        log_info "安装命令:"
        echo "  Ubuntu/Debian: sudo apt install python3 python3-pip"
        echo "  CentOS/RHEL: sudo yum install python3 python3-pip"
        exit 1
    fi
    
    PYTHON_VERSION=$($PYTHON_CMD --version 2>&1 | awk '{print $2}')
    log_success "Python $PYTHON_VERSION 已安装"
    
    # 检查 Git
    if ! command -v git &> /dev/null; then
        log_error "Git 未安装"
        log_info "安装命令:"
        echo "  Ubuntu/Debian: sudo apt install git"
        echo "  CentOS/RHEL: sudo yum install git"
        exit 1
    fi
    
    log_success "Git 已安装"
    
    # 检查 pip
    if ! command -v $PIP_CMD &> /dev/null; then
        log_error "pip 未安装"
        log_info "安装命令:"
        echo "  Ubuntu/Debian: sudo apt install python3-pip"
        echo "  CentOS/RHEL: sudo yum install python3-pip"
        exit 1
    fi
    
    log_success "pip 已安装"
}

# 选择仓库源
select_repo() {
    echo ""
    echo "选择代码源:"
    echo "  1) GitHub (推荐，海外用户)"
    echo "  2) Gitee (推荐，国内用户)"
    echo "  3) 本地目录 (已下载)"
    echo ""
    
    if [ -n "$REPO_SOURCE" ]; then
        choice="$REPO_SOURCE"
    else
        read -p "请选择 (1/2/3): " choice
    fi
    
    case $choice in
        1|github)
            REPO_URL="$GITHUB_REPO"
            log_info "使用 GitHub 仓库"
            ;;
        2|gitee)
            REPO_URL="$GITEE_REPO"
            log_info "使用 Gitee 仓库"
            ;;
        3|local)
            log_info "使用本地目录"
            return 0
            ;;
        *)
            log_error "无效选择"
            exit 1
            ;;
    esac
}

# 克隆或更新仓库
clone_or_update() {
    echo ""
    log_info "准备代码..."
    
    if [ -d "$INSTALL_DIR/.git" ]; then
        log_info "检测到已有仓库，执行更新..."
        cd "$INSTALL_DIR"
        git fetch --all
        git reset --hard origin/main
        git pull
        log_success "代码已更新"
    elif [ -d "$INSTALL_DIR" ]; then
        log_warning "目录已存在但非 Git 仓库"
        read -p "是否覆盖？(y/n): " confirm
        if [ "$confirm" = "y" ]; then
            rm -rf "$INSTALL_DIR"
            git clone "$REPO_URL" "$INSTALL_DIR"
            log_success "代码已克隆"
        else
            log_info "取消部署"
            exit 0
        fi
    else
        git clone "$REPO_URL" "$INSTALL_DIR"
        log_success "代码已克隆到 $INSTALL_DIR"
    fi
    
    cd "$INSTALL_DIR"
}

# 创建虚拟环境 (可选)
setup_venv() {
    echo ""
    log_info "配置 Python 环境..."
    
    read -p "是否创建虚拟环境？(推荐，y/n): " create_venv
    
    if [ "$create_venv" = "y" ]; then
        if [ ! -d "venv" ]; then
            $PYTHON_CMD -m venv venv
            log_success "虚拟环境已创建"
        fi
        
        # 激活虚拟环境
        source venv/bin/activate
        PIP_CMD="pip"
        PYTHON_CMD="python"
        log_success "虚拟环境已激活"
    else
        log_info "使用系统 Python 环境"
    fi
}

# 安装依赖
install_dependencies() {
    echo ""
    log_info "安装依赖..."
    
    # 升级 pip
    $PIP_CMD install --upgrade pip -q
    
    # 安装 requirements
    if [ -f "requirements.txt" ]; then
        $PIP_CMD install -r requirements.txt
        log_success "依赖已安装"
    else
        # 安装基本依赖
        $PIP_CMD install flask flask-cors requests -q
        log_success "基本依赖已安装"
    fi
}

# 配置 LLM
configure_llm() {
    echo ""
    log_info "配置 LLM..."
    
    CONFIG_FILE=~/.catpaw/llm_config.json
    
    if [ -f "$CONFIG_FILE" ]; then
        log_success "LLM 配置已存在"
        cat "$CONFIG_FILE"
        
        read -p "是否重新配置？(y/n): " reconfigure
        if [ "$reconfigure" != "y" ]; then
            return 0
        fi
    fi
    
    echo ""
    echo "选择云模型提供商:"
    echo "  1) Kimi (月之暗面) - 推荐"
    echo "  2) Qwen (通义千问)"
    echo "  3) DeepSeek"
    echo "  4) OpenAI"
    echo "  5) 跳过 (稍后配置)"
    echo ""
    
    read -p "请选择 (1-5): " provider_choice
    
    case $provider_choice in
        1)
            PROVIDER="moonshot"
            BASE_URL="https://api.moonshot.cn/v1"
            MODEL="kimi-latest"
            ;;
        2)
            PROVIDER="dashscope"
            BASE_URL="https://dashscope.aliyuncs.com/compatible-mode/v1"
            MODEL="qwen-max"
            ;;
        3)
            PROVIDER="deepseek"
            BASE_URL="https://api.deepseek.com/v1"
            MODEL="deepseek-chat"
            ;;
        4)
            PROVIDER="openai"
            BASE_URL="https://api.openai.com/v1"
            MODEL="gpt-3.5-turbo"
            ;;
        5)
            log_info "跳过 LLM 配置"
            return 0
            ;;
        *)
            log_error "无效选择"
            return 0
            ;;
    esac
    
    read -p "输入 API Key: " API_KEY
    
    if [ -z "$API_KEY" ]; then
        log_warning "API Key 为空，跳过配置"
        return 0
    fi
    
    # 创建配置目录
    mkdir -p ~/.catpaw
    
    # 写入配置
    cat > "$CONFIG_FILE" << EOF
{
  "_comment": "CatPaw LLM 配置 - 自动部署",
  "_docs": "详见 /home/admin/projects/catpaw/COMPLETE_GUIDE.md",
  "provider": "$PROVIDER",
  "api_key": "$API_KEY",
  "base_url": "$BASE_URL",
  "model": "$MODEL",
  "temperature": 0.7,
  "max_tokens": 4096,
  "timeout": 60
}
EOF
    
    log_success "LLM 配置已保存"
}

# 配置防火墙
setup_firewall() {
    echo ""
    log_info "配置防火墙..."
    
    # 检查 firewalld
    if command -v firewall-cmd &> /dev/null; then
        if sudo firewall-cmd --state 2>/dev/null | grep -q "running"; then
            sudo firewall-cmd --permanent --add-port=6767/tcp 2>/dev/null || true
            sudo firewall-cmd --reload 2>/dev/null || true
            log_success "firewalld 端口已开放"
        fi
    fi
    
    # 检查 ufw
    if command -v ufw &> /dev/null; then
        if sudo ufw status 2>/dev/null | grep -q "Status: active"; then
            sudo ufw allow 6767/tcp 2>/dev/null || true
            log_success "ufw 端口已开放"
        fi
    fi
    
    log_info "请确保云服务器安全组已开放 6767 端口"
}

# 配置系统服务 (systemd)
setup_systemd() {
    echo ""
    log_info "配置系统服务..."
    
    read -p "是否配置开机自启？(y/n): " setup_service
    
    if [ "$setup_service" != "y" ]; then
        return 0
    fi
    
    # 创建服务文件
    SERVICE_FILE="/etc/systemd/system/catpaw.service"
    
    sudo cat > "$SERVICE_FILE" << EOF
[Unit]
Description=CatPaw Web Service
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$INSTALL_DIR
ExecStart=$INSTALL_DIR/venv/bin/python3 $INSTALL_DIR/web_server.py --port 6767
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
    
    # 重载 systemd
    sudo systemctl daemon-reload
    
    # 启用服务
    sudo systemctl enable catpaw.service
    
    # 启动服务
    sudo systemctl start catpaw.service
    
    log_success "系统服务已配置"
    log_info "服务状态：systemctl status catpaw"
    log_info "启动服务：sudo systemctl start catpaw"
    log_info "停止服务：sudo systemctl stop catpaw"
}

# 启动服务
start_service() {
    echo ""
    log_info "启动服务..."
    
    cd "$INSTALL_DIR"
    
    # 检查是否使用 systemd
    if sudo systemctl is-active --quiet catpaw.service 2>/dev/null; then
        log_success "服务已通过 systemd 启动"
        sudo systemctl restart catpaw.service
    else
        # 手动启动
        if [ -d "venv" ]; then
            source venv/bin/activate
        fi
        
        nohup $PYTHON_CMD web_server.py --port 6767 > logs/web.log 2>&1 &
        sleep 2
        
        if pgrep -f "web_server.py.*6767" > /dev/null; then
            log_success "服务已启动 (PID: $(pgrep -f 'web_server.py.*6767'))"
        else
            log_error "服务启动失败，查看日志：tail -f logs/web.log"
        fi
    fi
}

# 显示完成信息
show_complete() {
    echo ""
    echo "╔═══════════════════════════════════════╗"
    echo "║        部署完成！                     ║"
    echo "╚═══════════════════════════════════════╝"
    echo ""
    
    # 获取 IP
    LOCAL_IP=$(hostname -I | awk '{print $1}')
    PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null || echo "你的公网IP")
    
    echo "📍 安装目录：$INSTALL_DIR"
    echo ""
    echo "🌐 访问地址:"
    echo "   本地：http://localhost:6767"
    echo "   局域网：http://$LOCAL_IP:6767"
    echo "   公网：http://$PUBLIC_IP:6767"
    echo ""
    echo "🔧 常用命令:"
    echo "   启动：cd $INSTALL_DIR && ./start.sh"
    echo "   停止：cd $INSTALL_DIR && ./stop.sh"
    echo "   日志：tail -f $INSTALL_DIR/logs/web.log"
    echo "   更新：cd $INSTALL_DIR && ./update.sh"
    echo ""
    
    if sudo systemctl is-active --quiet catpaw.service 2>/dev/null; then
        echo "🔧 系统服务命令:"
        echo "   启动：sudo systemctl start catpaw"
        echo "   停止：sudo systemctl stop catpaw"
        echo "   重启：sudo systemctl restart catpaw"
        echo "   状态：sudo systemctl status catpaw"
        echo "   日志：sudo journalctl -u catpaw -f"
        echo ""
    fi
    
    echo "📚 文档:"
    echo "   $INSTALL_DIR/README.md"
    echo "   $INSTALL_DIR/QUICKSTART.md"
    echo ""
    echo "🎉 祝你使用愉快！"
    echo ""
}

# 主函数
main() {
    check_root
    check_requirements
    select_repo
    clone_or_update
    setup_venv
    install_dependencies
    configure_llm
    setup_firewall
    setup_systemd
    start_service
    show_complete
}

# 运行
main "$@"
