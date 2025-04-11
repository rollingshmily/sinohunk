#!/bin/bash

# 创建 2G 的 Swap 文件
echo "创建 2G 的 Swap 文件..."
if ! fallocate -l 2G /swapfile; then
  echo "fallocate 不可用，使用 dd 替代"
  dd if=/dev/zero of=/swapfile bs=1M count=2048 status=progress
fi

# 设置权限
chmod 600 /swapfile

# 格式化为 swap
mkswap /swapfile

# 启用 swap
swapon /swapfile

# 添加到 /etc/fstab 以便开机自动挂载
if ! grep -q '/swapfile' /etc/fstab; then
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

# 设置 swappiness 为 10
echo 'vm.swappiness=10' >> /etc/sysctl.conf
sysctl -p

# 显示结果
echo "Swap 配置完成："
free -h
