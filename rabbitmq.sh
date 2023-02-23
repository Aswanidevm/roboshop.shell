source common.sh

roboshop_app_password=$1
if [ -z "${roboshop_app_password}" ]; then
  echo -e "\e[31mMissing RabbitMQ App User Password argument\e[0m"
  exit 1
fi

print_31 "Setup Erlang repos "
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash  &>>${log_file}
status $?

print_32 "Setup RabbitMQ Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>>${log_file}
status $?

print_33 "Install Erlang & RabbitMQ"
yum install rabbitmq-server erlang -y  &>>${log_file}
status $?


print_34 "Enable RabbitMQ Service"
systemctl enable rabbitmq-server  &>>${log_file}
status $?

print_35 "Start RabbitMQ Service"
systemctl start rabbitmq-server  &>>${log_file}
status $?

print_36 "Add Application User"
rabbitmqctl list_users | grep roboshop &>>${log_file}
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop ${roboshop_app_password} &>>${log_file}
fi
status $?

print_31 "Configure Permissions for App User"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>>${log_file}
status $?