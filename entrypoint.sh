#!/usr/bin/env bash
set -euo pipefail

echo "== Apache MPM state BEFORE =="
ls -la /etc/apache2/mods-enabled | grep mpm || true
apache2ctl -M 2>/dev/null | grep mpm || true

# Force single MPM: prefork
a2dismod mpm_event mpm_worker >/dev/null 2>&1 || true
a2enmod mpm_prefork >/dev/null 2>&1 || true

# Extra hard-force: remove any lingering mpm_*.load symlinks except prefork
for f in /etc/apache2/mods-enabled/mpm_*.load /etc/apache2/mods-enabled/mpm_*.conf; do
  [ -e "$f" ] || continue
  case "$f" in
    *mpm_prefork*) : ;;
    *) rm -f "$f" ;;
  esac
done

echo "== Apache MPM state AFTER =="
ls -la /etc/apache2/mods-enabled | grep mpm || true
apache2ctl -M 2>/dev/null | grep mpm || true

# Start the original container command
exec "$@"
