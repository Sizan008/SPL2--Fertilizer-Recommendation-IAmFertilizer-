from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# 'your_password' এর জায়গায় pgAdmin এর পাসওয়ার্ড দিন
SQLALCHEMY_DATABASE_URL = "postgresql://postgres:postgres123@localhost/iamfertilizer_db"

engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()