source common.sh

print_head "Setup the MongoDB repo file"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
status_check

print_head "Install MongoDB"
yum install mongodb-org -y &>>${LOG}
status_check

print_head "Change IP in Conf File"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG}
status_check

print_head "Enable and Start MongoDB"
systemctl enable mongod &>>${LOG}
systemctl restart mongod &>>${LOG}
status_check
