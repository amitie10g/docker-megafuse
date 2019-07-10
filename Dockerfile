FROM frolvlad/alpine-gxx AS builder

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk --update --no-cache add \
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
    ./configure \
      CFLAGS="-g -Os -s -march=native -pipe" \
      CXXFLAGS="-g -Os -s -march=native -pipe" \
      LDFLAGS="-g -Os -s -march=native -pipe -w" \
      --with-fuse && \
    make && \
    make DESTDIR=/tmp install && \
    strip /tmp/lib/libmega.so.30600.0.0

FROM lsiobase/alpine:latest

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
      fuse \
      c-ares \
      libcurl \
      sqlite-libs \
      freeimage \
      crypto++

COPY /root /
COPY --from=builder /tmp/bin /tmp/lib /

RUN ln -s libmega.so.30503.0.0 /lib/libmega.so && \
    ln -s libmega.so.30503.0.0 /lib/libmega.so.30503 && \
    ln -s libcryptopp.so /usr/lib/libcryptopp.so.5.6
