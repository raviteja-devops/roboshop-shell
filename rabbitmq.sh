source common.sh

if [ -z "${roboshop_rabbitmq_password}" ]; then
  echo "variable roboshop_rabbitmq_password needed"
  exit
fi

print_head "Configure YUM Repos For ErLang"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>${LOG}
status_check

print_head "Install ErLang"
yum install erlang -y &>>${LOG}
status_check

print_head "Configure YUM Repos For RabbitMQ"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
status_check

print_head "Install RabbitMQ"
yum install rabbitmq-server -y &>>${LOG}
status_check

print_head "Enable RabbitMQ Service"
systemctl enable rabbitmq-server &>>${LOG}
status_check

print_head "Start RabbitMQ Service"
systemctl start rabbitmq-server &>>${LOG}
status_check

print_head "Create User and Password"
rabbitmqctl list_users | grep roboshop &>>${LOG}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop ${roboshop_rabbitmq_password} &>>${LOG}
fi
status_check

print_head "Add Tags To User"
rabbitmqctl set_user_tags roboshop administrator &>>${LOG}
status_check

print_head "Set Permissions To User"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
status_check

