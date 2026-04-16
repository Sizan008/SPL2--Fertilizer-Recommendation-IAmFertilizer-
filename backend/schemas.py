from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import List, Optional

class UserCreate(BaseModel):
    name: str
    location: str
    email: EmailStr
    password: str



# রেজিস্ট্রেশনের জন্য
class UserCreate(BaseModel):
    name: str
    location: str
    email: EmailStr
    password: str

# লগইনের জন্য (এটিই এরর দিচ্ছিল)
class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserOut(BaseModel):
    id: int
    name: str
    email: EmailStr
    class Config:
        from_attributes = True

class PredictionOut(BaseModel):
    disease: str
    confidence: str
    recommendation: str
    class Config:
        from_attributes = True