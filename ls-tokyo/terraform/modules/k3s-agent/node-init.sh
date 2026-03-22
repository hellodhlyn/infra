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
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up --authkey=${TAILSCALE_AUTH_KEY} --accept-dns=false
while ! tailscale ip -4; do
  sleep 1
done


# Install k3s
echo "*** Installing k3s agent..."
export INSTALL_K3S_EXEC="agent \
	--server ${K3S_SERVER_HOST} \
	--token ${K3S_TOKEN} \
	--node-ip $(tailscale ip -4) \
	--flannel-iface tailscale0"
curl -sfL https://get.k3s.io | sh -
