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
export TAILSCALE_IP=$(tailscale ip -4)
export INSTALL_K3S_EXEC="server \
  --tls-san ls-tokyo-k3s-server01.internal.lynlab.cc \
  --node-ip $TAILSCALE_IP \
  --advertise-address $TAILSCALE_IP \
  --flannel-iface tailscale0
  --flannel-conf '{\"Network\":\"10.42.0.0/16\", \"Backend\": {\"Type\": \"vxlan\", \"MTU\": 1280}}'"
curl -sfL https://get.k3s.io | sh -
