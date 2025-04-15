#!/bin/bash

# 获取当前脚本目录
DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$DIR/.env"

# 如果 .env 不存在，则提示输入并生成
if [[ ! -f "$ENV_FILE" ]]; then
    echo "🔧 首次使用，请输入以下信息："
    read -p "请输入 Telegram Bot Token: " TELEGRAM_BOT_TOKEN
    read -p "请输入 Telegram Chat ID: " TELEGRAM_CHAT_ID

    echo "TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN" > "$ENV_FILE"
    echo "TELEGRAM_CHAT_ID=$TELEGRAM_CHAT_ID" >> "$ENV_FILE"
    echo "✅ .env 文件已创建于 $ENV_FILE"
fi

# 加载环境变量
source "$ENV_FILE"

# 检查 IPv4 是否存在
ipv4=$(curl -s4 --max-time 5 ip.sb)
if [[ -z "$ipv4" ]]; then
    echo "[$(date)] IPv4 not found. Restarting warp..." >> "$DIR/warp_check.log"
    warp o >> "$DIR/warp_check.log" 2>&1

    # 发送 Telegram 通知
    msg="⚠️ WARP IPv4 掉线，已执行 warp o"
    curl -s -X POST https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage \
         -d chat_id=$TELEGRAM_CHAT_ID \
         -d text="$msg" >> "$DIR/warp_check.log" 2>&1
else
    echo "[$(date)] IPv4 OK: $ipv4" >> "$DIR/warp_check.log"
fi

