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
echo "Введите ваш email (на него будет зарегистрирован SSL-сертификат):"
read email
echo "NS_EMAIL=$email" >> .env
echo

echo Now enter domain name you Nightscout will be hosted at:
echo Введите имя домена, на котором ваш Nightscout будет доступен:
read domain
echo "NS_DOMAIN=$domain" >> .env
echo

secret=$(cat /proc/sys/kernel/random/uuid)
echo "NS_SECRET=$secret" >> .env

curl https://raw.githubusercontent.com/justmara/ns-setup/main/docker-compose.yml --output docker-compose.yml

sudo docker compose up -d

echo "Your secret for Nightscout access (write it down!):"
echo "Ваш секретный ключ для доступа к Nightscout (запишите!):"
echo "secret: $secret"
echo "email: $email"
echo "domain: $domain"