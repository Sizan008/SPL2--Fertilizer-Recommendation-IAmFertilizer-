# iamfertilizer-Smart Fertilizer Recommendation Mobile App

Identify disease of Rice Leaf & Smart Fertilizer Recommendation:-
Overview

Smart Fertilizer Recommendation System is a mobile-based application designed to assist paddy/rice farmers in detecting disease in rice leaves and receiving fertilizer recommendations using machine learning.

The system allows users to capture or upload an image of a rice leaf, analyze it using a trained ML model, and get instant recommendations such as Urea, TSP, or MOP based on detected disease.

# Current Status:

1. Frontend (Flutter): UI design completed
2. Backend (FastAPI): Completed
3. Machine Learning Model: used CNN, Implementation completed
4. Database: PostgreSQL- completed
5. Backend Hosting is not completed, we will host it on render soon.

#Features
1. Authentication
User registration with email and password,
Email verification,
Login system,
Forgot password & reset password option
2. Core Functionality
Capture or upload leaf image,
Analyze crop condition using ML model,
Detect:
Healthy
Nitrogen deficiency
Phosphorus deficiency
Potassium deficiency
Provide fertilizer recommendation
Additional Features
History of previous analyses
Farmer directory (search by name and location)
Chat system between farmers
User profile management
Tech Stack
Frontend
Flutter
Backend (Planned)
FastAPI (Python)
Database (Planned)
PostgreSQL
Machine Learning (Planned)
Model trained using Kaggle dataset
Authentication (Planned)
JWT-based authentication
Email verification via SMTP
Project Architecture (Planned)
Flutter App
    |
    | HTTP API
    v
FastAPI Backend
    |
    |-- Authentication (JWT)
    |-- ML Inference
    |-- Chat System (WebSocket)
    |
    v
PostgreSQL Database
Folder Structure (Planned)
project-root/
│
├── frontend/        # Flutter app
├── backend/         # FastAPI server
├── ml-model/        # ML training and inference
├── docs/            # SRS and documentation
└── README.md
Installation (Frontend Only)
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name/frontend
flutter pub get
flutter run
Future Work
Implement FastAPI backend
Integrate PostgreSQL database
Train and integrate ML model
Implement authentication (JWT + email verification)
Develop real-time chat system using WebSocket
Deploy application
Contributors
Fahim Shahryer Sizan
Mostafizur Rahman Rifat
