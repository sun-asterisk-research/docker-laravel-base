# NOTE: This file was generated via generate.sh. Don't edit it directly

FROM ghcr.io/sun-asterisk-research/php:8.1.34-nginx-alpine3.22@sha256:52414238eb01bf163d0df29bb7c10adb04559a89cdd9242c8794c35defe7e998

COPY rootfs /

ENV APPLICATION_ROOT=/srv/app
ENV DOCUMENT_ROOT=

ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=100000
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

ENV PHP_FPM.pm=ondemand
ENV PHP_FPM.pm.max_children=40
ENV PHP_FPM.pm.process_idle_timeout=300s

WORKDIR /srv/app

ENTRYPOINT [ "docker-entrypoint" ]
