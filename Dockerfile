FROM alpine:edge AS builder

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories

RUN apk update
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
  make
RUN git clone https://github.com/Amitie10g/MegaFuse.git
RUN make --directory=/MegaFuse

FROM alpine:latest

COPY --from=builder /MegaFuse/MegaFuse /usr/bin/megafuse
