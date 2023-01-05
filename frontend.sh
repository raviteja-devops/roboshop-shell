conf_file=$(pwd)

# Install Nginx
yum install nginx -y

# Start & Enable Nginx service
systemctl enable nginx
systemctl start nginx

# Remove the default content that web server is serving
rm -rf /usr/share/nginx/html/*

# Download the frontend content
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

# Extract the frontend content
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

# searching for files folder in /usr/share/nginx/html path, so we specify files folder location as variable

cp ${conf_file}/files/nginx_roboshop.conf /etc/nginx/default.d/roboshop.conf

# Restart Nginx Service to load the changes of the configuration
systemctl restart nginx