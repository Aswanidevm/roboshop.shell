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
