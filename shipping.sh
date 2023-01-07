source common.sh

print_head "Install Maven, Maven Is A Java Packaging Software"
yum install maven -y &>>${LOG}
status_check

print_head "Add application User"
id roboshop &>>${LOG}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${LOG}
  fi
status_check

print_head "Setup App Directory"
mkdir /app &>>${LOG}
status_check

print_head "Download The Application Code"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>>${LOG}
status_check

print_head "Unzip Code"
cd /app &>>${LOG}
status_check
unzip /tmp/shipping.zip &>>${LOG}
status_check

print_head "Download The Dependencies"
cd /app &>>${LOG}
status_check
mvn clean package &>>${LOG}
status_check

print_head "Build The Application"
mv target/shipping-1.0.jar shipping.jar &>>${LOG}
status_check

print_head "Setup SystemD Shipping Service"
cp ${script_location}/files/shipping.service /etc/systemd/system/shipping.service &>>${LOG}
status_check

print_head "Load The Service"
systemctl daemon-reload &>>${LOG}
status_check

print_head "Enable The Service."
systemctl enable shipping &>>${LOG}
status_check

print_head "Start The Service."
systemctl start shipping &>>${LOG}
status_check

print_head "Install MYSQL Client"
labauto mysql-client &>>${LOG}
status_check

print_head "Load Schema"
mysql -h mysql-dev.raviteja.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>${LOG}
status_check