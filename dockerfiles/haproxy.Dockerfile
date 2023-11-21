FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       software-properties-common \
       rsyslog systemd systemd-cron sudo wget bash gpg gpg-agent\
    && apt-get clean \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && rm -rf /var/lib/apt/lists/* \
    && touch -d "2 hours ago" /var/lib/apt/lists
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

RUN sudo add-apt-repository ppa:vbernat/haproxy-2.7 -y

RUN apt-get update && apt-get install -y haproxy

# install cookiecutter
RUN wget https://github.com/relaytools/cookiecutter/releases/download/v0.0.2/cookiecutter_linux_x86_64.tar.gz
RUN tar -xzvf cookiecutter_linux_x86_64.tar.gz -C /usr/local/bin

COPY haproxycheck.service /etc/systemd/system/haproxycheck.service
COPY haproxycheck.timer /etc/systemd/system/haproxycheck.timer
RUN systemctl enable haproxycheck.timer

RUN echo "root:root" | chpasswd