from pydantic import BaseModel, EmailStr
from datetime import datetime


class UserCreate(BaseModel):
    name: str
    location: str
    email: EmailStr
    password: str


class UserLogin(BaseModel):
    email: EmailStr
    password: str


class UserOut(BaseModel):
    id: int
    name: str
    location: str
    email: EmailStr
    is_verified: bool

    class Config:
        from_attributes = True


class FarmerOut(BaseModel):
    id: int
    name: str
    location: str
    email: EmailStr

    class Config:
        from_attributes = True


class MessageOut(BaseModel):
    id: int
    sender_id: int
    receiver_id: int
    content: str
    timestamp: datetime

    class Config:
        from_attributes = True


class ChatRequestOut(BaseModel):
    id: int
    sender_id: int
    receiver_id: int
    status: str
    created_at: datetime

    class Config:
        from_attributes = True


class HistoryOut(BaseModel):
    id: int
    image_name: str | None = None
    disease: str
    confidence: str
    recommendation: str
    created_at: datetime

    class Config:
        from_attributes = True