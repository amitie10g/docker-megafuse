# docker-megafuse (Matteo Serva)

This is an attemp to build an Alpine-based Docker image for access [Mega](https://github.com/meganz) volumes via FUSE, using the [Matteo Serva's](https://github.com/matteoserva) [MegaFuse](https://github.com/Amitie10g/docker-megafuse/tree/matteoserva) project.

An image based on the [Mega SDK](https://github.com/meganz/sdk) is available at the [main branch](https://github.com/Amitie10g/docker-megafuse).

## Caveats
* The username and password are passed to the container as environment variables in plain text. I'm working in a way to encrypted (or at least ofuscate) the sensitive data.
* This implementation lacks of a configurable caching methods (at least, I don't know how to set at compile time, as this approach uses the Mega SDK source code directly. The Matteo Serva's MegaFuse project implements a configurable caching.

## Instructions

### Pull from Docker Hub
docker pull amitie10g/megafuse:latest

### Running
```
PUID=$(id -u)
PGID=$(id -g)

USERNAME=<MEGA username>
PASSWORD=<MEGA password>

docker run -t -i -d \
--name=megafuse \
-e PUID=$PUID \
-e PGID=$PGID \
-e USERNAME=$USERNAME \
-e PASSWORD=$PASSWORD \
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
The Dockerfile and scripts included inside the source tree has been released to the **Public domain** (Unlicense).
However, the resulting images, binaries and third party source code are subjected to the copyright from the original developers, namely,

* **Mega SDK:** BSD 2-Clause "Simplified" License
* **Matteo Serva's MegaFuse:** GNU General Public License version 2
