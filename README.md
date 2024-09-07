# Educatly 

**Task Title:** Real-Time Chat Interface with Firebase Integration, Online Status, and Typing Indicators (Android Only) Using a Basic Dark Theme (Figma design file).

### Objective
Develop a simple real-time chat interface using Flutter and Firebase, focusing on user authentication, real-time messaging, online status, and typing indicators. The application should be compatible with Android only and follow the specified design.

### Design Reference
Use the Text Chat Bubbles UI Kit with the basic dark theme, implementing the functionality mentioned in the task only.

### Task Details
1. **User Authentication:**
   - Implement user authentication using Firebase Auth.
   - Include Sign Up, Login, and Logout functionalities.
   - Ensure secure storage of user credentials using Flutter Secure Storage.

2. **Real-Time Messaging:**
   - Set up Firebase Firestore for real-time messaging.
   - Implement functionality to send and receive messages instantly.
   - Display chat history with timestamps.

3. **Online Status and Typing Indicators:**
   - Implement online status indicators for users.
   - Implement typing indicators to show when a user is typing a message in real time.

4. **Chat Interface:**
   - Design a user-friendly chat interface with the following features:
     - Display messages in a chat bubble format.
     - Show user avatars and message timestamps.
     - Implement a text input field and send button.

5. **State Management:**
   - Use a simple state management solution like Bloc to manage the application state.

6. **Push Notifications (Optional):**
   - Implement push notifications using Firebase Cloud Messaging to alert users of new messages.

### Submission Guidelines
- Provide the source code via a GitHub repository.
- Ensure that the project is well-documented, with clear instructions on how to set up and run the application on an Android device or emulator.

### Evaluation Criteria
- Code quality and organization.
- Adherence to best practices for Flutter development.
- Completeness and functionality of the real-time messaging, online status, and typing indicators.
- User experience and interface design based on the provided Figma design.
- Clarity and completeness of documentation.

---

# Chat App

A Flutter application designed for managing travel destinations and enabling real-time chat functionality. This project adheres to the Clean Code Architecture and incorporates a variety of design patterns and technologies including Bloc for state management, Firebase for authentication, Firestore for real-time database, and Firebase Cloud Storage for media storage.

## Table of Contents
- [Features](#features)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the App](#running-the-app)
- [Usage](#usage)
  - [App Layer](#app-layer)
  - [Features Layer](#features-layer)
  - [Shared Layer](#shared-layer)
- [APIs](#apis)
- [State Management](#state-management)
- [Dependency Injection](#dependency-injection)

## Features
- **Clean Code Architecture:** Enforces a separation of concerns, making the project modular and testable.
- **Singleton Pattern:** Ensures a single instance of network clients and other services throughout the app.
- **Dio with Retrofit:** Manages HTTP requests efficiently with robust networking capabilities.
- **Bloc State Management:** Manages the app's state predictably and allows easy testing of state transitions.
- **GetIt Dependency Injection:** Provides a simple and efficient way to manage and inject dependencies throughout the app.

## Firebase Integration
- **Authentication:** User login and registration using Firebase Authentication.
- **Firestore:** Real-time data storage and retrieval for Chat.
- **Chat Functionality:** Real-time chat with support for text and image messages, with history stored in Firestore.

## Getting Started
### Prerequisites
- Flutter SDK
- Firebase Project with Firestore, Authentication, and Cloud Storage enabled

### Installation
- Clone the repository.
- Navigate to the project directory.
- Run `flutter pub get` to install dependencies.
- Set up Firebase in your project by following the official Firebase setup guide.
- Initialize Hive for offline data storage.

## Running the App
- Use `flutter run` to launch the app on a simulator or connected device.
- Ensure that Firebase is configured correctly to enable authentication and database features.

## Usage
### App Layer
This layer contains the core application logic, including network setup, error handling, and dependency injection.

### Features Layer
This layer is divided into several sub-modules, each representing a feature of the app like authentication and chat.

### Shared Layer
Contains resources and utilities that are shared across the app.

## Project Structure
The project is organized into three main layers: `app`, `features`, and `shared`.

### **`lib/`**
```plaintext
lib/
├── app/                    # Core application-level logic
│   ├── network/            # Network-related classes (e.g., Dio setup, API client)
│   ├── error/              # Error handling (exceptions, failures)
│   ├── di/                 # Dependency injection setup
│
├── features/               # Feature-specific logic
│   ├── auth/               # Authentication feature
│   │   ├── data/           # Data layer for authentication
│   │   ├── domain/         # Domain layer for authentication
│   │   └── presentation/   # UI and state management for authentication
│   │
│   ├── chat/               # Chat feature
│   │   ├── data/           # Data layer for chat
│   │   ├── domain/         # Domain layer for chat
│   │   └── presentation/   # UI and state management for chat    
│  
└── shared/                 # Shared resources across the app
    ├── constants/          # App-wide constants
    └── utils/              # Utility classes and helpers
