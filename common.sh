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