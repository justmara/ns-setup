# ns-setup
Simplifying Nightscout setup routine

These scripts are used to make private Nightscout setup as smooth as you could only imagine.
It uses docker compose with nightscout itself, traefik for ssl termination and mongodb for your data. The `docker-compose.yml` is based on original [Nightscout's one](https://github.com/nightscout/cgm-remote-monitor/blob/master/docker-compose.yml) but modified a bit to make use of parameters entered during install scipt's execution.

## Prerequisites
1. First of all you need your VPS - virtal machine.
2. You need a domain name registered and attached to your VPS's public IP.
3. Also you need a ssh access to your VPS.

## Process
Once all the mentioned preparations done you do:
1. ssh to your VPS
2. write `bash <(wget -qO- https://raw.githubusercontent.com/justmara/ns-setup/main/ns-setup.sh)` in console, press enter and follow installation instructions.
3. enjoy your private nightscout installation
