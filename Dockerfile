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
