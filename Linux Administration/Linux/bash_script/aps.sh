#!/bin/bash

echo "Please Enter Number"
read number

if [ $number -lt 0 ]
 then
   echo "The absolute value is" `expr $number \* -1`
elif [ $number -ge 0 ]
 then
   echo "The absolute value is" $number
fi

