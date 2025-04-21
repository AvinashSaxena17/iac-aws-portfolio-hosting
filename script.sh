#!/bin/bash

# Update the package index
sudo apt-get update -y

# Install NGINX
sudo apt-get install -y nginx

# Start and enable NGINX
sudo systemctl start nginx
sudo systemctl enable nginx

# Install AWS CLI v2 (recommended method)
sudo apt install curl unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Verify AWS CLI installation (optional debug)
aws --version

# Create directory for your website files
sudo mkdir -p /var/www/myportfolio

# Ensure permissions are set correctly to avoid access issues
sudo chown -R $USER:$USER /var/www/myportfolio
sudo chmod -R 755 /var/www/myportfolio

# Sync files from S3 to EC2 using IAM role (ensure IAM role has proper permissions)
aws s3 sync s3://prod-terra-aws-s3-bucket /var/www/myportfolio

# Create NGINX config for your portfolio
cat << EOL | sudo tee /etc/nginx/sites-available/myportfolio
server {
    listen 80;
    listen [::]:80;

    server_name YOUR_DOMAIN_OR_PUBLIC_IP;  # Replace with your EC2 IP or domain

    root /var/www/myportfolio;  # Correct root path
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;  # Correct escaping for $uri
    }
}
EOL

# Enable the site by linking to the sites-enabled folder
sudo ln -s /etc/nginx/sites-available/myportfolio /etc/nginx/sites-enabled/

# Remove the default site to avoid Nginx serving the default page
sudo rm /etc/nginx/sites-enabled/default

# Test the NGINX configuration
sudo nginx -t

# Reload NGINX to apply changes
sudo systemctl restart nginx.service

# Output the public IP for easy access
echo "Your site is now live at: http://YOUR_EC2_PUBLIC_IP"
