#!/bin/bash
# for bastionHost
sudo apt-get update
sudo apt-get upgrade -y
echo "################################### INSTALLING JENKINS ###################################"
sudo apt update
sudo apt-get install default-jre default-jdk -y
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update -y
sudo apt-get install jenkins -y

echo "################################### INSTALLING DOCKER ###################################"
sudo apt-get update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update -y
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo usermod -aG docker ${USER}
newgrp docker
sudo gpasswd -a jenkins docker
sudo systemctl restart jenkins

#install git
sudo apt install git -y

# install salt
echo "################################### INSTALLING Salt ###################################"
curl -L https://bootstrap.saltstack.com -o install-salt.sh
sudo sh install-salt.sh -M -P git v3000.3
salt --version
sudo mkdir /srv/salt
cd /srv/salt/