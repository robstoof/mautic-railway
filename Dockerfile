FROM mautic/mautic:7-apache

USER root

# 1) Fix volumes/permissions
RUN mkdir -p /var/www/html/var/logs /var/www/html/var/cache /var/www/html/docroot/media \
  && chown -R www-data:www-data /var/www/html/var /var/www/html/docroot/media

# 2) HARD FIX: ensure only ONE MPM is enabled
RUN a2dismod mpm_event mpm_worker >/dev/null 2>&1 || true \
 && rm -f /etc/apache2/mods-enabled/mpm_event.load /etc/apache2/mods-enabled/mpm_event.conf \
 && a2enmod mpm_prefork >/dev/null 2>&1 || true

# 3) Fix GD runtime deps (nu mis je libXpm.so.4)
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      libxpm4 \
      libavif15 \
 && rm -rf /var/lib/apt/lists/*

# Optional: verify at build time (handig zolang je debugt)
RUN ls -la /etc/apache2/mods-enabled | grep mpm || true

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
