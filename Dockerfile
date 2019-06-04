FROM lsiobase/alpine:3.9 AS builder

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories \
RUN apk update \
RUN apk add -–no-cache --virtual .build-deps \
    g++ \
    crypto++-dev \
    musl-dev \
    curl-dev \
    db-dev \
    readline-dev \
    fuse-dev \
    freeimage-dev \
    git \
    make \
    pkgconf \
RUN git clone --branch=testing https://github.com/Amitie10g/MegaFuse.git /tmp/MegaFuse \
RUN make --directory=/tmp/MegaFuse \
RUN apk del .build-deps \
RUN apk -–no-cache add \
    crypto++ \
    libcrypto1.1 \
    libcurl \
    freeimage \
    fuse && \
  ln -s /usr/lib/libcryptopp.so /usr/lib/libcryptopp.so.5.6
COPY --from=builder /MegaFuse/MegaFuse /usr/bin/megafuse
COPY /root /
