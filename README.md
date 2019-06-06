# docker-megafuse

This is an attemp to build an Alpine-based Docker image for access MEGA via FUSE, using the Matteo Serva's MegaFuse project.

## Instructions

### Pull from Docker Hub
docker pull amitie10g/megafuse:latest

### Running
```
PUID=$(id -u)
PGID=$(id -g)

CONF_PATH=$HOME/config
CACHE_PATH=$HOME/cache

USERNAME=<MEGA username>
Password=<MEGA password>

mkdir -p $CONF_PATH $CACHE_PATH

docker run -t -i -d \
--name=megafuse \
-e PUID=$PUID \
-e PGID=$PGID \
-e USERNAME=$USERNAME \
-e PASSWORD=$PASSWORD
-v $CACHE_PATH:/cache \
--device=/dev/fuse \
--restart no \
--privileged \
amitie10g/megafuse:latest
```
Note: `--privileged` is not longer required since Linux 4.18. However, I tested in my Ubuntu 19.04 (Linux 5.0), and I got `fusermount: mount failed: Operation not permitted`, so, it should stay enabled.

## Inregrating with your own Alpine-based images
```
FROM <yourimage>

COPY --from=amitie10g/megafuse:matteoserva-binary / /
RUN apk --no-cache add \
      crypto++ \
      libcrypto1.1 \
      libcurl \
      freeimage \
      db-c++ \
      fuse \
      <your packages> && \
    ln -s libcryptopp.so /usr/lib/libcryptopp.so.5.6
``` 
## Licensing
This source tree has been released to the **Public domain** (Unlicense).
