FROM mautic/mautic:7-apache

USER root

# folders/permissions (jouw eerdere fix)
RUN mkdir -p /var/www/html/var/logs /var/www/html/var/cache /var/www/html/docroot/media \
  && chown -R www-data:www-data /var/www/html/var /var/www/html/docroot/media

# fix: apache MPM conflict
RUN a2dismod mpm_event mpm_worker || true \
 && a2enmod mpm_prefork

# fix: missing runtime lib for gd (AVIF)
RUN apt-get update \
 && apt-get install -y --no-install-recommends libavif15 \
 && rm -rf /var/lib/apt/lists/*

USER www-data

ARG MAUTIC_DB_HOST
ARG MAUTIC_DB_USER
ARG MAUTIC_DB_PASSWORD
ARG MAUTIC_DB_NAME
ARG MAUTIC_TRUSTED_PROXIES
ARG MAUTIC_URL
ARG MAUTIC_ADMIN_EMAIL
ARG MAUTIC_ADMIN_PASSWORD

ENV MAUTIC_DB_HOST=$MAUTIC_DB_HOST
ENV MAUTIC_DB_USER=$MAUTIC_DB_USER
ENV MAUTIC_DB_PASSWORD=$MAUTIC_DB_PASSWORD
ENV MAUTIC_DB_NAME=$MAUTIC_DB_NAME
ENV MAUTIC_TRUSTED_PROXIES=$MAUTIC_TRUSTED_PROXIES
ENV MAUTIC_URL=$MAUTIC_URL
ENV MAUTIC_ADMIN_EMAIL=$MAUTIC_ADMIN_EMAIL
ENV MAUTIC_ADMIN_PASSWORD=$MAUTIC_ADMIN_PASSWORD
ENV PHP_INI_DATE_TIMEZONE='UTC'
