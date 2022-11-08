#!/bin/sh

while [[ ! "$domain" =~ ^[a-zA-Z0-9-]+$ ]]; do
  echo "Введите имя поддомена, на котором ваш Nightscout будет доступен:"
  read domain
done
secret=$(cat /proc/sys/kernel/random/uuid)

cat >> docker-compose.yml <<EOF

  nightscout-${domain}:
    image: nightscout/cgm-remote-monitor:latest
    container_name: nightscout-${domain}
    restart: always
    depends_on:
      - mongo
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.routers.nightscout-${domain}.rule=Host(\`${domain}.\${NS_DOMAIN}\`)'
      - 'traefik.http.routers.nightscout-${domain}.entrypoints=web'
    environment:
      <<: *ns-common-env
      MONGO_CONNECTION: mongodb://mongo:27017/ns-${domain}
      API_SECRET: '${secret}'
EOF

docker-compose up -d

echo "domain: $domain"
echo "secret: $secret"
