#!/bin/bash

# Check if both numbers are negative
if [ $1 -lt 0 -a $2 -lt 0 ]; then
    echo "Both are negative"
    exit

# Check if the first number is negative
elif [ $1 -lt 0 ]; then
    echo "The first number is negative"
    exit

# Check if the second number is negative
elif [ $2 -lt 0 ]; then
    echo "The second number is negative"
    exit
fi

# Perform arithmetic operations if both numbers are non-negative
echo "Sum: `expr $1 + $2`"
echo "Difference: `expr $1 - $2`"
echo "Product: `expr $1 \* $2`"
echo "Quotient: `expr $1 / $2`"

