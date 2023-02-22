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
exit
fi
}


nodejs()
{
  source common.sh

  print_31 "Configure NodeJS Repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
  status $?

  print_31 "Install NodeJS"
  yum install nodejs -y &>>${log_file}
  status $?

  print_32 "Create Roboshop User"
  id roboshop &>>${log_file}
  if [ $? -ne 0 ]; then
   useradd roboshop &>>${log_file}
  fi
  status $?

  print_32 "Create Application Directory"
  if [ ! -d /app ]; then
   mkdir /app &>>${log_file}
  fi
  status $?

  print_33 "Delete Old Content"
  rm -rf /app/* &>>${log_file}
  status $?

  print_33 "Downloading App Content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
  cd /app
  status $?

  print_34 "Extracting App Content"
  unzip /tmp/${component}.zip &>>${log_file}
  status $?

  print_31 "Installing NodeJS Dependencies"
  npm install &>>${log_file}
  status $?

  print_34 "Copy SystemD Service File"
  cp ${code_dir}/config/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
  status $?

  print_35 "Reload SystemD"
  systemctl daemon-reload &>>${log_file}
  status $?

  print_35 "Enable ${component} Service "
  systemctl enable ${component} &>>${log_file}
  status $?

  print_36 "Start ${component} Service"
  systemctl restart ${component} &>>${log_file}
  status $?

  print_36 "Copy MongoDB Repo File"
  cp ${code_dir}/config/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}
  status $?

  print_32 "Install Mongo Client"
  yum install mongodb-org-shell -y &>>${log_file}
  status $?

  print_33 "Load Schema"
  mongo --host mongodb.myprojecdevops.info </app/schema/${component}.js &>>${log_file}
  status $?

}