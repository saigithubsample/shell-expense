#!/bin/bash

LOGS_FOLDER="/var/log/shell_script"
SCRIPT_NAME="$(echo $0 | cut -d "." -f1)"
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE=$LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.log

mkdir -p $LOGS_FOLDER
Userid=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"

CHECK_ROOT(){

     if [ $Userid -ne 0 ]
     then
       echo -e " $R Please run the script with root previlages" | tee -a $LOG_FILE
       exit 1  
     fi
    }



VALIDATE(){
 if [ $1 -ne 0 ]
 then
   echo -e "$2 $R is failed" | tee -a $LOG_FILE
 else 
   echo -e "$2 $G is success" | tee -a $LOG_FILE
 fi
}


echo -e " $Y script started executing at : $(date)"  | tee -a $LOG_FILE

CHECK_ROOT



dnf install nginx -y &>>LOG_FILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>>LOG_FILE
VALIDATE $? "Enabling nginx"

systemctl start nginx &>>LOG_FILE
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/*  
VALIDATE $? "removing html page"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>LOG_FILE
VALIDATE $? "downloading frontend"

cd /usr/share/nginx/html 

unzip /tmp/frontend.zip &>>LOG_FILE
VALIDATE $? "Extracting the front end"

cp /home/ec2-user/shell-expense/expense.conf /etc/nginx/default.d/expense.conf  &>>LOG_FILE

systemctl restart nginx &>>LOG_FILE
VALIDATE $? "Restarting nginx"



