import random
from fastapi import FastAPI, Depends, HTTPException, status, UploadFile, File
from sqlalchemy.orm import Session
import backend.models as models, backend.schemas as schemas, backend.database as database, backend.auth_utils as auth_utils

app = FastAPI()

# টেবিল তৈরি করা
models.Base.metadata.create_all(bind=database.engine)

FERTILIZER_MAP = {
    "Bacterial Leaf Blight": "Use MOP, avoid excess Urea",
    "Brown Spot": "Use MOP, TSP",
    "Healthy Rice Leaf": "No need of fertilizer",
    "Leaf Blast": "Use MOP, avoid excess Urea",
    "Leaf scald": "Use MOP",
    "Sheath Blight": "Use MOP, avoid excess Urea"
}

@app.get("/")
def root():
    return {"status": "Online", "message": "IAmFertilizer API is running"}

# --- AUTH SECTOR ---

@app.post("/auth/register", response_model=schemas.UserOut)
def register(user: schemas.UserCreate, db: Session = Depends(database.get_db)):
    db_user = db.query(models.User).filter(models.User.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    new_user = models.User(
        name=user.name,
        location=user.location,
        email=user.email,
        hashed_password=auth_utils.hash_password(user.password)
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

# --- PREDICTION SECTOR (Mock for now) ---

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    # যেহেতু মডেল নেই, আমরা ৬টি ক্লাসের যেকোনো একটি র্যান্ডমলি রিটার্ন করব
    diseases = list(FERTILIZER_MAP.keys())
    result = random.choice(diseases)
    
    return {
        "disease": result,
        "confidence": "95.5%", # ডামি কনফিডেন্স
        "recommendation": FERTILIZER_MAP[result]
    }