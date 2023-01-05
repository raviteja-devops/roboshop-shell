conf_file=$(pwd)

# Install Nginx
echo -e "\e[35m Install Nginx\e[0m"
yum install nginx -y

# Start & Enable Nginx service
echo -e "\e[35m Enable and Start Nginx\e[0m"
systemctl enable nginx
systemctl start nginx

# Remove the default content that web server is serving
echo -e "\e[35m Remove Nginx Default Content\e[0m"
rm -rf /usr/share/nginx/html/*

# Download the frontend content
echo -e "\e[35m Download The Front-End Content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

# Extract the frontend content
echo -e "\e[35m Extract The Front-End Content\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

# searching for files folder in /usr/share/nginx/html path, so we specify files folder location as variable

echo -e "\e[35m Copy RoboShop Nginx Config File\e[0m"
cp ${conf_file}/files/nginx_roboshop.conf /etc/nginx/default.d/roboshop.conf

# Restart Nginx Service to load the changes of the configuration
echo -e "\e[35m Restart Nginx\e[0m"
systemctl restart nginx