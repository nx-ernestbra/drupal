# Use the bitnami/drupal:10 image as base
FROM docker.io/bitnami/drupal:10

USER root
# Set working directory
WORKDIR /bitnami/drupal

# Create the directory for apt lists
RUN mkdir -p /var/lib/apt/lists/partial

# Install necessary packages for SFTP server
RUN apt-get update && apt-get install -y openssh-server

# Setup SSH user and directory
RUN useradd -m -s /bin/bash sftpuser
RUN echo 'sftpuser:password' | chpasswd
RUN mkdir /home/sftpuser/.ssh
RUN chmod 700 /home/sftpuser/.ssh
RUN chown sftpuser:sftpuser /home/sftpuser/.ssh


# Expose SSH port
EXPOSE 22

# Copy modules from host to container
COPY ./web/modules /bitnami/drupal/modules

# Ensure permissions are set appropriately (if needed)
RUN chown -R daemon:daemon /bitnami/drupal/modules

# Switch back to the default non-root user for bitnami images
USER 1001
# Optionally, you can perform additional customization steps here

# Start Drupal as the default command
CMD ["php", "/bitnami/drupal/vendor/bin/drush", "runserver", "--default-server=builtin", "0.0.0.0:8080"]

# Start SSH server on container startup
CMD ["/usr/sbin/sshd", "-D"]
