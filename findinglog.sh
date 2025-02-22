R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

Source_Direct=/home/ec2-user/log

if [ -d $Source_Direct ]
then
 echo -e "$Source_Direct $G exists$N"
else
 echo -e "$Source_Direct $R not exists$N"
fi 

FILES=$(find $Source_Direct -name "*.log" -mtime +14)

 echo "list of files: $FILES"

 while IFS=read -r line
 do
   echo "Deleting line: $line"
   rm -rf $line
 done <<< $FILES