#!/bin/bash

# Define two variables with decimal values
x=20.5
y=10.5

# Perform and display addition using bc
echo "Addition:" `echo "$x + $y" | bc`

# Perform and display subtraction using bc
echo "Subtraction:" `echo "$x - $y" | bc`

# Perform and display multiplication using bc (no need to escape the asterisk in bc)
echo "Multiplication:" `echo "$x * $y" | bc`

# Perform and display division using bc
echo "Division:" `echo "$x / $y" | bc`

