# NOTE: This file was generated via generate.sh. Don't edit it directly

FROM ghcr.io/sun-asterisk-research/php:7.4.30-nginx-alpine3.15

COPY rootfs /

ENV APPLICATION_ROOT=/srv/app
ENV DOCUMENT_ROOT=

ENV PHP_FPM.pm=ondemand
ENV PHP_FPM.pm.max_children=40
ENV PHP_FPM.pm.process_idle_timeout=300s

WORKDIR /srv/app

ENTRYPOINT [ "docker-entrypoint" ]
