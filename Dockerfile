FROM frolvlad/alpine-gxx AS builder

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update --no-cache \
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
    git clone --depth=1 --branch=testing https://github.com/Amitie10g/MegaFuse.git /tmp/MegaFuse && \
    make --directory=/tmp/MegaFuse

FROM lsiobase/alpine:latest

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main/" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update --no-cache \
        crypto++ \
        libcrypto1.1 \
        libcurl \
        freeimage \
        db-c++ \
        fuse && \
    ln -s libcryptopp.so /usr/lib/libcryptopp.so.5.6

COPY /root /
COPY --from=builder /tmp/MegaFuse/MegaFuse /usr/bin/megafuse
