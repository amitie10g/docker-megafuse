# docker-megafuse

This is an attemp to build an Alpine-based Docker image for access [Mega](https://github.com/meganz) volumes via FUSE, using [its SDK](https://github.com/meganz/sdk) directly. I have no plans to adapt or add more features from this source; instead, I recommend to improve the Matteo Serva's code.

An image based on the [Matteo Serva's](https://github.com/matteoserva) [MegaFuse project](https://github.com/Amitie10g/docker-megafuse/tree/matteoserva) is also available at the [main branch](https://github.com/Amitie10g/docker-megafuse/tree/matteoserva).

## General usage

### Before begin
You need your Mega API Client app key. Go to **https://mega.co.nz/#sdk**, and at the section Key management, click in **Get an app**, save it, and use the resulted API key.

### Running
Edit either `run.sh` or `docker-compose.yml`, and then run the script, or use docker-compose.

Note: `privileged` is not longer required since Linux 4.18. However, I tested in my Ubuntu 19.04 (Linux 5.0), and I got `fusermount: mount failed: Operation not permitted`, so, it should stay enabled.

## Inregrating with your own Alpine-based images
There a variants with just the binaries generated from this project and not anything else. Them are suitable for integration with other projects without downloading the full image.
```
FROM amitie10g/megafuse:mega AS builder

FROM <yourimage>

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
      c-ares \
      libcurl \
      sqlite-libs \
      freeimage \
      crypto++
      fuse \
      <your packages> && \
    ln -s libcryptopp.so /usr/lib/libcryptopp.so.5.6 && \
    ln -s libmega.so.30503.0.0 /lib/libmega.so && \
    ln -s libmega.so.30503.0.0 /lib/libmega.so.30503

COPY --from=builder /bin/megafuse /bin/megacli /bin/megasimplesync /bin/
COPY --from=builder /lib/libmega.so.30503.0.0 /lib/libmega.la /lib/

RUN ln -s libmega.so.30503.0.0 /lib/libmega.so && \
    ln -s libmega.so.30503.0.0 /lib/libmega.so.30503 && \
    ln -s libcryptopp.so /usr/lib/libcryptopp.so.5.6
``` 
## Licensing
The Dockerfile and scripts included inside the source tree has been released to the **Public domain** (Unlicense).

However, the resulting images, binaries and third party source code are subjected to the copyright from the original developers, namely,

* **Mega SDK:** BSD 2-Clause "Simplified" License
* **Matteo Serva's MegaFuse:** GNU General Public License version 2
