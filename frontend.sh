echo -e "\e[32m installing nginx..."
yum install nginx -y > /tmp/nginxinstall

rm -rf /usr/share/nginx/html/* 
echo -e "\e[33m extracting roboshop frontend.."
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip > /tmp/extraction 
cd /usr/share/nginx/html 
echo -e "\e[34m unziping files... \e[0m"
unzip /tmp/frontend.zip > /tmp/unziping
systemctl enable nginx 
systemctl start nginx 