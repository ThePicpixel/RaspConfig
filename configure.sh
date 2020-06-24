#!/bin/bash

# Upgrading the system
sudo apt update
sudo apt upgrade -y

# Loading params
source params

# Creating new user
pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
useradd -m -p "$pass" "$username"

sudo usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi $username

echo "export TERM=xterm" >> /home/${username}/.bashrc

# Changing SSH configuration
template="$(cat sshd_config)"
eval "echo \"${template}\"" > /etc/ssh/sshd_config
sudo service ssh reload

# Changing hostname
sudo sed -i "s/raspberrypi/$hostname/g" /etc/hosts
sudo sed -i "s/raspberrypi/$hostname/g" /etc/hostname

# Make Raspbian ask for a password when using root
eval "echo \"$username ALL=(ALL) PASSWD: ALL\"" | sudo EDITOR='tee -a' visudo
