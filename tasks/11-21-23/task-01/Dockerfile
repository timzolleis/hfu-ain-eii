FROM bitnami/minideb:latest AS base

RUN install_packages apache2

# Copy the index.html file into the container
COPY ./apache-config/sites/index.html  /var/www/html/eii/index.html
COPY ./apache-config/sites/*.jpg /var/www/html/eii/
COPY ./apache-config/sites/*.png /var/www/html/eii/

# Copy the virtual host configuration

COPY ./apache-config/sites/eii.conf /etc/apache2/sites-available/eii.conf

COPY ./apache-config/ports.conf /etc/apache2/ports.conf

# Disable default virtual host
RUN a2dissite 000-default.conf
# Enable the virtual host
RUN a2ensite eii.conf

# Start
ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]