FROM frolvlad/alpine-gxx AS builder

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache --virtual .build-deps \
      crypto++-dev \
      musl-dev \
      curl-dev \
      db-dev \
      readline-dev \
      fuse-dev \
      freeimage-dev \
      git \
      make \
      pkgconf && \
    git clone --branch=testing https://github.com/Amitie10g/MegaFuse.git /tmp/MegaFuse && \
    make --directory=/tmp/MegaFuse

FROM lsiobase/alpine:3.9

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk update && \
    apk --no-cache add \
      crypto++ \
      libcrypto1.1 \
      libcurl \
      freeimage \
      db-c++ \
      fuse && \
    ln -s libcryptopp.so /usr/lib/libcryptopp.so.5.6

COPY /root /
COPY --from=builder /tmp/MegaFuse/MegaFuse /usr/bin/megafuse
