source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo -e "\e[31mMissing MySQL Root Password argument\e[0m"
  exit 1
fi

print_31 "disabling mysql"
dnf module disable mysql -y &>> ${log_file}
status $?

print_32 "copying mysql repo file"
cp ${code_dir}/config/mysql.repo /etc/yum.repos.d/mysql.repo &>> ${log_file}
status $?

print_33 "Installing MySQL Server"
yum install mysql-community-server -y  &>> ${log_file}
status $?

print_34 "Enable MYSQL Service"
systemctl enable mysqld &>> ${log_file}
status $?

print_35 "Start MySQL Service"
systemctl start mysqld  &>> ${log_file}
status $?

print_36 "Set Root Password"
echo show databases | mysql -uroot -p${mysql_root_password} &>>${log_file}
if [ $? -ne 0 ]; then
  mysql_secure_installation --set-root-pass ${mysql_root_password}  &>>${log_file}
fi
status $?