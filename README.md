# iamfertilizer

Smart Fertilizer Recommendation Project.

Smart Fertilizer Recommendation System
Overview

Smart Fertilizer Recommendation System is a mobile-based application designed to assist paddy farmers in detecting nutrient deficiencies in rice leaves and receiving fertilizer recommendations using machine learning.

The system allows users to capture or upload an image of a rice leaf, analyze it using a trained ML model, and get instant recommendations such as Urea, TSP, or MOP based on detected deficiencies (Nitrogen, Phosphorus, Potassium).

Current Status

This project is currently in the initial development phase.

Frontend (Flutter): UI design completed
Backend (FastAPI): Not implemented yet
Machine Learning Model: Planned (Kaggle dataset will be used)
Database: Planned (PostgreSQL)
Features
Authentication
User registration with email and password
Email verification
Login system
Forgot password and reset password
Core Functionality
Capture or upload leaf image
Analyze crop condition using ML model
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
