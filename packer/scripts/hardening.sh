#!/bin/bash
set -e

echo "Updating system..."
sudo apt-get update && sudo apt-get upgrade -y

echo "Setting up basic security hardening..."
sudo ufw enable
sudo ufw default deny incoming
sudo ufw allow ssh

echo "Disabling password authentication for SSH..."
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl reload sshd

echo "Configuring basic monitoring tools..."
sudo apt-get install -y htop curl

echo "Hardening complete."