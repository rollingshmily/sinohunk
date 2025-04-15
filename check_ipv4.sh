#!/bin/bash

# === Telegram Bot 设置 ===
TELEGRAM_BOT_TOKEN="你的BotToken"
TELEGRAM_CHAT_ID="你的ChatID"

# 检查 IPv4
ipv4=$(curl -s4 --max-time 5 ip.sb)
if [[ -z "$ipv4" ]]; then
    echo "[$(date)] IPv4 not found. Restarting warp..." >> /root/warp_check.log
    warp o >> /root/warp_check.log 2>&1

    # 发送 Telegram 通知
    msg="⚠️ WARP IPv4 掉线，已执行 warp o"
    curl -s -X POST https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage \
         -d chat_id=$TELEGRAM_CHAT_ID \
         -d text="$msg" >> /root/warp_check.log 2>&1
else
    echo "[$(date)] IPv4 OK: $ipv4" >> /root/warp_check.log
fi
