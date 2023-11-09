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
    wget \
  && rm -rf /var/cache/apk/* \
  && cpanm Regexp::Grammars 

# build strfry
RUN git clone https://github.com/hoytech/strfry.git \
  && cd strfry \
  && git submodule update --init \
  && make setup-golpe \
  && make -j4

# install Go for spamblaster
RUN wget https://go.dev/dl/go1.21.3.linux-amd64.tar.gz \
  && tar -C /usr/local -xzf go1.21.3.linux-amd64.tar.gz

ENV PATH=${PATH}:/usr/local/go/bin

# build spamblaster
RUN git clone https://github.com/relaytools/spamblaster.git 
RUN cd spamblaster \
  && go build 

# build cookiecutter
RUN git clone https://github.com/relaytools/cookiecutter.git
RUN cd cookiecutter \
  && go build

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
COPY --from=build /build/spamblaster/spamblaster spamblaster
COPY --from=build /build/cookiecutter/cookiecutter cookiecutter

RUN pwd && ls -la && sleep 20

EXPOSE 7777

ENTRYPOINT ["/app/strfry"]
CMD ["relay"]
