import os
from flask import Flask
from .models import db
from datetime import timedelta
import uuid

def create_app():
    app = Flask(__name__)
    
    # Build database URI
    db_uri = f"mysql+pymysql://{os.getenv('MYSQL_USER')}:{os.getenv('MYSQL_PASSWORD')}@{os.getenv('MYSQL_HOST')}/{os.getenv('MYSQL_DB')}"
    
    app.config['SQLALCHEMY_DATABASE_URI'] = db_uri
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    
    # Configure SSL if specified
    ssl_mode = os.getenv('MYSQL_SSL_MODE')
    if ssl_mode and ssl_mode.upper() != 'DISABLED':
        # Only configure SSL if it's not explicitly disabled
        app.config['SQLALCHEMY_ENGINE_OPTIONS'] = {
            'connect_args': {
                'ssl': {'ssl_mode': ssl_mode}
            }
        }
    
    # PATCHED: Use a fixed secret key for session management
    app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'team2-super-secret-key-for-training-only-2024')
    app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(minutes=30) # Example: 30 minutes


    db.init_app(app)

    from .routes import main
    app.register_blueprint(main)
    return app