# IAmFertilizer-Smart Fertilizer Recommendation Mobile App

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
1. Authentication: 
 User registration with email and password,
 Email verification,
 Login system,
 Forgot password & reset password option

2. Core Functionality:
   Capture or upload leaf image,
   Analyze crop condition using ML model,
## Rice Leaf Disease Classes

This project can classify rice leaf images into the following categories:

| Class ID | Disease Name |
|---------:|--------------|
| 0 | Bacterial Leaf Blight |
| 1 | Brown Spot |
| 2 | Healthy Rice Leaf |
| 3 | Leaf Blast |
| 4 | Leaf Scald |
| 5 | Sheath Blight |

## Fertilizer Recommendation

Based on the detected disease class, the system provides fertilizer suggestions as shown below:

| Disease Name | Fertilizer Recommendation |
|--------------|----------------------------|
| Bacterial Leaf Blight | Use MOP, avoid excess Urea |
| Brown Spot | Use MOP, TSP |
| Healthy Rice Leaf | No need of fertilizer |
| Leaf Blast | Use MOP, avoid excess Urea |
| Leaf Scald | Use MOP |
| Sheath Blight | Use MOP, avoid excess Urea |

3. Additional Features:
    History of previous analysis,
     Find Farmer (search by name or id or location) and send request, 
      Chat system between farmers,
        User profile details,
   
# Tech Stack:
   1. Frontend- Flutter,
   2. Backend- FastAPI (Python),
   3. Database- PostgreSQL,
   4. Machine Learning- CNN model, 

A. Email verification by custom token-based auth
B. Chat System implemented by REST API + DB-backed polling chat

   
Flutter App
    |
    | HTTP API
    v
FastAPI Backend
    |
    |-- Authentication 
    |-- ML Inference
    |-- Chat System 
    |
    v
PostgreSQL Database

Contributors:- 

Fahim Shahryer Sizan,

Mostafizur Rahman Rifat
