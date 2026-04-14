#!/bin/bash
# CatPaw 一键安装脚本
# 使用方法：curl -fsSL https://raw.githubusercontent.com/your-repo/catpaw/main/install.sh | bash

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# 打印横幅
print_banner() {
    echo ""
    echo -e "${GREEN}"
    echo "  ██████╗ ██████╗ ███████╗███╗   ██╗    ███████╗ ██████╗ ███╗   ██╗███████╗"
    echo " ██╔════╝ ██╔══██╗██╔════╝████╗  ██║    ╚══███╔╝██╔═══██╗████╗  ██║██╔════╝"
    echo " ██║  ███╗██████╔╝█████╗  ██╔██╗ ██║      ███╔╝ ██║   ██║██╔██╗ ██║█████╗  "
    echo " ██║   ██║██╔══██╗██╔══╝  ██║╚██╗██║     ███╔╝  ██║   ██║██║╚██╗██║██╔══╝  "
    echo " ╚██████╔╝██║  ██║███████╗██║ ╚████║    ███████╗╚██████╔╝██║ ╚████║███████╗"
    echo "  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝    ╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝"
    echo -e "${NC}"
    echo "  🤖 智能助手系统 - 一键安装"
    echo ""
    echo "======================================"
    echo "  版本：v0.2.0"
    echo "  更新时间：2026-04-14"
    echo "======================================"
    echo ""
}

# 检查系统要求
check_requirements() {
    log_info "检查系统要求..."
    
    # 检查 Python3
    if ! command -v python3 &> /dev/null; then
        log_error "未检测到 Python3，请先安装 Python3"
        exit 1
    fi
    
    PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
    log_success "Python3 $PYTHON_VERSION 已安装"
    
    # 检查 pip3
    if ! command -v pip3 &> /dev/null; then
        log_warning "未检测到 pip3，尝试安装..."
        if command -v apt-get &> /dev/null; then
            sudo apt-get install -y python3-pip
        elif command -v yum &> /dev/null; then
            sudo yum install -y python3-pip
        else
            log_error "无法自动安装 pip3，请手动安装"
            exit 1
        fi
    fi
    log_success "pip3 已安装"
    
    # 检查 git
    if ! command -v git &> /dev/null; then
        log_warning "未检测到 git，尝试安装..."
        if command -v apt-get &> /dev/null; then
            sudo apt-get install -y git
        elif command -v yum &> /dev/null; then
            sudo yum install -y git
        else
            log_error "无法自动安装 git，请手动安装"
            exit 1
        fi
    fi
    log_success "git 已安装"
    
    # 检查 curl
    if ! command -v curl &> /dev/null; then
        log_warning "未检测到 curl，尝试安装..."
        if command -v apt-get &> /dev/null; then
            sudo apt-get install -y curl
        elif command -v yum &> /dev/null; then
            sudo yum install -y curl
        fi
    fi
    log_success "curl 已安装"
}

# 选择安装目录
choose_install_dir() {
    echo ""
    echo "请选择安装目录:"
    echo ""
    echo "  1) ~/catpaw (推荐)"
    echo "  2) /opt/catpaw"
    echo "  3) 自定义目录"
    echo ""
    read -p "请选择 [1-3]: " choice
    
    case $choice in
        1)
            INSTALL_DIR="$HOME/catpaw"
            ;;
        2)
            INSTALL_DIR="/opt/catpaw"
            sudo mkdir -p "$INSTALL_DIR"
            sudo chown $(whoami):$(whoami) "$INSTALL_DIR"
            ;;
        3)
            read -p "请输入安装目录路径: " INSTALL_DIR
            mkdir -p "$INSTALL_DIR"
            ;;
        *)
            log_error "无效选择"
            exit 1
            ;;
    esac
    
    log_info "安装目录：$INSTALL_DIR"
}

# 克隆仓库
clone_repo() {
    echo ""
    log_info "克隆 CatPaw 仓库..."
    
    # 检查目录是否为空
    if [ -d "$INSTALL_DIR" ] && [ "$(ls -A $INSTALL_DIR)" ]; then
        log_warning "目录不为空，是否继续？(y/n)"
        read -p "继续安装: " confirm
        if [ "$confirm" != "y" ]; then
            log_error "安装取消"
            exit 1
        fi
    fi
    
    # 克隆仓库（使用 GitHub 或 Gitee）
    echo ""
    echo "选择代码源:"
    echo ""
    echo "  1) GitHub (推荐，国际)"
    echo "  2) Gitee (国内加速)"
    echo "  3) 本地目录 (已有代码)"
    echo ""
    read -p "请选择 [1-3]: " repo_choice
    
    case $repo_choice in
        1)
            REPO_URL="https://github.com/your-repo/catpaw.git"
            log_info "从 GitHub 克隆..."
            git clone "$REPO_URL" "$INSTALL_DIR" || {
                log_warning "GitHub 克隆失败，是否尝试 Gitee？(y/n)"
                read -p "使用 Gitee: " use_gitee
                if [ "$use_gitee" = "y" ]; then
                    REPO_URL="https://gitee.com/your-repo/catpaw.git"
                    git clone "$REPO_URL" "$INSTALL_DIR"
                else
                    log_error "克隆失败"
                    exit 1
                fi
            }
            ;;
        2)
            REPO_URL="https://gitee.com/your-repo/catpaw.git"
            log_info "从 Gitee 克隆..."
            git clone "$REPO_URL" "$INSTALL_DIR"
            ;;
        3)
            read -p "请输入本地代码目录路径: " LOCAL_DIR
            if [ -d "$LOCAL_DIR" ]; then
                cp -r "$LOCAL_DIR"/* "$INSTALL_DIR"/
            else
                log_error "目录不存在：$LOCAL_DIR"
                exit 1
            fi
            ;;
        *)
            log_error "无效选择"
            exit 1
            ;;
    esac
    
    log_success "代码克隆完成"
}

# 安装依赖
install_dependencies() {
    echo ""
    log_info "安装 Python 依赖..."
    
    cd "$INSTALL_DIR"
    
    # 检查 requirements.txt
    if [ -f "requirements.txt" ]; then
        pip3 install -r requirements.txt --user
        log_success "依赖安装完成"
    else
        # 安装基本依赖
        log_info "安装基本依赖..."
        pip3 install flask flask-cors requests --user
        log_success "基本依赖安装完成"
    fi
    
    # 创建虚拟环境（可选）
    echo ""
    read -p "是否创建 Python 虚拟环境？(y/n): " use_venv
    if [ "$use_venv" = "y" ]; then
        log_info "创建虚拟环境..."
        python3 -m venv venv
        source venv/bin/activate
        pip3 install -r requirements.txt 2>/dev/null || pip3 install flask flask-cors requests --user
        log_success "虚拟环境创建完成"
    fi
}

# 配置 LLM
configure_llm() {
    echo ""
    echo "======================================"
    echo "  配置云模型 API"
    echo "======================================"
    echo ""
    log_info "CatPaw 需要配置云模型 API 才能使用"
    echo ""
    echo "支持的云模型:"
    echo "  1) Kimi2.5 (月之暗面) - 128K 上下文，长文档分析"
    echo "  2) Qwen3.5 (通义千问) - 代码能力强"
    echo "  3) DeepSeek - 性价比高"
    echo "  4) 稍后配置"
    echo ""
    read -p "请选择 [1-4]: " llm_choice
    
    case $llm_choice in
        1)
            log_info "配置 Kimi2.5"
            read -p "请输入 Kimi API Key: " API_KEY
            CONFIG_JSON="{
  \"provider\": \"openai\",
  \"api_key\": \"$API_KEY\",
  \"base_url\": \"https://api.moonshot.cn/v1\",
  \"model\": \"kimi-latest\",
  \"temperature\": 0.7,
  \"max_tokens\": 4096,
  \"timeout\": 60
}"
            ;;
        2)
            log_info "配置 Qwen3.5"
            read -p "请输入 Qwen API Key: " API_KEY
            CONFIG_JSON="{
  \"provider\": \"openai\",
  \"api_key\": \"$API_KEY\",
  \"base_url\": \"https://dashscope.aliyuncs.com/compatible-mode/v1\",
  \"model\": \"qwen-max\",
  \"temperature\": 0.7,
  \"max_tokens\": 4096,
  \"timeout\": 60
}"
            ;;
        3)
            log_info "配置 DeepSeek"
            read -p "请输入 DeepSeek API Key: " API_KEY
            CONFIG_JSON="{
  \"provider\": \"openai\",
  \"api_key\": \"$API_KEY\",
  \"base_url\": \"https://api.deepseek.com/v1\",
  \"model\": \"deepseek-chat\",
  \"temperature\": 0.7,
  \"max_tokens\": 4096,
  \"timeout\": 60
}"
            ;;
        4)
            log_info "稍后配置"
            CONFIG_JSON=""
            ;;
        *)
            log_error "无效选择"
            exit 1
            ;;
    esac
    
    if [ -n "$CONFIG_JSON" ]; then
        # 创建配置目录
        mkdir -p ~/.catpaw
        
        # 保存配置
        echo "$CONFIG_JSON" > ~/.catpaw/llm_config.json
        log_success "LLM 配置已保存到 ~/.catpaw/llm_config.json"
    fi
}

# 创建启动脚本
create_launcher() {
    echo ""
    log_info "创建启动脚本..."
    
    # 创建 ~/bin 目录
    mkdir -p ~/bin
    
    # 创建 catpaw 命令
    cat > ~/bin/catpaw << 'EOF'
#!/bin/bash
# CatPaw 启动脚本

SCRIPT_DIR="$HOME/catpaw"
cd "$SCRIPT_DIR"

case "$1" in
    cli)
        echo "💡 CatPaw CLI 模式"
        echo ""
        echo "CatPaw 目前支持以下模式:"
        echo "  - Web 模式：catpaw web"
        echo "  - 配置 API: catpaw config"
        echo ""
        echo "启动 Web 服务后，通过浏览器访问聊天界面"
        echo ""
        read -p "是否启动 Web 服务？(y/n): " start_web
        if [ "$start_web" = "y" ]; then
            python3 web_server.py
        fi
        ;;
    web)
        python3 web_server.py
        ;;
    config)
        python3 configure_llm.py
        ;;
    status)
        ./start.sh status
        ;;
    logs)
        ./start.sh logs
        ;;
    *)
        echo "用法：catpaw [web|config|status|logs]"
        echo ""
        echo "  web    - Web 界面模式"
        echo "  config - 配置云模型"
        echo "  status - 查看运行状态"
        echo "  logs   - 查看最近日志"
        echo ""
        echo "示例:"
        echo "  catpaw web     # 启动 Web 服务"
        echo "  catpaw config  # 配置 API"
        echo "  catpaw status  # 查看状态"
        ;;
esac
EOF
    
    chmod +x ~/bin/catpaw
    
    # 添加到 PATH
    if ! echo "$PATH" | grep -q "$HOME/bin"; then
        echo "" >> ~/.bashrc
        echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
        log_info "已将 ~/bin 添加到 PATH"
    fi
    
    log_success "启动脚本创建完成"
    log_info "现在可以使用 'catpaw' 命令启动"
}

# 修复启动脚本（如需要）
fix_startup_scripts() {
    echo ""
    log_info "检查启动脚本..."
    
    cd "$INSTALL_DIR"
    
    # 检查 setup_and_start.sh 是否引用了不存在的文件
    if [ -f "setup_and_start.sh" ]; then
        if grep -q "catpaw.py" setup_and_start.sh && [ ! -f "catpaw.py" ]; then
            log_warning "setup_and_start.sh 引用了不存在的 catpaw.py"
            log_info "创建兼容性包装器..."
            
            # 创建 catpaw.py 包装器
            cat > catpaw.py << 'PYEOF'
#!/usr/bin/env python3
"""CatPaw 主程序包装器"""

import sys
import os

def main():
    if len(sys.argv) < 2:
        print("用法：python3 catpaw.py <命令>")
        print("")
        print("命令:")
        print("  web    - 启动 Web 服务")
        print("  config - 配置 LLM")
        print("  help   - 显示帮助")
        return
    
    cmd = sys.argv[1]
    
    if cmd == "web" or cmd == "cli":
        # 启动 Web 服务
        os.system("python3 web_server.py")
    elif cmd == "config":
        os.system("python3 configure_llm.py")
    elif cmd == "help":
        print("CatPaw 帮助")
        print("")
        print("用法：python3 catpaw.py <命令>")
        print("")
        print("命令:")
        print("  web    - 启动 Web 服务")
        print("  config - 配置 LLM")
        print("  help   - 显示帮助")
    else:
        print(f"未知命令：{cmd}")
        print("使用 'python3 catpaw.py help' 查看帮助")

if __name__ == "__main__":
    main()
PYEOF
            chmod +x catpaw.py
            log_success "创建 catpaw.py 包装器"
        else
            log_success "启动脚本正常"
        fi
    fi
}

# 显示完成信息
show_complete() {
    echo ""
    echo "======================================"
    echo -e "${GREEN}  CatPaw 安装完成！${NC}"
    echo "======================================"
    echo ""
    echo "📍 安装目录：$INSTALL_DIR"
    echo "📁 配置目录：~/.catpaw/"
    echo ""
    echo "🚀 快速开始:"
    echo ""
    echo "  方式 1: 使用命令 (推荐)"
    echo "    catpaw cli     # 命令行模式"
    echo "    catpaw web     # Web 模式"
    echo "    catpaw config  # 配置 API"
    echo ""
    echo "  方式 2: 进入目录"
    echo "    cd $INSTALL_DIR"
    echo "    ./setup_and_start.sh"
    echo ""
    echo "📚 文档:"
    echo "    cd $INSTALL_DIR"
    echo "    cat QUICKSTART.md"
    echo ""
    echo "💡 提示:"
    if [ -f ~/.catpaw/llm_config.json ]; then
        echo "    ✅ LLM 已配置，可以直接使用"
    else
        echo "    ⚠️  请先配置 LLM: catpaw config"
    fi
    echo ""
    echo "======================================"
    echo ""
}

# 主函数
main() {
    print_banner
    
    echo "本脚本将自动完成以下操作:"
    echo "  ✅ 检查系统要求 (Python3, pip3, git, curl)"
    echo "  ✅ 选择安装目录"
    echo "  ✅ 克隆 CatPaw 代码"
    echo "  ✅ 安装 Python 依赖"
    echo "  ✅ 配置云模型 API"
    echo "  ✅ 创建启动命令"
    echo ""
    read -p "是否继续安装？(y/n): " confirm
    
    if [ "$confirm" != "y" ]; then
        log_info "安装取消"
        exit 0
    fi
    
    echo ""
    check_requirements
    choose_install_dir
    clone_repo
    install_dependencies
    configure_llm
    create_launcher
    fix_startup_scripts
    show_complete
    
    # 询问是否立即启动
    read -p "是否立即启动 CatPaw？(y/n): " start_now
    if [ "$start_now" = "y" ]; then
        echo ""
        echo "选择启动模式:"
        echo "  1) Web 网页模式 (推荐)"
        echo "  2) 查看状态"
        echo ""
        read -p "请选择 [1-2]: " mode
        
        case $mode in
            1)
                cd "$INSTALL_DIR"
                python3 web_server.py
                ;;
            2)
                cd "$INSTALL_DIR"
                ./start.sh status
                ;;
            *)
                log_error "无效选择"
                ;;
        esac
    fi
}

# 运行主函数
main
