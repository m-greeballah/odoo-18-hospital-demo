# ============================================================
# Dockerfile — Custom Odoo 18 with Hospital Module
# ============================================================
FROM odoo:18.0

# Switch to root for installation
USER root

# Install additional system dependencies if needed
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy custom addons into the Odoo addons path
COPY --chown=odoo:odoo ./hospital_module /mnt/extra-addons/hospital_module

# Copy custom Odoo configuration
COPY --chown=odoo:odoo ./docker/odoo.conf /etc/odoo/odoo.conf

# Switch back to odoo user
USER odoo

# Expose standard Odoo port
EXPOSE 8069

# Default command
CMD ["/usr/bin/odoo", "--config=/etc/odoo/odoo.conf"]
