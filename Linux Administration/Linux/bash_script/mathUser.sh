#!/bin/bash

# Welcome message
echo "Welcome to the Shell Calculator!"

# Prompt the user to enter the first number
echo "Please Enter the First Number"
read FirstNumber

# Prompt the user to enter the second number
echo "Please Enter the Second Number"
read SecondNumber

# Display the input numbers
echo "First Number: $FirstNumber"
echo "Second Number: $SecondNumber"

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
