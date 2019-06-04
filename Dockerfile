FROM alpine:edge AS builder

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories
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

FROM lsiobase/alpine:latest

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories

RUN apk update
RUN apk add \
  libcrypto1.1 \
  libcurl \
  fuse
RUN ln -s /usr/lib/libcryptopp.so /usr/lib/libcryptopp.so.5.6
  
COPY --from=builder /MegaFuse/MegaFuse /usr/bin/megafuse
COPY --from=builder /usr/lib/libcryptopp.so /usr/lib/libcryptopp.so.5.6
COPY --from=builder /usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6
COPY --from=builder /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1
COPY --from=builder /usr/lib/libdb_cxx-5.3.so /usr/lib/libdb_cxx-5.3.so
COPY --from=builder /lib/libcrypto.so.1.1 /lib/libcrypto.so.1.1
COPY --from=builder /usr/lib/libfreeimage.so.3 /usr/lib/libfreeimage.so.3
COPY /root /
