from passlib.context import CryptContext
# auth_utils.py
import secrets
import string

def generate_reset_token():
    # ৮ অক্ষরের একটি র‍্যান্ডম টোকেন তৈরি করবে
    return ''.join(secrets.choice(string.ascii_uppercase + string.digits) for _ in range(8))

# পাসওয়ার্ড হ্যাশিং সেটআপ
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def hash_password(password: str):
    # পাসওয়ার্ড বড় হলেbcrypt কাজ করে না, তাই প্রথম ৭২ ক্যারেক্টার নেওয়া হয়
    return pwd_context.hash(password[:72])

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password[:72], hashed_password)