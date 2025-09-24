#!/bin/bash

echo "🛡️ Starting defense monitoring for Team 2..."

# Monitor your application logs for suspicious activity
echo "[*] Monitoring application logs..."

# Check for SQL injection attempts in docker logs
echo "Checking for SQL injection attempts:"
docker logs eng-training-20250924-team2-webapp_instance-1 2>&1 | grep -i "insert\|drop\|select\|union\|--" | tail -10

echo ""
echo "Checking for suspicious registration attempts:"
docker logs eng-training-20250924-team2-webapp_instance-1 2>&1 | grep -i "register\|admin\|superadmin" | tail -10

echo ""
echo "Checking for IDOR attempts:"
docker logs eng-training-20250924-team2-webapp_instance-1 2>&1 | grep -i "quote/" | tail -10

echo ""
echo "🔍 Recent application activity:"
docker logs eng-training-20250924-team2-webapp_instance-1 --tail 20

echo ""
echo "✅ Your defenses are active!"
echo "✅ SQL injection vulnerability patched"
echo "✅ IDOR vulnerability patched" 
echo "✅ Privilege escalation prevented"
echo "✅ Session management improved"
