# ============================================================
# Dockerfile — Custom Odoo 18 with Hospital Module
# ============================================================
FROM odoo:18.0

USER root

# Install additional system dependencies if needed
RUN apt-get update && apt-get install -y git \
    && rm -rf /var/lib/apt/lists/*

# Copy custom addons
COPY --chown=odoo:odoo ./hospital_module /mnt/extra-addons/hospital_module

# Copy Odoo config (no hardcoded admin_passwd — injected at runtime)
COPY --chown=odoo:odoo ./docker/odoo.conf /etc/odoo/odoo.conf

# Copy and register our custom entrypoint
COPY --chown=root:root ./docker/entrypoint.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh

USER odoo

EXPOSE 8069

ENTRYPOINT ["/custom-entrypoint.sh"]
CMD ["odoo"]
