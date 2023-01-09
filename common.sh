script_location=$(pwd)
LOG=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32m SUCCESS\e[0m"
  else
    echo -e "\e[31m FAILURE\e[0m"
    echo "Refer Log File For More Information, LOG - ${LOG}"
  exit
  fi
}

print_head() {
  echo -e "\e[1m \e[0m"
}

app_prereq() {
  print_head "Add User"
  id roboshop &>>${LOG}
  if [ $? -ne 0]; then
    useradd roboshop &>>${LOG}
  fi
  status_check

  print_head "Create Directory"
  mkdir -p /app &>>${LOG}
  status_check

  print_head "Download The Application Code"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${LOG}
  status_check

  print_head "Remove Existing Files"
  rm -rf /app/* &>>${LOG}
  status_check

  print_head "Unzip the Downloaded Content"
  cd /app &>>${LOG}
  unzip /tmp/${component}.zip &>>${LOG}
  status_check
}

systemd_setup() {
  print_head "Setup ${component} Service"
  cp ${script_location}/files/${component}.service /etc/systemd/system/${component}.service &>>${LOG}
  status_check

  print_head "Load Service"
  systemctl daemon-reload &>>${LOG}
  status_check

  print_head "Enable Service"
  systemctl enable ${component} &>>${LOG}
  status_check

  print_head "Start Service"
  systemctl start ${component} &>>${LOG}
  status_check
}

load_schema() {
  if [ ${schema_load} == "true" ]; then
    if [ ${schema_type} == "mongo" ]; then

      print_head "Setup MongoDB Repo"
      cp ${repo_file}/files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${LOG}
      status_check

      print_head "Install MongoDB Client"
      yum install mongodb-org-shell -y &>>${LOG}
      status_check

      print_head "Load Schema"
      mongo --host mongodb-dev.raviteja.online </app/schema/${component}.js &>>${LOG}
      status_check
    fi

    if [ ${schema_type} == "mysql" ]; then

      print_head "Install MYSQL Client"
      yum install mysql-client -y &>>${LOG}
      status_check

      print_head "Load Schema"
      mysql -h mysql-dev.raviteja.online -uroot -p${root_mysql_password} < /app/schema/${component}.sql
      status_check
    fi
  fi

}

nodejs() {
  print_head "Setup NodeJS repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
  status_check

  print_head "Install NodeJS"
  yum install nodejs -y &>>${LOG}
  status_check

  app_prereq

  print_head "Install Dependencies"
  cd /app &>>${LOG}
  npm install &>>${LOG}
  status_check

  systemd_setup

  load_schema
}

maven() {
  print_head "Install Maven"
  yum install maven -y &>>${LOG}
  status_check

  app_prereq

  print_head "Build The Application"
  mvn clean package &>>${LOG}
  status_check

  print_head "Copy App File"
  mv target/${component}-1.0.jar ${component}.jar &>>${LOG}
  status_check

  systemd_setup

  load_schema
}

python() {
  print_head "Install python 3.6"
  yum install python36 gcc python3-devel -y &>>${LOG}
  status_check

  app_prereq

  print_head "Install Dependencies"
  cd /app &>>${LOG}
  pip3.6 install -r requirements.txt &>>${LOG}
  status_check

  systemd_setup

  load_schema
}