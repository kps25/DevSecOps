#!/bin/bash -xe
cd /tmp
apt update -y
apt-get install -y apache2
echo "Hello from the EC2 instance." > /var/www/html/index.html
sudo -u root systemctl start apache2