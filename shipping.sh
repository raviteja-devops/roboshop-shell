source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "variable root_mysql_password needed"
  exit
fi

component=cart

schema_load=false

schema_type=mysql

maven