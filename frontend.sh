source common.sh

print_head "Install Nginx"
yum install nginx -y &>>${LOG}
status_check

print_head "Remove Nginx Default Content"
rm -rf /usr/share/nginx/html/* &>>${LOG}
status_check

print_head "Download The Front-End Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${LOG}
status_check

print_head "Extract The Front-End Content"
cd /usr/share/nginx/html &>>${LOG}
unzip /tmp/frontend.zip &>>${LOG}
status_check

print_head "Copy RoboShop Nginx Config File"
cp ${script_location}/files/nginx_roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${LOG}
status_check

print_head "Enable Nginx"
systemctl enable nginx &>>${LOG}
status_check

print_head "Start Nginx"
systemctl restart nginx &>>${LOG}
status_check