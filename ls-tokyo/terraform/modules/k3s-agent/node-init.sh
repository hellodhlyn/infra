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


# Install tailscale
echo "*** Installing tailscale..."
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list
apt update -y
apt install -y tailscale


# Install k3s
echo "*** Installing k3s agent..."
export INSTALL_K3S_EXEC="agent --server https://${K3S_SERVER_IP}:6443 --token ${K3S_TOKEN}"
curl -sfL https://get.k3s.io | sh -
