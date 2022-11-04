#!/bin/bash
sudo apt update && sudo apt upgrade -y

# install pip and venv
sudo apt install python3-venv python3-pip

# install vs code
sudo apt install software-properties-common apt-transport-https wget
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt install code
