#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
echo '<html><body><h1>Hello, World! From Terraform</h1></body></html>' | sudo tee /var/www/html/index.html