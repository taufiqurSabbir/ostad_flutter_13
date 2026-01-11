# 📱 Task Manager - Professional Flutter App with Provider State Management

A professional Flutter task management application demonstrating **Provider state management** best practices. This project is designed for teaching and learning modern Flutter development with clean architecture and industry-standard patterns.

## ✨ Features

- 🔐 **User Authentication** (Login, Registration, Profile Management)
- ✅ **Task Management** (Create, Read, Update, Delete)
- 📊 **Task Status Tracking** (New, Progress, Completed, Cancelled)
- 🔄 **Real-time State Updates** with Provider
- 🎨 **Professional UI/UX** with Material Design
- 🌐 **RESTful API Integration**
- 💾 **Local Data Persistence** with SharedPreferences
- 🔔 **Loading States & Error Handling**
- ♻️ **Pull-to-Refresh** functionality

## 🏗️ Architecture

This project follows **Clean Architecture** principles with **Provider** for state management:

```
lib/
├── core/                    # Core utilities (constants, enums)
├── data/                    # Data layer (models, services, utils)
├── providers/               # State management layer
└── ui/                      # Presentation layer (screens, widgets)
```

### State Management

- **AuthProvider**: Manages authentication state, user data, and session
- **TaskProvider**: Handles task CRUD operations and task lists
- **NetworkProvider**: Manages API calls and network states

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.1.5 <4.0.0)
- Dart SDK
- Android Studio / VS Code
- An Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd task_manager
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Key Dependencies

- `provider: ^6.1.2` - State management
- `http: ^1.6.0` - API calls
- `shared_preferences` - Local storage
- `logger: ^2.6.2` - Logging

## 📚 Teaching Guide

This project comes with a comprehensive teaching guide: **[PROVIDER_TEACHING_GUIDE.md](PROVIDER_TEACHING_GUIDE.md)**

The guide includes:
- Step-by-step implementation walkthrough
- Best practices and patterns
- Classroom teaching strategies
- Practice exercises

## 🎓 Key Concepts Demonstrated

### 1. Provider Setup
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => TaskProvider()),
    ChangeNotifierProvider(create: (_) => NetworkProvider()),
  ],
  child: TaskManagerApp(),
)
```

### 2. Consumer Pattern
```dart
Consumer<TaskProvider>(
  builder: (context, taskProvider, child) {
    if (taskProvider.isLoading) return CircularProgressIndicator();
    return ListView.builder(...);
  },
)
```

### 3. Provider Actions
```dart
final provider = Provider.of<TaskProvider>(context, listen: false);
await provider.createTask(title: '...', description: '...');
```

## 📱 Screens Overview

- **Splash Screen** - Auto-login check
- **Login Screen** - User authentication  
- **Sign Up Screen** - New user registration
- **Task List** - View tasks by status
- **Add Task** - Create new tasks
- **Profile** - Update user information

## 🎯 Professional Features

✅ Clean Architecture
✅ Separation of Concerns
✅ Type-safe Enums
✅ Centralized Constants
✅ Comprehensive Error Handling
✅ Loading States
✅ Input Validation
✅ Responsive UI

## 👨‍🏫 For Instructors

Check [PROVIDER_TEACHING_GUIDE.md](PROVIDER_TEACHING_GUIDE.md) for complete lesson plans and teaching strategies.

## 📝 License

This project is open source and available for educational purposes.

---

**Built with ❤️ for learning Flutter with Provider state management**
