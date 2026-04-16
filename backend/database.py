from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# আপনার PostgreSQL ডাটাবেস URL
SQLALCHEMY_DATABASE_URL = "postgresql://postgres:postgres123@localhost/iamfertilizer_db"

# ডাটাবেস ইঞ্জিন তৈরি করা
engine = create_engine(SQLALCHEMY_DATABASE_URL)

# সেশন ফ্যাক্টরি তৈরি করা
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# ডিক্লারেটিভ বেস (এটি মডেল তৈরির সময় ব্যবহার হবে)
Base = declarative_base()

# ডাটাবেস ডিপেন্ডেন্সি ফাংশন
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# টেবিল তৈরি করার ফাংশন (প্রয়োজন হলে মেইন ফাইলে কল করবেন)
def init_db():
    import models # এখানে আপনার মডেল ফাইলটি ইম্পোর্ট করতে হবে
    Base.metadata.create_all(bind=engine)