FROM alpine:3.18.3 AS build

ENV TZ=Europe/London

WORKDIR /build

# prerequisites for strfry
RUN \
  apk --no-cache add \
    linux-headers \
    git \
    g++ \
    make \
    pkgconfig \
    libtool \
    ca-certificates \
    perl-yaml \
    perl-template-toolkit \
    perl-app-cpanminus \
    libressl-dev \
    zlib-dev \
    lmdb-dev \
    flatbuffers-dev \
    libsecp256k1-dev \
    zstd-dev \
  && rm -rf /var/cache/apk/* \
  && cpanm Regexp::Grammars 

# build strfry
RUN git clone https://github.com/hoytech/strfry.git \
  && cd strfry \
  && git submodule update --init \
  && make setup-golpe \
  && make -j4

# the actual deployment build
FROM alpine:3.18.3

WORKDIR /app

## install binaries for running strfry
RUN \
  apk --no-cache add \
    lmdb \
    flatbuffers \
    libsecp256k1 \
    libb2 \
    zstd \
    libressl 

# clear APK cache for a small final image
RUN rm -rf /var/cache/apk/*

COPY --from=build /build/strfry strfry

EXPOSE 7777

ENTRYPOINT ["/app/strfry"]
CMD ["relay"]
