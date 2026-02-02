FROM mautic/mautic:7-apache

USER root

# Zorg dat je mappen bestaan (Railway volumes kunnen leeg zijn)
RUN mkdir -p /var/www/html/var/logs /var/www/html/var/cache /var/www/html/docroot/media \
  && chown -R www-data:www-data /var/www/html/var /var/www/html/docroot/media

# FIX 1: Forceer precies 1 Apache MPM
RUN a2dismod mpm_event mpm_worker || true \
 && a2enmod mpm_prefork

# FIX 2: GD runtime dependencies (voorkomt "Unable to load gd")
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      libxpm4 \
      libavif15 \
      libjpeg62-turbo \
      libpng16-16 \
      libwebp7 \
      libfreetype6 \
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
