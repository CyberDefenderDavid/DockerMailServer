#!/bin/bash

# File to store credentials
CREDENTIALS_FILE="duckdns_credentials.sh"

# Function to get credentials
get_credentials() {
    if [ -f "$CREDENTIALS_FILE" ]; then
        source "$CREDENTIALS_FILE"
    else
        read -p "Enter your DuckDNS token: " DUCKDNS_TOKEN
        read -p "Enter your DuckDNS subdomain: " DUCKDNS_SUBDOMAIN
        echo "DUCKDNS_TOKEN=\"$DUCKDNS_TOKEN\"" > "$CREDENTIALS_FILE"
        echo "DUCKDNS_SUBDOMAIN=\"$DUCKDNS_SUBDOMAIN\"" >> "$CREDENTIALS_FILE"
    fi
}

# Get credentials
get_credentials

# URL to update/check the IP address
UPDATE_URL="https://www.duckdns.org/update?domains=${DUCKDNS_SUBDOMAIN}&token=${DUCKDNS_TOKEN}&ip="

# Send the request to check the domain status
response=$(curl -s $UPDATE_URL)

# Check if the response contains "OK"
if [[ $response == *"OK"* ]]; then
    echo "Domain is active and updated."
else
    echo "Failed to verify domain status."
    echo "Response: $response"
fi
