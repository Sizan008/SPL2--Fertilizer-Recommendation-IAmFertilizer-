import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from fastapi import FastAPI, Depends, HTTPException, status, Form
from fastapi.responses import HTMLResponse
from pydantic import BaseModel
from sqlalchemy.orm import Session
from backend import models, schemas, database, auth_utils, email_utils

# Pydantic Schemas
class ForgotPasswordRequest(BaseModel):
    email: str

app = FastAPI()
models.Base.metadata.create_all(bind=database.engine)

# --- অথেন্টিকেশন রাউটস ---

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
    if user:
        user.is_verified = True
        db.commit()
        return {"message": "Email verified successfully!"}
    raise HTTPException(status_code=400, detail="Invalid verification link")

@app.post("/auth/login")
def login(user_login: schemas.UserLogin, db: Session = Depends(database.get_db)):
    user = db.query(models.User).filter(models.User.email == user_login.email).first()
    if not user or not auth_utils.verify_password(user_login.password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    if not user.is_verified:
        raise HTTPException(status_code=403, detail="Email not verified")
    return {"access_token": "fake-jwt-token", "token_type": "bearer"}

# --- Forgot & Reset Password রাউটস ---

@app.post("/auth/forgot-password")
async def forgot_password(request: ForgotPasswordRequest, db: Session = Depends(database.get_db)):
    user = db.query(models.User).filter(models.User.email == request.email).first()
    if not user:
        return {"message": "If this email is registered, you will receive a reset link."}
    
    await email_utils.send_reset_password_email(user.email)
    return {"message": "Reset link sent to your email"}

# ওয়েব পেজ যা পাসওয়ার্ড ইনপুট নিবে
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

# ফর্ম সাবমিট প্রসেস করা
@app.post("/auth/reset-password-submit", response_class=HTMLResponse)
def reset_password_submit(email: str = Form(...), new_password: str = Form(...), db: Session = Depends(database.get_db)):
    user = db.query(models.User).filter(models.User.email == email).first()
    if user:
        user.hashed_password = auth_utils.hash_password(new_password)
        db.commit()
        return "<h3>Password updated successfully! You can now go back to the app and login.</h3>"
    return "<h3>Error: User not found.</h3>"

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)