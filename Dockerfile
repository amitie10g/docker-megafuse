FROM frolvlad/alpine-gxx AS builder

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
      git \
      doxygen \
      file \
      autoconf \
      automake \
      libtool \
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
    make DESTDIR=/tmp install

FROM lsiobase/alpine:3.9

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
      fuse \
      c-ares \
      libcurl \
      sqlite-libs \
      freeimage
    
COPY /root /
COPY --from=builder /tmp/bin /tmp/lib /
