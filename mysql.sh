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
       echo -e " $R Please run the script with root previlages" &>>$LOG_FILE
       exit 1  
     fi
    }



VALIDATE(){
 if [ $1 -ne 0 ]
 then
   echo -e "$2 $R is failed" &>>$LOG_FILE
 else 
   echo -e "$2 $G is success" &>>$LOG_FILE
 fi
}
CHECK_ROOT

for package in $@
do
 dnf list installed $package &>>$LOG_FILE
 if [ $? -ne 0 ]
 then 
  echo -e "$R $package is not installed.. $G going to install" &>>$LOG_FILE
  dnf install $package -y 
  VALIDATE $? "Installing $package"
 else
  echo -e "$G $package is already installed $Y nothing to do" &>>$LOG_FILE
 fi  
done