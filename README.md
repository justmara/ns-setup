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
2. write `bash <(curl -s https://raw.githubusercontent.com/justmara/ns-setup/master/setup/ns-setup.sh)` in console, press enter and follow installation instructions.
3. enjoy your private nightscout installation

## Migrating old data
This section is optional, for advanced users that want to transfer their data from old Nightscout installation.
There are at least two methods to do that:

1. Use pre-made ssh script, like [this one](https://github.com/tzachi-dar/nightscout-vps/blob/vps-1/clone_nightscout.sh)
2. Use direct mongodump/mongorestore routine

### Mongodump
Since we've set up running MongoDB docker image we can use it to pull all the data from remote mongo instance
1. `docker exec -it mongo /usr/bin/mongodump --uri="<here goes your MongoDb Atlas connection string>"`
this will dump whole db to the folder `dump/<dbname>` in your mongo container
2. `docker exec -it mongo /usr/bin/mongorestore --db ns dump/<dbname>`
this will restore all the data from `dump/<dbname>` folder to the `ns` database