#!/bin/bash

# Check if the first number is negative
if [ $1 -lt 0 ]
then 
  echo "The first number is negative"
  exit
fi

# Check if the second number is negative
if [ $2 -lt 0 ]
then 
  echo "The second number is negative"
  exit
fi

# Perform arithmetic operations
echo "Sum: `expr $1 + $2`"
echo "Difference: `expr $1 - $2`"
echo "Product: `expr $1 \* $2`"
echo "Quotient: `expr $1 / $2`"







