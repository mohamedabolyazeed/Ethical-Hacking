#!/bin/bash

if [ $# -gt 0 ]
then
    echo "🔍 Hold tight, we're processing your request..."
    sleep 1
    echo "🌐 Here's the information you asked for:"
    host $1
else
    echo "⚠️ Oops! You forgot to enter a URL."
    echo "💡 Usage: Run the script followed by the URL you'd like to look up."
fi

