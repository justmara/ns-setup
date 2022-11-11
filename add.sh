#!/bin/sh

while [[ ! "$subdomain" =~ ^[a-zA-Z0-9-]+$ ]]; do
  echo
  echo "Enter the name of the subdomain where your Nightscout will be available:"
  read subdomain
done
secret=$(cat /proc/sys/kernel/random/uuid)

cat >> docker-compose.yml <<EOF

  nightscout-${subdomain}:
    image: nightscout/cgm-remote-monitor:latest
    container_name: nightscout-${subdomain}
    restart: always
    depends_on:
      - mongo
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.routers.nightscout-${subdomain}.rule=Host(\`${subdomain}.\${NS_DOMAIN}\`)'
      - 'traefik.http.routers.nightscout-${subdomain}.entrypoints=web'
      - 'traefik.http.routers.nightscout-${subdomain}.entrypoints=websecure'
      - 'traefik.http.routers.nightscout-${subdomain}.tls.certresolver=le'
    environment:
      <<: *ns-common-env
      CUSTOM_TITLE:
      API_SECRET: '${secret}'
      AUTH_DEFAULT_ROLES: denied
      BRIDGE_USER_NAME:
      BRIDGE_PASSWORD:
      BRIDGE_SERVER: EU
      MONGO_CONNECTION: mongodb://mongo:27017/ns-${subdomain}
      ENABLE: basal iob cob boluscalc cage sage iage bage pump openaps pushover bgi food rawbg bridge
      SHOW_PLUGINS: basal iob cob boluscalc cage sage iage bage pump openaps pushover bgi food rawbg

EOF

sudo docker compose up -d

echo "URL: $subdomain.$domain"
echo "API_SECRET for Nightscout access (write it down!): $secret"
echo
echo "You can view and edit your API_SECRET and other configurations by 'nano docker-compose.yml'"
echo "Email address and domain variables are stored in '.env'"
echo
echo "To add more Nightscout instances,"
echo "please run 'bash <(wget -qO- https://raw.githubusercontent.com/justmara/ns-setup/main/add.sh)'"
echo
echo "After editing settings, re-launch your Nightscout app by typing 'sudo docker compose up -d'"
