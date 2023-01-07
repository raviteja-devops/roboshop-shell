source common.sh

print_head "Setup NodeJS repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
status_check

print_head "Install NodeJS"
yum install nodejs -y &>>${LOG}
status_check

print_head "Add User"
id roboshop &>>${LOG}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${LOG}
fi
status_check

print_head "Setup App Directory"
mkdir /app &>>${LOG}
status_check

print_head "Remove Existing Files"
rm -rf /app/* &>>${LOG}
status_check

print_head "Download the Application Code"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${LOG}
status_check

print_head "Unzip Application Code"
cd /app &>>${LOG}
status_check
unzip /tmp/user.zip &>>${LOG}
status_check

print_head "Download Dependencies"
cd /app &>>${LOG}
status_check
npm install &>>${LOG}
status_check

print_head "Setup Catalogue Service"
cp ${script_location}/files/user.service /etc/systemd/system/user.service &>>${LOG}
status_check

print_head "Load The Service"
systemctl daemon-reload &>>${LOG}
status_check

print_head "Enable The Service"
systemctl enable user &>>${LOG}
status_check

print_head "Start The Service"
systemctl start user &>>${LOG}
status_check

# We need to load the schema. To load schema we need to install mongodb client.
# To have it installed we can setup MongoDB repo and install mongodb-client

print_head "Setup MongoDB Repo"
cp ${repo_file}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check

print_head "Install MongoDB Client"
yum install mongodb-org-shell -y &>>${LOG}
status_check

print_head "Load Schema"
mongo --host mongodb-dev.raviteja.online </app/schema/user.js &>>${LOG}
status_check