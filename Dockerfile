FROM mautic/mautic:7-apache

USER root
RUN mkdir -p /var/www/html/var/logs /var/www/html/var/cache /var/www/html/docroot/media \
  && chown -R www-data:www-data /var/www/html/var /var/www/html/docroot/media

USER www-data
