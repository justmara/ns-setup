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

echo Итак, немного настроек
echo

while [[ ! "$domain" =~ ^([a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]$ ]]; do
  echo "Введите имя домена, на котором ваш Nightscout будет доступен:"
  read domain
done
echo "NS_DOMAIN=$domain" >> .env
echo

secret=$(cat /proc/sys/kernel/random/uuid)
echo "NS_SECRET=$secret" >> .env

curl https://raw.githubusercontent.com/justmara/ns-setup/jino/docker-compose.yml --output docker-compose.yml

sudo docker compose up -d

echo "Ваш секретный ключ для доступа к Nightscout (запишите!):"
echo "secret: $secret"
echo "domain: $domain"
