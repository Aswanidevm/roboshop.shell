echo -e "\e[32m installing nginx...\e[0m"
yum install nginx -y > /tmp/nginxinstall

rm -rf /usr/share/nginx/html/* 
echo -e "\e[33m extracting roboshop frontend..\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip > /tmp/extraction 
cd /usr/share/nginx/html 
echo -e "\e[41m unziping files... \e[0m"
unzip /tmp/frontend.zip > /tmp/unziping
echo -e "\e[42m enabling nginx... \e[0m"
systemctl enable nginx 
echo -e "\e[31m starting nginx... \e[0m"
systemctl start nginx 
