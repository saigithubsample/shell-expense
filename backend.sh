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


dnf module disable nodejs -y &>>LOG_FILE
VALIDATE $? "disabling nodejs"

dnf module enable nodejs:20 -y &>>LOG_FILE
VALIDATE $? "enabling nodejs:20"

dnf install nodejs -y &>>LOG_FILE
VALIDATE $? "installing nodejs"

id expense  &>>LOG_FILE

if [ $? -ne 0 ]
then
    echo -e "$R expense user not exits.. creating"
    useradd expense &>>LOG_FILE
    VALIDATE $? "creating user expense"
else 
    echo -e "$G user is already created  .. skipping"

fi    

mkdir -p /app
 VALIDATE $? "creating app dir"

 curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip  &>>LOG_FILE
 VALIDATE $? "downloading backend code"

cd /app
rm -rf /app/*

unzip /tmp/backend.zip &>>LOG_FILE
VALIDATE $? "extracting backend code"

npm install &>>LOG_FILE
cp /home/ec2-user/shell-expense/backend.service /etc/systemd/system/backend.service

dnf install mysql -y &>>LOG_FILE
VALIDATE $? "installing mysql"

mysql -h mysql.geethika.shop -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>LOG_FILE
VALIDATE $? "loading schema"

systemctl daemon-reload &>>LOG_FILE
VALIDATE $? "demoan reload"

systemctl enable backend   &>>LOG_FILE
VALIDATE $? "enabling backend"

systemctl start backend  &>>LOG_FILE
VALIDATE $? "starting backend"

systemctl restart backend  &>>LOG_FILE
VALIDATE $? "restrating backend"