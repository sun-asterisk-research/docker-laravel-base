# NOTE: This file was generated via generate.sh. Don't edit it directly

FROM ghcr.io/sun-asterisk-research/php:8.1.10-nginx-alpine3.16

COPY rootfs /

ENV APPLICATION_ROOT=/srv/app
ENV DOCUMENT_ROOT=

ENV PHP_FPM.pm=ondemand
ENV PHP_FPM.pm.max_children=40

WORKDIR /srv/app

ENTRYPOINT [ "docker-entrypoint" ]
