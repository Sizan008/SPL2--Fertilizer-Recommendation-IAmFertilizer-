from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Boolean
from sqlalchemy.orm import relationship
from datetime import datetime
from backend.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    location = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    is_verified = Column(Boolean, default=False)

    sent_requests = relationship("ChatRequest", foreign_keys="ChatRequest.sender_id", backref="sender")
    received_requests = relationship("ChatRequest", foreign_keys="ChatRequest.receiver_id", backref="receiver")
    sent_messages = relationship("Message", foreign_keys="Message.sender_id", backref="sender_message")
    received_messages = relationship("Message", foreign_keys="Message.receiver_id", backref="receiver_message")
    histories = relationship("AnalysisHistory", backref="user", cascade="all, delete-orphan")


class ChatRequest(Base):
    __tablename__ = "chat_requests"

    id = Column(Integer, primary_key=True, index=True)
    sender_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    receiver_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    status = Column(String, default="pending")
    created_at = Column(DateTime, default=datetime.utcnow)


class Message(Base):
    __tablename__ = "messages"

    id = Column(Integer, primary_key=True, index=True)
    sender_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    receiver_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    content = Column(String, nullable=False)
    timestamp = Column(DateTime, default=datetime.utcnow)


class AnalysisHistory(Base):
    __tablename__ = "analysis_histories"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    image_name = Column(String, nullable=True)
    disease = Column(String, nullable=False)
    confidence = Column(String, nullable=False)
    recommendation = Column(String, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)