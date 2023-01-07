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

print_head "Create Directory"
mkdir -p /app &>>${LOG}
status_check

print_head "Remove Existing Files"
rm -rf /app/* &>>${LOG}
status_check

print_head "Download The Application Code"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG}

print_head "Unzip the Downloaded Content"
cd /app &>>${LOG}
unzip /tmp/catalogue.zip &>>${LOG}
status_check

print_head "Install Dependencies"
cd /app &>>${LOG}
npm install &>>${LOG}
status_check

print_head "Setup Catalogue Service"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
status_check

print_head "Load Service"
systemctl daemon-reload &>>${LOG}
status_check

print_head "Enable Service"
systemctl enable catalogue &>>${LOG}
status_check

print_head "Start Service"
systemctl start catalogue &>>${LOG}
status_check

# We need to load the schema. To load schema we need to install mongodb client
# To have it installed we can setup MongoDB repo and install mongodb-client
cp ${repo_file}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check

print_head "Install MongoDB Client"
yum install mongodb-org-shell -y &>>${LOG}
status_check

print_head "Load Schema"
mongo --host mongodb-dev.raviteja.online </app/schema/catalogue.js &>>${LOG}
status_check