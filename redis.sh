source common.sh

print_31 " install repo for redis"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}
status $?

print_32 "enabling redis 6.2 vesrsion"
dnf module enable redis:remi-6.2 -y &>>${log_file}
status $?

print_33 "install redis"
yum install redis -y &>>${log_file}
status $?

print_34 "port address change"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${log_file}
status $?

print_35 "enabling redis"
systemctl enable redis &>>${log_file}
status $?

print_36 "start redis"
systemctl start redis &>>${log_file}
status $?
