#!bin/bash 

echo "Please Enter the num"
read num 

if [ $num -lt 0 ]
then
    echo "The num is negative"
elif [ $num -gt 0 ]
then
    echo "The num is posative"
else 
    echo "The number is Zero"
fi 

echo "Successful.."
