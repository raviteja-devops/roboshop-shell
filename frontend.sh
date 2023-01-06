conf_file=$(pwd)
LOG=/tmp/roboshop.log

# Install Nginx
echo -e "\e[35m Install Nginx\e[0m"
yum install nginx -y &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  echo "Refer Log File For More Information, LOG - ${LOG}"
exit
fi

# Remove the default content that web server is serving
echo -e "\e[35m Remove Nginx Default Content\e[0m"
rm -rf /usr/share/nginx/html/* &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  echo "Refer Log File For More Information, LOG - ${LOG}"
exit
fi

# Download the frontend content
echo -e "\e[35m Download The Front-End Content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  echo "Refer Log File For More Information, LOG - ${LOG}"
exit
fi

# Extract the frontend content
echo -e "\e[35m Extract The Front-End Content\e[0m"
cd /usr/share/nginx/html &>>${LOG}
unzip /tmp/frontend.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  echo "Refer Log File For More Information, LOG - ${LOG}"
exit
fi

# searching for files folder in /usr/share/nginx/html path, so we specify files folder location as variable

echo -e "\e[35m Copy RoboShop Nginx Config File\e[0m"
cp ${conf_file}/files/nginx_roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  echo "Refer Log File For More Information, LOG - ${LOG}"
exit
fi

# Enable Nginx service
echo -e "\e[35m Enable Nginx\e[0m"
systemctl enable nginx &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  echo "Refer Log File For More Information, LOG - ${LOG}"
exit
fi

# Restart Nginx Service to load the changes of the configuration
echo -e "\e[35m Start Nginx\e[0m"
systemctl restart nginx &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
  echo "Refer Log File For More Information, LOG - ${LOG}"
exit
fi