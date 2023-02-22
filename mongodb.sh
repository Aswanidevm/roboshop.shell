source common.sh

print_31 "Setup MongoDB repository"
cp ${code_dir}/config/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status $?

print_32 "Install MongoDB"
yum install mongodb-org -y &>>${log_file}
status $?

print_33 "Update MongoDB Listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}
status $?

print_34 "Enable MongoDB"
systemctl enable mongod &>>${log_file}
status $?

print_35 "Start MongoDB Service"
systemctl restart mongod &>>${log_file}
status $?


