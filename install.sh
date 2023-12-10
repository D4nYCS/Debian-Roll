#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Update packages list and update system
apt update
apt upgrade -y

# Install nala
apt install nala -y

# Making .config and Moving config files
cd $builddir
mkdir -p /home/$username/.config
cp -R dotconfig/* /home/$username/.config/
chown -R $username:$username /home/$username

# Installing Essential Programs 
nala install kitty thunar unzip wget -y
# Installing Other less important Programs
nala install xrdp xorgxrdp task-lxde-desktop tmux -y

# Install chrome-browser
nala install apt-transport-https curl -y
curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/google-chrome.gpg >> /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
nala update
nala install google-chrome-stable -y

# Use nala
bash scripts/usenala

rm -rf $builddir
