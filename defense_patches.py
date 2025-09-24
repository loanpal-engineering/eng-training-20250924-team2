#!/usr/bin/env python3
"""
Defense patches for Vulnleap security training
Apply these patches to protect your instance
"""

# Patch 1: Fix SQL Injection in user registration
SQL_INJECTION_FIX = '''
# BEFORE (vulnerable):
sql_query = f"INSERT INTO users (username, password_hash, user_type) VALUES ('{username}', '{escaped_password}', '{role}')"
query_result = db.session.execute(text(sql_query))

# AFTER (secure):
new_user = User(username=username, password_hash=hashed_password, user_type='normal')  # Force normal role
db.session.add(new_user)
db.session.commit()
'''

# Patch 2: Fix IDOR in quote access
IDOR_FIX = '''
# BEFORE (vulnerable):
quote = MortgageQuote.query.get(quote_id)

# AFTER (secure):
quote = MortgageQuote.query.filter_by(id=quote_id, user_id=session['user_id']).first()
if not quote:
    flash("Quote not found or access denied.", "danger")
    return redirect(url_for('main.user'))
'''

# Patch 3: Fix session management
SESSION_FIX = '''
# BEFORE (vulnerable):
app.config['SECRET_KEY'] = str(uuid.uuid4())

# AFTER (secure):
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'your-very-long-secret-key-here')
'''

# Patch 4: Input validation
INPUT_VALIDATION = '''
# Add input validation for usernames
import re

def validate_username(username):
    if not re.match("^[a-zA-Z0-9_]+$", username):
        return False
    if len(username) < 3 or len(username) > 20:
        return False
    return True
'''

print("🛡️ DEFENSE STRATEGIES:")
print("1. Apply SQL injection fix")
print("2. Implement proper access controls")
print("3. Fix session management")
print("4. Add input validation")
print("5. Monitor for attack attempts")
