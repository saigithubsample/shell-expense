#!/bin/bash

LOGS_FOLDER="/var/log/shell_script"
SCRIPT_NAME="$(echo $0 | cut -d "." -f1)"
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE=$LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.log

mkdir -p $LOG_FILE
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
CHECK_ROOT

echo " script started executing at : $(date)"  | tee -a $LOG_FILE

dnf install mysql-server -y
VALIDATE $? "Installing mysql"

systemctl enable mysqld
VALIDATE $? "enabling mysql"

systemctl start mysqld
VALIDATE $? "Starting mysql"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "setting root password for expense user"