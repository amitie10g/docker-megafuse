PUID=$(id -u)
PGID=$(id -g)

USERNAME=<MEGA username>
PASSWORD=<MEGA password>
APIKEY=<Mega API key>

CONF_PATH=$HOME/config

docker run -t -i -d \
--name=megafuse \
-e PUID=$PUID \
-e PGID=$PGID \
-e USERNAME=$USERNAME \
-e PASSWORD=$PASSWORD \
-e APIKEY=$APIKEY \
-v $CONF_PATH:/config \
--device=/dev/fuse \
--restart no \
--privileged \
amitie10g/megafuse:latest
