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
    ./configure \
      CFLAGS="-g -Os -s -march=native -pipe" \
      CXXFLAGS="-g -Os -s -march=native -pipe" \
      LDFLAGS="-g -Os -s -march=native -pipe -w" \
      --with-fuse && \
    make && \
    make DESTDIR=/tmp install && \
    strip \
      /tmp/lib/libmega.so.30503.0.0 \
      /tmp/bin/megasimplesync \
      /tmp/bin/megacli \
      /tmp/bin/megafuse

FROM lsiobase/alpine:3.9

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
COPY --from=builder /tmp/bin/megasimplesync /tmp/bin/megacli /tmp/bin/megafuse /bin/
COPY --from=builder /tmp/lib/libmega.la /tmp/lib/libmega.so.30503.0.0 /lib/

RUN ln -s libmega.so.30503.0.0 /lib/libmega.so && \
    ln -s libmega.so.30503.0.0 /lib/libmega.so.30503 && \
    ln -s libcryptopp.so /usr/lib/libcryptopp.so.5.6
