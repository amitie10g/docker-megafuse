FROM alpine:edge AS builder

RUN apk add --update \
  gcc \
  musl-dev \
  curl-dev \
  db-dev \
  readline-dev \
  fuse-dev \
  git
RUN git pull https://github.com/Amitie10g/megafuse.git
RUN cd megafuse
RUN make
