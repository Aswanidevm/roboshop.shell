source common.sh

print_31 "Installing nginx"
yum install nginxx -y &>>${log_file}
status $?

print_32 "Removing Old Content"
rm -rf /usr/share/nginx/html/* &>>${log_file}
status $?

print_33 "Downloading Frontend Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
status $?

print_34 "Extracting Downloaded Frontend"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}
status $?

print_35 "Copying Nginx Config for RoboShop"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
status $?

print_36 "Enabling nginx"
systemctl enable nginx &>>${log_file}
status $?

print_36 "Starting nginx"
systemctl restart nginx &>>${log_file}
status $?
