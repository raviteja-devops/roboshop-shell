source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "variable root_mysql_password needed"
  exit
fi

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
systemctl restart mysqld &>>${LOG}
status_check

print_head "Change The Default Root Password"
mysql_secure_installation --set-root-pass ${root_mysql_password} &>>${LOG}
if [ $? -eq 1 ]; then
  echo "password is already changed"
fi
status_check