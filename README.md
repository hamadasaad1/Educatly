# Chat App

A Flutter application designed for managing travel destinations and enabling real-time chat functionality. This project adheres to the Clean Code Architecture and incorporates a variety of design patterns and technologies including Bloc for state management, Firebase for authentication, Firestore for real-time database, Firebase Cloud Storage for media storage, and Hive for local offline-first functionality.


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
- [Local Database](#local-database)
- [Dependency Injection](#dependency-injection)


## Features

- Clean Code Architecture: Enforces a separation of concerns, making the project modular and testable.
- Singleton Pattern: Ensures a single instance of network clients and other services throughout the app.
- Dio with Retrofit: Manages HTTP requests efficiently with robust networking capabilities.
- Bloc State Management: Manages the app's state predictably and allows easy testing of state transitions.
- Hive Database: Provides local storage solutions for caching and offline access to recipes and travel - - destinations.
- GetIt Dependency Injection: Provides a simple and efficient way to manage and inject dependencies throughout - the app.
## Firebase Integration:

- Authentication: User login and registration using Firebase Authentication.
- Firestore: Real-time data storage and retrieval for recipes and travel destinations.
- Cloud Storage: Handling image uploads for chat and travel destinations.
- Chat Functionality: Real-time chat with support for text and image messages, with history stored in Firestore.
- Offline-First Functionality: Ensures the app works seamlessly offline, with data being cached locally using - Hive and synced with Firestore when a connection is available.
- Online/Offline Detection: A service class monitors network status and decides whether to fetch data from - local storage (Hive) or Firestore.
## Getting Started
- Prerequisites
- Flutter SDK
- Firebase Project with Firestore, Authentication, and Cloud Storage enabled
- Hive  setup for local storage
## Installation

- Clone the repository.
- Navigate to the project directory.
- Run flutter pub get to install dependencies.
- Set up Firebase in your project by following the official Firebase setup guide.
- Initialize Hive  for offline data storage.
## Running the App

- Use flutter run to launch the app on a simulator or connected device.
- Ensure that Firebase is configured correctly to enable authentication and database features.

## Usage
- App Layer
- This layer contains the core application logic including network setup, error handling, and dependency injection.

-Features Layer
-This layer is divided into several sub-modules, each representing a feature of the app like authentication, chat, and travel.

## Shared Layer
- Contains resources and utilities that are shared across the app.

- Local Database
- Hive is used for offline storage of travel destinations.
- Data is cached locally and synced with Firestore when online.
## Firebase Integration
- Authentication: Implemented with Firebase Authentication.
- Firestore: Used for real-time data storage and retrieval.
- Cloud Storage: Used for storing media files like images.
- Chat Functionality
## Chat with support using the following credentials:
- Username: support@gmail.com
- Password: 12345678
## Offline-First Functionality
- Service Class: Monitors network status using connectivity_plus and provides online/offline status.
- TravelLocalDataSource: Caches data in Hive and retrieves it when offline.
- TravelRepositoryImpl: Determines whether to fetch data from TravelRemoteDataSource (online) or - - - TravelLocalDataSource (offline).

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
│   │
│   ├── travel/             # Travel feature
│   │   ├── data/           # Data layer for travel destinations
│   │   ├── domain/         # Domain layer for travel
│   │   └── presentation/   # UI and state management for travel
│
└── shared/                 # Shared resources across the app
    ├── constants/          # App-wide constants
    └── utils/              # Utility classes and helpers
