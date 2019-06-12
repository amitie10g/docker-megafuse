# docker-megafuse

This is an attemp to build an Alpine-based Docker image for access [Mega](https://github.com/meganz) volumes via FUSE, using the [Matteo Serva's](https://github.com/matteoserva) [MegaFuse](https://github.com/Amitie10g/docker-megafuse/tree/matteoserva) project.

An image based on the [Mega SDK](https://github.com/meganz/sdk) is available at a [dedicated branch](https://github.com/Amitie10g/docker-megafuse).

## Caveats
* The application prompts for the user and password. This works fine under Ubuntu-based container; however, there are issues under Alpine, so, I created a scripts to prompt for user, password and API key as workarround.
* The username and password may also passed to the container as environment variables and stored in the config file in plain text. Is desirable to ofuscate that in a some way.
* The code is based on older versions of the Mega SDK, so, lot of warnings are displayed at compile time under newer versions of GCC.

## General usage

### Before begin
You need your Mega API Client app key. Go to **https://mega.co.nz/#sdk**, and at the section Key management, click in **Get an app**, save it, and use the resulted API key.

### Pull from Docker Hub
```
docker pull amitie10g/megafuse:latest
```
### Running
Edit either `run.sh`` or `docker-compose.yml`, and then run the script, or use docker-compose.

Note: `privileged` is not longer required since Linux 4.18. However, I tested in my Ubuntu 19.04 (Linux 5.0), and I got `fusermount: mount failed: Operation not permitted`, so, it should stay enabled.

## Inregrating with your own Alpine-based images
```
FROM <yourimage>
RUN apk --no-cache add \
      crypto++ \
      libcrypto1.1 \
      libcurl \
      freeimage \
      db-c++ \
      fuse \
      <your packages> && \
    ln -s libcryptopp.so /usr/lib/libcryptopp.so.5.6
COPY --from=amitie10g/megafuse:latest /usr/bin/megafuse /usr/bin/megafuse
``` 
## Licensing
The Dockerfile and scripts included inside the source tree has been released to the **Public domain** (Unlicense).

However, the resulting images, binaries and third party source code are subjected to the copyright from the original developers, namely,

* **Mega SDK:** BSD 2-Clause "Simplified" License
* **Matteo Serva's MegaFuse:** GNU General Public License version 2
