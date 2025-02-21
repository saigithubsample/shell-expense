Source_Direct=/home/ec2-user/log

if [ -d $Source_Direct ]
then
 echo -e "$Source_Direct $G exists$N"
else
 echo -e "$Source_Direct $R not exists$N"
fi 
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
FILES=$(find /home/ec2-user/log/ -name "*.log" -mtime +14)