# NOTE: This file was generated via generate.sh. Don't edit it directly

FROM ghcr.io/sun-asterisk-research/php:8.1.10-nginx-buster

RUN apt-get update \
    && apt-get install -y cron netcat \
    && rm -rf /var/lib/apt/lists/*

COPY rootfs /

ENV APPLICATION_ROOT=/srv/app
ENV DOCUMENT_ROOT=

ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=60000
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

ENV PHP_FPM.pm=ondemand
ENV PHP_FPM.pm.max_children=40
ENV PHP_FPM.pm.process_idle_timeout=300s

WORKDIR /srv/app

ENTRYPOINT [ "docker-entrypoint" ]
