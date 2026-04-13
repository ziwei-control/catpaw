#!/bin/bash
# CatPaw 快速启动脚本

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/logs/web.log"
PID_FILE="$SCRIPT_DIR/logs/web.pid"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 函数：检查服务状态
check_status() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p $PID > /dev/null 2>&1; then
            echo -e "${GREEN}✅ CatPaw 正在运行 (PID: $PID)${NC}"
            return 0
        fi
    fi
    
    # 尝试通过进程名查找
    PID=$(pgrep -f "python3.*web_server.py.*--port 6767")
    if [ ! -z "$PID" ]; then
        echo -e "${GREEN}✅ CatPaw 正在运行 (PID: $PID)${NC}"
        echo $PID > "$PID_FILE"
        return 0
    fi
    
    echo -e "${YELLOW}❌ CatPaw 未运行${NC}"
    return 1
}

# 函数：启动服务
start() {
    if check_status > /dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  CatPaw 已经在运行${NC}"
        return 0
    fi
    
    echo -e "${GREEN}🚀 启动 CatPaw...${NC}"
    cd "$SCRIPT_DIR"
    
    # 确保日志目录存在
    mkdir -p logs
    
    # 启动服务
    nohup python3 web_server.py --port 6767 > "$LOG_FILE" 2>&1 &
    PID=$!
    echo $PID > "$PID_FILE"
    
    sleep 2
    
    if ps -p $PID > /dev/null 2>&1; then
        echo -e "${GREEN}✅ CatPaw 启动成功 (PID: $PID)${NC}"
        echo -e "${GREEN}🌐 访问地址：https://pandaco.asia/chat/${NC}"
        echo -e "${YELLOW}📋 查看日志：tail -f $LOG_FILE${NC}"
        return 0
    else
        echo -e "${RED}❌ CatPaw 启动失败${NC}"
        echo -e "${RED}📋 查看错误：tail -20 $LOG_FILE${NC}"
        rm -f "$PID_FILE"
        return 1
    fi
}

# 函数：停止服务
stop() {
    echo -e "${YELLOW}🛑 停止 CatPaw...${NC}"
    
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p $PID > /dev/null 2>&1; then
            kill $PID
            sleep 2
            echo -e "${GREEN}✅ CatPaw 已停止 (PID: $PID)${NC}"
        else
            echo -e "${YELLOW}⚠️  进程不存在${NC}"
        fi
        rm -f "$PID_FILE"
    else
        # 尝试通过进程名停止
        pkill -f "python3.*web_server.py.*--port 6767"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ CatPaw 已停止${NC}"
        else
            echo -e "${YELLOW}⚠️  未找到运行中的进程${NC}"
        fi
    fi
}

# 函数：重启服务
restart() {
    stop
    sleep 1
    start
}

# 函数：查看日志
logs() {
    if [ -f "$LOG_FILE" ]; then
        tail -50 "$LOG_FILE"
    else
        echo -e "${RED}❌ 日志文件不存在${NC}"
    fi
}

# 函数：显示帮助
help() {
    echo "CatPaw 快速启动脚本"
    echo ""
    echo "用法：$0 {start|stop|restart|status|logs|help}"
    echo ""
    echo "命令:"
    echo "  start   - 启动 CatPaw"
    echo "  stop    - 停止 CatPaw"
    echo "  restart - 重启 CatPaw"
    echo "  status  - 查看运行状态"
    echo "  logs    - 查看最近 50 行日志"
    echo "  help    - 显示帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 start      # 启动服务"
    echo "  $0 logs       # 查看日志"
    echo "  $0 restart    # 重启服务"
}

# 主程序
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        check_status
        ;;
    logs)
        logs
        ;;
    help|*)
        help
        ;;
esac

exit 0
