#!/bin/bash

# Check if arguments are missing
if [ ! $1 -o ! $2 ]; then
    echo "Please enter --help"
    echo "or provide both source and destination files."
    exit
fi

# Check if the user requests help
if [ "$1" = "--help" ]; then
    echo "This tool moves files."
    echo "Usage: move.sh Source Destination"
    exit
fi

# Move the file from source to destination
mv "$1" "$2"

# Check if the move was successful
if [ $? -eq 0 ]; then
    echo "File successfully moved."
else
    echo "Error: Could not move the file."
fi
