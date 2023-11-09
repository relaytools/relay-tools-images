FROM ubuntu:22.04
WORKDIR /app

ARG DEBIAN_FRONTEND=noninteractive

# Install: dependencies, clean: apt cache, remove dir: cache, man, doc, change mod time of cache dir.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       software-properties-common \
       rsyslog systemd systemd-cron sudo\
    && apt-get clean \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && rm -rf /var/lib/apt/lists/* \
    && touch -d "2 hours ago" /var/lib/apt/lists
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

RUN apt update && apt install -y \
    git g++ make pkg-config libtool ca-certificates \
    libyaml-perl libtemplate-perl libregexp-grammars-perl libssl-dev zlib1g-dev \
    liblmdb-dev libflatbuffers-dev libsecp256k1-dev \
    libzstd-dev

# extras
RUN apt update && apt install -y curl wget jq vim

# build strfry
RUN git clone https://github.com/hoytech/strfry.git \
  && cd strfry \
  && git submodule update --init \
  && make setup-golpe \
  && make -j4

RUN apt update && apt install -y --no-install-recommends \
    liblmdb0 libflatbuffers1 libsecp256k1-0 libb2-1 libzstd1 \
    && rm -rf /var/lib/apt/lists/*

# begin customizations for relay.tools
RUN echo "root:root" | chpasswd

# install spamblaster
RUN wget https://github.com/relaytools/spamblaster/releases/download/v0.0.3/spamblaster_linux_x86_64.tar.gz
RUN tar -xzvf spamblaster_linux_x86_64.tar.gz -C /usr/local/bin

# install cookiecutter
RUN wget https://github.com/relaytools/cookiecutter/releases/download/v0.0.2/cookiecutter_linux_x86_64.tar.gz
RUN tar -xzvf cookiecutter_linux_x86_64.tar.gz -C /usr/local/bin

COPY strfrycheck.service /etc/systemd/system/strfrycheck.service
COPY strfrycheck.timer /etc/systemd/system/strfrycheck.timer
RUN systemctl enable strfrycheck.timer

ENTRYPOINT ["/app/strfry"]
CMD ["relay"]
