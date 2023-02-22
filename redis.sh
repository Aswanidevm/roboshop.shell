source common.sh

print_31 " install repo for redis"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

print_32 "enabling redis 6.2 vesrsion"
dnf module enable redis:remi-6.2 -y

print_33 "install redis"
yum install redis -y

print_34 "port address change"
sed -i -n "s/127.0.0.1/0.0.0.0/"

print_35 "enabling redis"
systemctl enable redis

print_36 "start redis"
systemctl start redis