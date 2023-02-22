source common.sh

print_31 "Configure NodeJS Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status $?

print_31 "Install NodeJS"
yum install nodejs -y &>>${log_file}
status $?

print_32 "Create Roboshop User"
ip roboshop >> ${log_file}
if [ $? -eq 0 ]
then
useradd roboshop &>>${log_file}
fi
status $?

print_32 "Create Application Directory"
if []
mkdir /app &>>${log_file}
status $?

print_33 "Delete Old Content"
rm -rf /app/* &>>${log_file}
status $?

print_33 "Downloading App Content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
cd /app
status $?

print_34 "Extracting App Content"
unzip /tmp/catalogue.zip &>>${log_file}
status $?

print_31 "Installing NodeJS Dependencies"
npm install &>>${log_file}
status $?

print_34 "Copy SystemD Service File"
cp ${code_dir}/config/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}
status $?

print_35 "Reload SystemD"
systemctl daemon-reload &>>${log_file}
status $?

print_35 "Enable Catalogue Service "
systemctl enable catalogue &>>${log_file}
status $?

print_36 "Start Catalogue Service"
systemctl restart catalogue &>>${log_file}
status $?

print_36 "Copy MongoDB Repo File"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
status $?

print_32 "Install Mongo Client"
yum install mongodb-org-shell -y &>>${log_file}
status $?

print_33 "Load Schema"
mongo --host mongodb.myprojecdevops.info </app/schema/catalogue.js &>>${log_file}
status $?
