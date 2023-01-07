source common.sh

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

rabbitmqctl add_user roboshop roboshop123 &>>${LOG}
status_check
rabbitmqctl set_user_tags roboshop administrator &>>${LOG}
status_check
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
status_check

