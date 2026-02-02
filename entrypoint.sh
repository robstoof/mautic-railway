#!/usr/bin/env bash
set -e

echo "== MPM state BEFORE =="
ls -la /etc/apache2/mods-enabled | grep mpm || true

# disable event/worker, enable prefork
a2dismod mpm_event mpm_worker >/dev/null 2>&1 || true
a2enmod mpm_prefork >/dev/null 2>&1 || true

# hard remove lingering symlinks (just in case)
rm -f /etc/apache2/mods-enabled/mpm_event.load /etc/apache2/mods-enabled/mpm_event.conf || true
rm -f /etc/apache2/mods-enabled/mpm_worker.load /etc/apache2/mods-enabled/mpm_worker.conf || true

echo "== MPM state AFTER =="
ls -la /etc/apache2/mods-enabled | grep mpm || true

exec apache2-foreground
