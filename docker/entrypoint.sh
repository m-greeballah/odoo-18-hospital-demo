#!/bin/bash
# ============================================================
# Custom Entrypoint — injects ODOO_MASTER_PASSWD into odoo.conf
# at container startup so it never needs to be hardcoded.
# ============================================================
set -e

CONF=/etc/odoo/odoo.conf

if [ -n "$ODOO_MASTER_PASSWD" ]; then
    # Remove any existing admin_passwd line, then append the new one
    sed -i '/^admin_passwd/d' "$CONF"
    echo "admin_passwd = ${ODOO_MASTER_PASSWD}" >> "$CONF"
    echo "[entrypoint] admin_passwd injected into $CONF"
else
    echo "[entrypoint] WARNING: ODOO_MASTER_PASSWD is not set — database manager will be unprotected!"
fi

# Hand off to the official Odoo entrypoint
exec /entrypoint.sh "$@"
