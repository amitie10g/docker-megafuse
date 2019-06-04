FROM lsiobase/alpine:3.9 AS builder

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories

RUN apk update
RUN apk add --update-cache pkgconf
RUN apk add --update-cache \
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
  pkgconf
RUN git clone --branch=testing https://github.com/Amitie10g/MegaFuse.git
RUN make --directory=/MegaFuse

FROM lsiobase/alpine:3.9

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories

RUN apk update
RUN apk add \
  crypto++ \
  libcrypto1.1 \
  libcurl \
  freeimage \
  fuse
RUN ln -s /usr/lib/libcryptopp.so /usr/lib/libcryptopp.so.5.6

COPY --from=builder /MegaFuse/MegaFuse /usr/bin/megafuse
COPY /root /
