#!/bin/bash
set -e

# Wait for MySQL
echo "Waiting for MySQL..."
until nc -z -v -w30 db 3306; do
  echo "Waiting for database connection..."
  sleep 5
done

# If not installed, install Flarum
if [ ! -f "public/index.php" ]; then
  echo "Installing Flarum..."
  composer create-project flarum/flarum . --stability=beta --no-interaction
fi

# Change Apache to listen on 8080 and all interfaces
sed -i 's/80/8080/g' /etc/apache2/ports.conf /etc/apache2/sites-available/000-default.conf
sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Start Apache
apache2-foreground
