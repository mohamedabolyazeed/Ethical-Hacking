#!/bin/bash

# Welcome message
echo "Welcome to the Shell Calculator!"

FirstNumber=$1
echo "the First Number" $1

SecondNumber=$2
echo "the Second Number" $2

# Perform and display addition
echo "Addition: " `expr $FirstNumber + $SecondNumber`

# Perform and display subtraction
echo "Subtraction: " `expr $FirstNumber - $SecondNumber`

# Perform and display multiplication (Note the escape for the asterisk)
echo "Multiplication: " `expr $FirstNumber \* $SecondNumber`

# Perform and display division
echo "Division: " `expr $FirstNumber / $SecondNumber`

# Perform and display remainder
echo "Remainder: " `expr $FirstNumber % $SecondNumber`

