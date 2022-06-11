sudo apt-get update

sudo apt-get install -y \
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
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo docker run hello-world

echo Okay, lets set up some variables
echo 
echo Enter you email (the one SSL certificate will be generated for):
echo Введите ваш email (на него будет зарегистрирован SSL-сертификат):
read email
set NS_EMAIL=$email

echo Now enter domain name you Nightscout will be hosted at:
echo Введите имя домена, на котором ваш Nightscout будет доступен:
read ns_domain
set NS_DOMAIN=$ns_domain

set NS_SECRET=$(uuidgen)

echo Your secret for Nightscout access (write it down!):
echo Ваш секретный ключи для доступа к Nightscout (запишите!):
echo $NS_SECRET

echo $NS_EMAIL
echo $NS_DOMAIN