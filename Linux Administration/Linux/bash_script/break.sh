#!/bin/bash

total=0  # Remove spaces around the equal sign

while [ 0 ] 
do  # Use 'true' to create an infinite loop
    echo "Please Enter Number:"  # Add space between echo and string
    read num
    if [ "$num" -eq -1 ]; then  # Add quotes around $num for safety
        break
    fi
    total=$(expr $total + $num)  # Remove spaces around the equal sign and use $()
done 

echo "Total is $total"  # Add space between echo and string

