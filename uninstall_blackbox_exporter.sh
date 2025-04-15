#!/bin/bash

echo "🔧 停止并禁用 blackbox-exporter 服务..."
sudo systemctl stop blackbox-exporter 2>/dev/null
sudo systemctl disable blackbox-exporter 2>/dev/null

echo "🗑️ 删除 systemd 服务文件..."
sudo rm -f /etc/systemd/system/blackbox-exporter.service
sudo systemctl daemon-reload

echo "📂 删除程序文件..."
sudo rm -rf /opt/blackbox_exporter

echo "✅ 卸载完成！现在检查是否还有进程..."
if pgrep -f blackbox_exporter > /dev/null; then
    echo "⚠️ 还有 blackbox_exporter 进程在运行："
    pgrep -af blackbox_exporter
else
    echo "👌 没有残留进程，卸载干净！"
fi
