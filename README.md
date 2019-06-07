# docker-megafuse

This is an attemp to build an Alpine-based Docker image for access [Mega](https://github.com/meganz) volumes via FUSE, using [its SDK](https://github.com/meganz/sdk) directly. I have no plans to adapt or add more features from this source; instead, I recommend to improve the Matteo Serva's code.

An image based on the [Matteo Serva's](https://github.com/matteoserva) [MegaFuse project](https://github.com/Amitie10g/docker-megafuse/tree/matteoserva) is also available at the [main branch](https://github.com/Amitie10g/docker-megafuse/tree/matteoserva).

## General usage

### Pull from Docker Hub
```
docker pull amitie10g/megafuse:mega
```
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
amitie10g/megafuse:mega
```
Note: `--privileged` is not longer required since Linux 4.18. However, I tested in my Ubuntu 19.04 (Linux 5.0), and I got `fusermount: mount failed: Operation not permitted`, so, it should stay enabled.

## Inregrating with your own Alpine-based images
There a variants with just the binaries generated from this project and not anything else. Them are suitable for integration with other projects without downloading the full image.
```
FROM <yourimage>

COPY --from=amitie10g/megafuse:mega-binary / /
RUN apk --no-cache add \
      crypto++ \
      libcrypto1.1 \
      libcurl \
      freeimage \
      db-c++ \
      fuse \
      <your packages> && \
    ln -s libcryptopp.so /usr/lib/libcryptopp.so.5.6 && \
    ln -s libmega.so.30503.0.0 /lib/libmega.so && \
    ln -s libmega.so.30503.0.0 /lib/libmega.so.30503
``` 
## Licensing
The Dockerfile and scripts included inside the source tree has been released to the **Public domain** (Unlicense).
However, the resulting images, binaries and third party source code are subjected to the copyright from the original developers, namely,

* **Mega SDK:** BSD 2-Clause "Simplified" License
* **Matteo Serva's MegaFuse:** GNU General Public License version 2
