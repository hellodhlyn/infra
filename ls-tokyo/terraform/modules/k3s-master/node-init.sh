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
echo "*** Installing k3s server..."
export INSTALL_K3S_EXEC="server --tls-san=${NODE_NAME}.master.lynlab.cc --cluster-cidr=10.42.0.0/16,2001:cafe:42::/56 --service-cidr=10.43.0.0/16,2001:cafe:43::/112"
curl -sfL https://get.k3s.io | sh -
