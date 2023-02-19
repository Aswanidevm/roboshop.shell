cp /config/mongodb.repo /etc/yum.repos.d/mongo.repo
echo -e " \e[32m installing mongodb... \e[0m"
yum install mongodb-org -y > /tmp/insrallationfile.txt
systemctl enable mongod 
systemctl start mongod 

systemctl restart mongod
