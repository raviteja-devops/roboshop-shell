source common.sh

print_head "Setup NodeJS repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "Install NodeJS"
yum install nodejs -y &>>${LOG}
status_check

print_head "Add User"
id roboshop &>>${LOG}
if [ $? -ne 0]; then
  useradd roboshop &>>${LOG}
fi
status_check

print_head "Setup App Directory"
mkdir /app &>>${LOG}
status_check

print_head "Download The Application Code"
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>>${LOG}
status_check

print_head "Unzip Code"
cd /app &>>${LOG}
unzip /tmp/cart.zip &>>${LOG}
status_check

print_head "Download The Dependencies"
cd /app &>>${LOG}
npm install &>>${LOG}
status_check

print_head "Setup Cart Service"
cp ${script_location}/files/cart.service /etc/systemd/system/cart.service &>>${LOG}
status_check

print_head "Load Service"
systemctl daemon-reload &>>${LOG}
status_check

print_head "Enable Service"
systemctl enable cart &>>${LOG}
status_check

print_head "Start Service"
systemctl start cart &>>${LOG}
status_check