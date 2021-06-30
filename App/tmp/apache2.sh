#! /bin/bash

sudo apt-get --purge remove apache2 -y
sudo apt-get autoremove -y
sudo rm -rf /etc/apache2/
sudo apt-get clean -y
sudo apt-get update -y
sudo apt-get install apache2 -y
sudo systemctl enable apache2

