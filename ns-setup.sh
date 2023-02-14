#!/bin/sh

sudo apt-get update

sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo docker run hello-world

echo Okay, lets set up some variables
echo
echo "Enter you email (the one SSL certificate will be generated for):"
read email
echo "NS_EMAIL=$email" >> .env
echo

echo Now enter the domain name you Nightscout will be hosted at, excluding the subdomain:
read domain
echo "NS_DOMAIN=$domain" >> .env
echo

curl https://raw.githubusercontent.com/justmara/ns-setup/main/docker-compose.yml --output docker-compose.yml

bash <(wget -qO- https://raw.githubusercontent.com/justmara/ns-setup/main/add.sh)
