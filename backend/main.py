import sys
import os
import uvicorn
from fastapi import FastAPI, Depends, HTTPException, status, Form
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
from sqlalchemy.orm import Session
from datetime import datetime

# প্রজেক্ট পাথ সেটআপ
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from backend import models, schemas, database, auth_utils, email_utils

app = FastAPI()

# ডাটাবেস টেবিল তৈরি
models.Base.metadata.create_all(bind=database.engine)

# Pydantic Schemas
class ForgotPasswordRequest(BaseModel):
    email: str

# --- অথেন্টিকেশন ও প্রোফাইল রাউটস ---

@app.post("/auth/register", status_code=status.HTTP_201_CREATED)
async def register(user: schemas.UserCreate, db: Session = Depends(database.get_db)):
    db_user = db.query(models.User).filter(models.User.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    new_user = models.User(
        name=user.name,
        location=user.location,
        email=user.email,
        hashed_password=auth_utils.hash_password(user.password),
        is_verified=False 
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    await email_utils.send_verification_email(new_user.email, new_user.email)
    return {"message": "Registration successful! Please check your email."}

@app.get("/auth/verify")
def verify_email(token: str, db: Session = Depends(database.get_db)):
    user = db.query(models.User).filter(models.User.email == token).first()
    if not user:
        raise HTTPException(status_code=400, detail="Invalid verification link")
    user.is_verified = True 
    db.commit()
    return {"message": "Email verified successfully!"}

@app.get("/auth/status")
def get_auth_status(email: str, db: Session = Depends(database.get_db)):
    user = db.query(models.User).filter(models.User.email == email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return {"is_verified": user.is_verified}

@app.post("/auth/login")
def login(user_login: schemas.UserLogin, db: Session = Depends(database.get_db)):
    user = db.query(models.User).filter(models.User.email == user_login.email).first()
    if not user or not auth_utils.verify_password(user_login.password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    if not user.is_verified:
        raise HTTPException(status_code=403, detail="Email not verified")
    return {"access_token": "fake-jwt-token", "token_type": "bearer", "user_id": user.id}

@app.get("/auth/profile")
def get_profile(email: str, db: Session = Depends(database.get_db)):
    user = db.query(models.User).filter(models.User.email == email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return {
        "id": user.id, 
        "name": user.name, 
        "location": user.location, 
        "email": user.email
    }

# --- পাসওয়ার্ড রিসেট রাউটস ---

@app.post("/auth/forgot-password")
async def forgot_password(request: ForgotPasswordRequest, db: Session = Depends(database.get_db)):
    user = db.query(models.User).filter(models.User.email == request.email).first()
    if not user:
        return {"message": "If this email is registered, you will receive a reset link."}
    await email_utils.send_reset_password_email(user.email)
    return {"message": "Reset link sent to your email"}

@app.get("/auth/reset-password-page", response_class=HTMLResponse)
def reset_password_page(email: str):
    return f"""
    <html>
        <body style="font-family: Arial; padding: 50px;">
            <h3>Reset Your IAmFertilizer Password</h3>
            <form action="/auth/reset-password-submit" method="post">
                <input type="hidden" name="email" value="{email}">
                <input type="password" name="new_password" placeholder="Enter new password" required style="padding: 10px; width: 250px;"><br><br>
                <button type="submit" style="padding: 10px 20px; cursor: pointer;">Submit</button>
            </form>
        </body>
    </html>
    """

@app.post("/auth/reset-password-submit", response_class=HTMLResponse)
def reset_password_submit(email: str = Form(...), new_password: str = Form(...), db: Session = Depends(database.get_db)):
    user = db.query(models.User).filter(models.User.email == email).first()
    if not user:
        return "<h3>Error: User not found.</h3>"
    user.hashed_password = auth_utils.hash_password(new_password)
    db.commit()
    return "<h3>Password updated successfully! You can now go back to the app and login.</h3>"

# --- চ্যাট সিস্টেম রাউটস ---

@app.post("/chat/send-request")
def send_request(sender_id: int, receiver_id: int, db: Session = Depends(database.get_db)):
    new_req = models.ChatRequest(sender_id=sender_id, receiver_id=receiver_id, status="pending")
    db.add(new_req)
    db.commit()
    return {"message": "Request sent"}

@app.get("/chat/received-requests")
def get_received_requests(user_id: int, db: Session = Depends(database.get_db)):
    return db.query(models.ChatRequest).filter(models.ChatRequest.receiver_id == user_id, models.ChatRequest.status == "pending").all()

@app.post("/chat/accept-request")
def accept_request(req_id: int, db: Session = Depends(database.get_db)):
    req = db.query(models.ChatRequest).filter(models.ChatRequest.id == req_id).first()
    if not req:
        raise HTTPException(status_code=404, detail="Request not found")
    req.status = "accepted"
    db.commit()
    return {"message": "Request accepted"}

@app.post("/chat/reject-request")
def reject_request(req_id: int, db: Session = Depends(database.get_db)):
    req = db.query(models.ChatRequest).filter(models.ChatRequest.id == req_id).first()
    if req:
        db.delete(req)
        db.commit()
    return {"message": "Request rejected"}

@app.post("/chat/send-message")
def send_message(sender_id: int, receiver_id: int, content: str, db: Session = Depends(database.get_db)):
    msg = models.Message(sender_id=sender_id, receiver_id=receiver_id, content=content, timestamp=datetime.utcnow())
    db.add(msg)
    db.commit()
    return {"message": "Message sent"}

@app.get("/chat/messages")
def get_messages(user1_id: int, user2_id: int, db: Session = Depends(database.get_db)):
    messages = db.query(models.Message).filter(
        ((models.Message.sender_id == user1_id) & (models.Message.receiver_id == user2_id)) |
        ((models.Message.sender_id == user2_id) & (models.Message.receiver_id == user1_id))
    ).order_by(models.Message.timestamp).all()
    return messages

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)