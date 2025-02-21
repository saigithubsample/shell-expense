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
CHECK_ROOT

echo " script started executing at : $(date)"  | tee -a $LOG_FILE

dnf install mysql-server -y  | tee -a $LOG_FILE
VALIDATE $? "Installing mysql"

systemctl enable mysqld  | tee -a $LOG_FILE
VALIDATE $? "enabling mysql"

systemctl start mysqld  | tee -a $LOG_FILE
VALIDATE $? "Starting mysql"

mysql -h mysql.geethika.shop -u root -pExpenseApp@1 -e 'show databases;' | tee -a $LOG_FILE
if [ $? -ne 0]
then 
    echo " root password has not setup, setting now" | tee -a $LOG_FILE
    mysql_secure_installation --set-root-pass ExpenseApp@1  
    VALIDATE $? "setting root password for expense user"
else
    echo -e " $G Root password is already setup" | tee -a $LOG_FILE
fi