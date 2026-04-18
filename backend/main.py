import io
import os
from datetime import datetime
from typing import Optional

import numpy as np
from PIL import Image
from fastapi import FastAPI, Depends, HTTPException, status, UploadFile, File, Form, Header
from fastapi.responses import HTMLResponse
from sqlalchemy.orm import Session
from sqlalchemy import or_, and_

from backend import models, schemas, database, auth_utils, email_utils

app = FastAPI()

# -----------------------------
# DATABASE
# -----------------------------
models.Base.metadata.create_all(bind=database.engine)

# -----------------------------
# MODEL LOADING
# -----------------------------
MODEL = None
TF_AVAILABLE = False

MODEL_PATH = os.path.join(os.path.dirname(__file__), "model", "rice_disease_model.keras")

CLASS_NAMES = [
    "Bacterial Leaf Blight",
    "Brown Spot",
    "Healthy Rice Leaf",
    "Leaf Blast",
    "Leaf scald",
    "Sheath Blight"
]

FERTILIZER_MAP = {
    "Bacterial Leaf Blight": "Use MOP, avoid excess Urea",
    "Brown Spot": "Use MOP, TSP",
    "Healthy Rice Leaf": "No need of fertilizer",
    "Leaf Blast": "Use MOP, avoid excess Urea",
    "Leaf scald": "Use MOP",
    "Sheath Blight": "Use MOP, avoid excess Urea"
}

try:
    import tensorflow as tf
    TF_AVAILABLE = True

    if os.path.exists(MODEL_PATH):
        MODEL = tf.keras.models.load_model(MODEL_PATH)
        print(f"Model loaded successfully from: {MODEL_PATH}")
    else:
        print(f"Model file not found at: {MODEL_PATH}")
except Exception as e:
    MODEL = None
    TF_AVAILABLE = False
    print(f"Model loading failed: {e}")


# -----------------------------
# HELPERS
# -----------------------------
def preprocess_image(image_bytes: bytes):
    img = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    img = img.resize((128, 128))
    img_array = np.array(img, dtype=np.float32)
    input_array = np.expand_dims(img_array, axis=0)
    return input_array


def create_simple_token(user_id: int) -> str:
    return f"user:{user_id}"


def get_user_id_from_token(authorization: Optional[str]) -> Optional[int]:
    if not authorization:
        return None

    if not authorization.startswith("Bearer "):
        return None

    token = authorization.replace("Bearer ", "").strip()

    if not token.startswith("user:"):
        return None

    try:
        return int(token.split(":")[1])
    except Exception:
        return None


def get_current_user(
    authorization: Optional[str] = Header(None),
    db: Session = Depends(database.get_db)
):
    user_id = get_user_id_from_token(authorization)
    if not user_id:
        raise HTTPException(status_code=401, detail="Invalid or missing token")

    user = db.query(models.User).filter(models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=401, detail="User not found")

    return user


# -----------------------------
# ROOT
# -----------------------------
@app.get("/")
def root():
    return {"status": "Online", "message": "IAmFertilizer API is running"}


# -----------------------------
# AUTH
# -----------------------------
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
        is_verified=False,
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    # token হিসেবে আপাতত email-ই পাঠানো হচ্ছে
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

    token = create_simple_token(user.id)

    return {
        "access_token": token,
        "token_type": "bearer",
        "user_id": user.id,
        "email": user.email,
        "message": "Login successful!"
    }


@app.get("/auth/me")
def get_me(current_user: models.User = Depends(get_current_user)):
    return {
        "id": current_user.id,
        "name": current_user.name,
        "location": current_user.location,
        "email": current_user.email,
        "is_verified": current_user.is_verified
    }


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


@app.post("/auth/forgot-password")
async def forgot_password(payload: dict, db: Session = Depends(database.get_db)):
    email = payload.get("email")

    if not email:
        raise HTTPException(status_code=400, detail="Email is required")

    user = db.query(models.User).filter(models.User.email == email).first()

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
def reset_password_submit(
    email: str = Form(...),
    new_password: str = Form(...),
    db: Session = Depends(database.get_db)
):
    user = db.query(models.User).filter(models.User.email == email).first()
    if not user:
        return "<h3>Error: User not found.</h3>"

    user.hashed_password = auth_utils.hash_password(new_password)
    db.commit()

    return "<h3>Password updated successfully! You can now go back to the app and login.</h3>"


@app.post("/auth/reset-password")
def reset_password_api(payload: dict, db: Session = Depends(database.get_db)):
    email = payload.get("email")
    new_password = payload.get("new_password")

    if not email or not new_password:
        raise HTTPException(status_code=400, detail="Email and new_password are required")

    user = db.query(models.User).filter(models.User.email == email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    user.hashed_password = auth_utils.hash_password(new_password)
    db.commit()

    return {"message": "Password updated successfully"}


# -----------------------------
# FARMER SEARCH
# -----------------------------
@app.get("/farmers/search")
def search_farmers(
    q: str = "",
    current_user_id: int = 0,
    db: Session = Depends(database.get_db)
):
    query = db.query(models.User).filter(models.User.id != current_user_id)

    if q.strip():
        like_q = f"%{q.strip()}%"

        if q.isdigit():
            query = query.filter(
                or_(
                    models.User.id == int(q),
                    models.User.name.ilike(like_q),
                    models.User.location.ilike(like_q),
                    models.User.email.ilike(like_q),
                )
            )
        else:
            query = query.filter(
                or_(
                    models.User.name.ilike(like_q),
                    models.User.location.ilike(like_q),
                    models.User.email.ilike(like_q),
                )
            )

    users = query.order_by(models.User.id.desc()).all()

    return [
        {
            "id": u.id,
            "name": u.name,
            "location": u.location,
            "email": u.email,
            "is_verified": u.is_verified,
        }
        for u in users
    ]


# -----------------------------
# CHAT REQUESTS
# -----------------------------
@app.post("/chat/send-request")
def send_request(sender_id: int, receiver_id: int, db: Session = Depends(database.get_db)):
    if sender_id == receiver_id:
        raise HTTPException(status_code=400, detail="You cannot send request to yourself")

    sender = db.query(models.User).filter(models.User.id == sender_id).first()
    receiver = db.query(models.User).filter(models.User.id == receiver_id).first()

    if not sender or not receiver:
        raise HTTPException(status_code=404, detail="User not found")

    existing = db.query(models.ChatRequest).filter(
        or_(
            and_(models.ChatRequest.sender_id == sender_id, models.ChatRequest.receiver_id == receiver_id),
            and_(models.ChatRequest.sender_id == receiver_id, models.ChatRequest.receiver_id == sender_id),
        )
    ).first()

    if existing:
        if existing.status == "pending":
            raise HTTPException(status_code=400, detail="Request already pending")
        if existing.status == "accepted":
            raise HTTPException(status_code=400, detail="Already connected")

    new_req = models.ChatRequest(
        sender_id=sender_id,
        receiver_id=receiver_id,
        status="pending"
    )
    db.add(new_req)
    db.commit()

    return {"message": "Request sent"}


@app.get("/chat/received-requests")
def get_received_requests(user_id: int, db: Session = Depends(database.get_db)):
    requests = db.query(models.ChatRequest).filter(
        models.ChatRequest.receiver_id == user_id,
        models.ChatRequest.status == "pending"
    ).order_by(models.ChatRequest.created_at.desc()).all()

    result = []
    for req in requests:
        sender = db.query(models.User).filter(models.User.id == req.sender_id).first()
        result.append({
            "id": req.id,
            "sender_id": req.sender_id,
            "sender_name": sender.name if sender else f"Farmer {req.sender_id}",
            "sender_location": sender.location if sender else "",
            "status": req.status
        })

    return result


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
    if not req:
        raise HTTPException(status_code=404, detail="Request not found")

    req.status = "rejected"
    db.commit()

    return {"message": "Request rejected"}


@app.get("/chat/conversations")
def get_conversations(user_id: int, db: Session = Depends(database.get_db)):
    accepted = db.query(models.ChatRequest).filter(
        models.ChatRequest.status == "accepted",
        or_(
            models.ChatRequest.sender_id == user_id,
            models.ChatRequest.receiver_id == user_id
        )
    ).all()

    conversations = []
    for item in accepted:
        partner_id = item.receiver_id if item.sender_id == user_id else item.sender_id
        partner = db.query(models.User).filter(models.User.id == partner_id).first()

        last_message = db.query(models.Message).filter(
            or_(
                and_(models.Message.sender_id == user_id, models.Message.receiver_id == partner_id),
                and_(models.Message.sender_id == partner_id, models.Message.receiver_id == user_id),
            )
        ).order_by(models.Message.timestamp.desc()).first()

        conversations.append({
            "partner_id": partner_id,
            "partner_name": partner.name if partner else f"Farmer {partner_id}",
            "partner_location": partner.location if partner else "",
            "last_message": last_message.content if last_message else "Start chatting",
            "last_time": last_message.timestamp.isoformat() if last_message else None,
        })

    return conversations


# -----------------------------
# CHAT MESSAGES
# -----------------------------
@app.post("/chat/send-message")
def send_message(sender_id: int, receiver_id: int, content: str, db: Session = Depends(database.get_db)):
    content = content.strip()

    if not content:
        raise HTTPException(status_code=400, detail="Message cannot be empty")

    accepted = db.query(models.ChatRequest).filter(
        models.ChatRequest.status == "accepted",
        or_(
            and_(models.ChatRequest.sender_id == sender_id, models.ChatRequest.receiver_id == receiver_id),
            and_(models.ChatRequest.sender_id == receiver_id, models.ChatRequest.receiver_id == sender_id),
        )
    ).first()

    if not accepted:
        raise HTTPException(status_code=403, detail="You are not connected yet")

    msg = models.Message(
        sender_id=sender_id,
        receiver_id=receiver_id,
        content=content,
        timestamp=datetime.utcnow()
    )

    db.add(msg)
    db.commit()

    return {"message": "Message sent"}


@app.get("/chat/messages")
def get_messages(user1_id: int, user2_id: int, db: Session = Depends(database.get_db)):
    messages = db.query(models.Message).filter(
        or_(
            and_(models.Message.sender_id == user1_id, models.Message.receiver_id == user2_id),
            and_(models.Message.sender_id == user2_id, models.Message.receiver_id == user1_id),
        )
    ).order_by(models.Message.timestamp.asc()).all()

    return [
        {
            "id": msg.id,
            "sender_id": msg.sender_id,
            "receiver_id": msg.receiver_id,
            "content": msg.content,
            "timestamp": msg.timestamp.isoformat(),
        }
        for msg in messages
    ]


# -----------------------------
# PREDICT + SAVE HISTORY
# -----------------------------
@app.post("/predict")
async def predict(
    file: UploadFile = File(...),
    authorization: Optional[str] = Header(None),
    db: Session = Depends(database.get_db)
):
    allowed_types = [
        "image/jpeg",
        "image/png",
        "image/jpg",
        "image/webp",
        "image/heic",
        "image/heif",
        "application/octet-stream",
    ]

    if file.content_type not in allowed_types:
        raise HTTPException(
            status_code=400,
            detail=f"Unsupported file type: {file.content_type}"
        )

    image_data = await file.read()

    # extra validation: file actually image কিনা
    try:
        img = Image.open(io.BytesIO(image_data))
        img.verify()
    except Exception:
        raise HTTPException(status_code=400, detail="Uploaded file is not a valid image")

    if MODEL is None or not TF_AVAILABLE:
        raise HTTPException(status_code=500, detail="Model not loaded properly")

    try:
        processed = preprocess_image(image_data)

        predictions = MODEL.predict(processed)
        probabilities = tf.nn.softmax(predictions[0]).numpy()

        predicted_index = int(np.argmax(probabilities))
        predicted_class = CLASS_NAMES[predicted_index]
        confidence = float(probabilities[predicted_index]) * 100
        confidence_text = f"{confidence:.2f}%"
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction failed: {str(e)}")

    recommendation = FERTILIZER_MAP.get(predicted_class, "Consult an expert")

    user_id = get_user_id_from_token(authorization)
    if user_id:
        history = models.AnalysisHistory(
            user_id=user_id,
            image_name=file.filename,
            disease=predicted_class,
            confidence=confidence_text,
            recommendation=recommendation,
        )
        db.add(history)
        db.commit()

    return {
        "disease": predicted_class,
        "confidence": confidence_text,
        "recommendation": recommendation,
    }

# -----------------------------
# HISTORY
# -----------------------------
@app.get("/history")
def get_history(
    current_user: models.User = Depends(get_current_user),
    db: Session = Depends(database.get_db)
):
    histories = db.query(models.AnalysisHistory).filter(
        models.AnalysisHistory.user_id == current_user.id
    ).order_by(models.AnalysisHistory.created_at.desc()).all()

    return [
        {
            "id": item.id,
            "image_name": item.image_name,
            "disease": item.disease,
            "confidence": item.confidence,
            "recommendation": item.recommendation,
            "created_at": item.created_at.isoformat(),
        }
        for item in histories
    ]