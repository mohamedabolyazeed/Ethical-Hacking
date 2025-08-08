#!/bin/bash

echo "Please Enter The Total:"
read total

echo "Please Enter The Exception:"
read num

echo "---------------------------"

i=0
while [ $i -lt $total ]; do
    i=$(expr $i + 1)  # Remove spaces around the '='

    if [ $i -eq $num ]; then
        continue  # Skip the iteration if i equals num
    fi

    sleep 1
    echo $i
done
