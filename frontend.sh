source common.sh

print_31 "Installing nginx"
yum install nginx -y &>>${log_file}
if [ $? -eq 0 ] 
then 
echo "success"
fi

print_32 "Removing Old Content"
rm -rf /usr/share/nginx/html/* &>>${log_file}

print_33 "Downloading Frontend Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}

print_34 "Extracting Downloaded Frontend"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}

print_35 "Copying Nginx Config for RoboShop"
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}

print_36 "Enabling nginx"
systemctl enable nginx &>>${log_file}

print_36 "Starting nginx"
systemctl restart nginx &>>${log_file}
