FROM lsiobase/alpine:3.9 AS builder

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache --virtual .build-deps \
      git \
      autoconf \
      automake \
      libtool \
      g++ \
      crypto++-dev \
      zlib-dev \
      sqlite-dev \
      libressl-dev \
      c-ares-dev \
      curl-dev \
      freeimage-dev \
      readline-dev \
      make \
      fuse-dev && \
    git clone --depth=1 https://github.com/meganz/sdk.git /tmp/megafuse && \
    cd /tmp/megafuse && \
    ./autogen.sh && \
    ./configure --with-fuse && \
    make && \
    make install && \
    rm -fr /tmp/megafuse && \
    apk del .build-deps && \
    
COPY /root /
