#!/bin/bash 

# Read URLs from cisco.txt
CiscoURLs=$(cat cisco.txt)

# Loop through each URL
for url in $CiscoURLs; do
    # Use the host command to find the IP address and filter the output
    ip_address=$(host "$url" | grep "has address" | awk '{print $4}')
    
    # Check if an IP address was found
    if [ -n "$ip_address" ]; then
        echo "✅ Success: $url is mapped to IP address: $ip_address"
    else
        echo "❌ Alert: No IP address found for $url."
    fi
done

