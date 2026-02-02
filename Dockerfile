FROM mautic/mautic:7-apache

USER root

# marker om zeker te weten dat jouw build gebruikt wordt
ARG CACHE_BUST=1
RUN echo "### CUSTOM MAUTIC BUILD MARKER: $CACHE_BUST ###"

# jouw folders/permissions
RUN mkdir -p /var/www/html/var/logs /var/www/html/var/cache /var/www/html/docroot/media \
  && chown -R www-data:www-data /var/www/html/var /var/www/html/docroot/media

# GD deps (anders blijf je warnings krijgen / later issues)
RUN apt-get update \
 && apt-get install -y --no-install-recommends libxpm4 libavif15 \
 && rm -rf /var/lib/apt/lists/*

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# BELANGRIJK: niet naar USER www-data terug, zodat we /etc/apache2 kunnen aanpassen
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

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
