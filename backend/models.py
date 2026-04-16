from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Boolean
from sqlalchemy.orm import relationship
from datetime import datetime
from backend.database import Base

class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String)
    location = Column(String)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    # DatatypeMismatch এরর এড়াতে Boolean ব্যবহার করা হয়েছে
    is_verified = Column(Boolean, default=False) 

    # Relationships
    sent_requests = relationship("ChatRequest", foreign_keys="ChatRequest.sender_id", backref="sender")
    received_requests = relationship("ChatRequest", foreign_keys="ChatRequest.receiver_id", backref="receiver")
    sent_messages = relationship("Message", foreign_keys="Message.sender_id", backref="sender_message")
    received_messages = relationship("Message", foreign_keys="Message.receiver_id", backref="receiver_message")

class ChatRequest(Base):
    __tablename__ = "chat_requests"
    
    id = Column(Integer, primary_key=True, index=True)
    sender_id = Column(Integer, ForeignKey("users.id"))
    receiver_id = Column(Integer, ForeignKey("users.id"))
    status = Column(String, default="pending") 
    created_at = Column(DateTime, default=datetime.utcnow)

class Message(Base):
    __tablename__ = "messages"
    
    id = Column(Integer, primary_key=True, index=True)
    sender_id = Column(Integer, ForeignKey("users.id"))
    receiver_id = Column(Integer, ForeignKey("users.id"))
    content = Column(String)
    timestamp = Column(DateTime, default=datetime.utcnow)