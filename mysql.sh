source common.sh

print_head "Disable MySQL 8 version"
dnf module disable mysql -y &>>${LOG}
status_check

print_head "Setup The MySQL5.7 Repo File"
cp ${script_location}/files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${LOG}
status_check

print_head "Install MySQL Server"
yum install mysql-community-server -y &>>${LOG}
status_check

print_head "Enable MySQL Server"
systemctl enable mysqld &>>${LOG}
status_check

print_head "Start MySQL Server"
systemctl start mysqld &>>${LOG}
status_check

print_head "Change The Default Root Password"
mysql_secure_installation --set-root-pass RoboShop@1 &>>${LOG}
status_check

print_head "Check The New Password Working or Not"
mysql -uroot -pRoboShop@1 &>>${LOG}
status_check
