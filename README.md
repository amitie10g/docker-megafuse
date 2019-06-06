# docker-megafuse
This is an attemp to build a Docker image from the [Matteo Serva's]() [MegaFuse](https://github.com/matteoserva/MegaFuse) project, using the [Linux Server.io's](https://github.com/linuxserver) [Alpine Linux](https://hub.docker.com/r/lsiobase/alpine/) base image. This is amimed mainly to be integrated in other projects.

## What does?
* Builds
* Runs
* Mounts

## Caveats
* In Ubuntu, the username and password is prompted properly. However, there are issues under Alpine. [/etc/cont-init.d/30-mount](https://github.com/Amitie10g/docker-megafuse/blob/master/root/etc/cont-init.d/30-mount) contains a workarround using `read` and building a configuration file 
* The password in the config file is stored in plain text!.

## Usage

### Building from source
```
git clone https://github.com/Amitie10g/docker-megafuse.git
sudo docker build --no-cache --pull --compress -t amitie10g/megafuse .
````

### Pull from Docker Hub
docker pull amitie10g/megafuse:alpine

### Running
```
PUID=$(id -u)
PGID=$(id -g)

CONF_PATH=$HOME/config
CACHE_PATH=$HOME/cache

mkdir -p $CONF_PATH $CACHE_PATH

docker run -t -i -d \
--name=megafuse \
-e PUID=$PUID \
-e PGID=$PGID \
-v $CONF_PATH:/config \
-v $CACHE_PATH:/cache \
--device=/dev/fuse \
--restart no \
--privileged \
amitie10g/megafuse:latest
```
Note: `--privileged` is not longer required since Linux 4.18

### Running for first time or to re-generate the config file (you need to delete the config file first)
`docker exec -i -t megafuse /etc/cont-init.d/30-mount -f`

Optionally, you could pass `$USERNAME`, `$PASSWORD` and `$APPKEY` as environment variables at startup to bypass the prompting (this means you would expose private data, namely the plain-text password, beware those risks).

## Integrating in other Alpine-based images
```
FROM amitie10g/megafuse AS builder

FROM <your image>

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk --no-cache add \
      crypto++ \
      libcrypto1.1 \
      libcurl \
      freeimage \
      db-c++ \
      fuse \
      <your packages>
      ln -s /usr/lib/libcryptopp.so /usr/lib/libcryptopp.so.5.6
COPY --from=builder /usr/bin/megafise /usr/bin/megafuse
```
Be sure your image has `s6-overlay` and the user `abc` already created. Otherwise, you need to do that at the Dockerfile. The [Linux Server.io's](https://github.com/linuxserver) [Alpine Linux](https://hub.docker.com/r/lsiobase/alpine/) base image contains everything to run this image properly, so, it is a good image to use.
