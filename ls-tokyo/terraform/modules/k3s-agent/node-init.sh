#!/bin/env bash

# Swap 설정
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile.img swap swap defaults 0 0" >> /etc/fstab


# Update packages
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
apt update -y && apt upgrade -y


# Install k3s
echo "*** Installing k3s agent..."
export INSTALL_K3S_EXEC="agent --server https://${K3S_SERVER_IP}:6443 --token ${K3S_TOKEN}"
curl -sfL https://get.k3s.io | sh -
