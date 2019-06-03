# WORK IN PROGRESS!!!
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
CONF_PATH=$HOME/config
PUID=$(id -u)
PGID=$(id -g)

mkdir CONF_PATH

docker run -t -i -d \
--name=megafuse \
-e PUID=$PUID \
-e PGID=$PGID \
-v $CONF_PATH:/config \
--device=/dev/fuse \
--restart no \
--privileged
amitie10g/megafuse:latest
```

### Running for first time or to re-generate the config file
`sudo docker exec -i -t prueba /etc/cont-init.d/30-mount -i`
Note: `--privileged` is not longer required since Linux 4.18
