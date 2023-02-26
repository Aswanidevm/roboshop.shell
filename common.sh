code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_31() {
  echo -e "\e[31m$1\e[0m"
}

print_32() {
  echo -e "\e[32m$1\e[0m"
}

print_33() {
  echo -e "\e[33m$1\e[0m"
}

print_34() {
  echo -e "\e[34m$1\e[0m"
}
print_35() {
  echo -e "\e[35m$1\e[0m"
}
print_36() {
  echo -e "\e[36m$1\e[0m"
}

status()
{
if [ $1 -eq 0 ] 
then 
echo "success"
else
echo "failed"
exit 1
fi
}

systemd_setup() {
  print_33 "Copy SystemD Service File"
  cp ${code_dir}/config/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
  status $?

  sed -i -e "s/ROBOSHOP_USER_PASSWORD/${roboshop_app_password}/" /etc/systemd/system/${component}.service &>>${log_file}

  print_32 "Reload SystemD"
  systemctl daemon-reload &>>${log_file}
  status $?

  print_34 "Enable ${component} Service "
  systemctl enable ${component} &>>${log_file}
  status $?

  print_35 "Start ${component} Service"
  systemctl restart ${component} &>>${log_file}
  status $?
}

schema_setup() {
  if [ "${schema_type}" == "mongo" ]; then
    print_36 "Copy MongoDB Repo File"
    cp ${code_dir}/config/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
    status $?

    print_31 "Install Mongo Client"
    yum install mongodb-org-shell -y &>>${log_file}
    status $?

    print_33 "Load Schema"
    mongo --host mongodb.myprojecdevops.info </app/schema/${component}.js &>>${log_file}
    status $?
  elif [ "${schema_type}" == "mysql" ]; then
    print_35 "Install MySQL Client"
    yum install mysql -y &>>${log_file}
    status $?

    print_36 "Load Schema"
    mysql -h mysql.myprojecdevops.info -uroot -p${mysql_root_password} < /app/schema/shipping.sql &>>${log_file}
    status $?
  fi
}

app_prereq_setup() {
  print_33 "Create Roboshop User"
  id roboshop  &>>${log_file}
  if [ $? -ne 0 ]; then
    useradd roboshop &>>${log_file}
  fi
  status $?

  print_34 "Create Application Directory"
  if [ ! -d /app ]; then
    mkdir /app &>>${log_file}
  fi
  status $?

  print_35 "Delete Old Content"
  rm -rf /app/* &>>${log_file}
  status $?

  print_36 "Downloading App Content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
  status $?
  cd /app

  print_31 "Extracting App Content"
  unzip /tmp/${component}.zip &>>${log_file}
  status $?
}

nodejs() {
  print_33 "Configure NodeJS Repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
  status $?

  print_36 "Install NodeJS"
  yum install nodejs -y &>>${log_file}
  status $?

  app_prereq_setup

  print_35 "Installing NodeJS Dependencies"
  npm install &>>${log_file}
  status $?

  schema_setup

  systemd_setup

}

java() {

  print_32 "Install Maven"
  yum install maven -y &>>${log_file}
  status $?

  app_prereq_setup

  print_31 "Download Dependencies & Package"
  mvn clean package &>>${log_file}
  mv target/${component}-1.0.jar ${component}.jar &>>${log_file}
  status $?

  # Schema Setup Function
  schema_setup

  # SystemD Function
  systemd_setup
}

python() {

  print_33 "Install Python"
  yum install python36 gcc python3-devel -y &>>${log_file}
  status $?

  app_prereq_setup

  print_32 "Download Dependencies"
  pip3.6 install -r requirements.txt &>>${log_file}
  status $?

  # SystemD Function
  systemd_setup
}
golang()
{
  print_33 "Install Golang"
  yum install golang -y

  app_prereq_setup

  print_32 "Download Dependencies"
  go mod init dispatch

  go get

  go build

  systemd_setup
}