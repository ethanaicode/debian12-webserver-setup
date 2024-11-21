#!/bin/bash

# This script will review the SSL certificate expiration date for the given domains.

# Define if we want to use localhost or the remote domain
use_localhost=true

# Define the domains to review
domains=("example.com" "anotherdomain.com")

for domain in "${domains[@]}"; do
    if [ "$use_localhost" = true ]; then
        # connect to localhost and get the certificate
        expire_date=$(echo | openssl s_client -connect localhost:443 -servername $domain 2>/dev/null | openssl x509 -noout -dates | grep notAfter | cut -d= -f2)
    else
        # connect to the remote domain and get the certificate
        expire_date=$(echo | openssl s_client -connect $domain:443 -servername $domain 2>/dev/null | openssl x509 -noout -dates | grep notAfter | cut -d= -f2)
    fi
    # format the date
    expire_date=$(date -d "$expire_date" '+%Y-%m-%d %H:%M:%S')
    echo "Domain: $domain, SSL Expire Date: $expire_date"
done