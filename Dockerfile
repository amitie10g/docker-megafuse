FROM alpine:latest AS builder

RUN apk add --no-cache \
  gcc \
  musl-dev \
  curl-dev \
  db-dev \
  freeimage-dev \
  readline-dev \
  fuse-dev \
  git
RUN git pull https://github.com/Amitie10g/megafuse.git
RUN cd megafuse
RUN make
