# Daily Tracker - Note Taker App

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Latest-FFCA28?logo=firebase)](https://firebase.google.com)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web%20%7C%20Desktop-007AFF)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A production-ready cross-platform Flutter application for managing daily notes with real-time synchronization powered by Firebase. Built with modern architecture patterns and full authentication support.

---

## 🚀 Latest Update (Patch v1.0.0)

### ✨ New Features
- **Complete Authentication System**: Email/Password, Google Sign-In, and Anonymous (Guest) login
- **Rich Text Editor**: Full-featured note editor powered by Flutter Quill
- **Firebase Realtime Integration**: Seamless data synchronization across devices
- **User-Specific Data Isolation**: Secure, per-user note management
- **Horizontal Week View**: Intuitive date selection and note browsing
- **Formatted Text Preview**: Beautiful note preview with rich formatting support

### 🔧 Improvements
- Enhanced authentication flow with session persistence
- Optimized note loading and filtering performance
- Improved UI/UX with modern gradient designs
- Better error handling and user feedback
- Multi-language support (English, Vietnamese)

### 🐛 Bug Fixes
- Fixed authentication state management issues
- Resolved note synchronization conflicts
- Fixed date filtering edge cases
- Improved anonymous user session handling

---

## 📋 Table of Contents

- [Features](#-features)
- [Getting Started](#-getting-started)
- [Configuration](#-configuration)
- [Project Structure](#-project-structure)
- [Dependencies](#-dependencies)
- [Platform Support](#-platform-support)
- [Security](#-security)
- [Contributing](#-contributing)
- [License](#-license)

---

## ✨ Features

### 🔐 Authentication & User Management
- **Email/Password Authentication**: Secure account registration and login
- **Google Sign-In**: One-tap authentication with Google accounts
- **Anonymous/Guest Mode**: Use the app without account creation
- **Automatic Session Management**: Seamless authentication state handling
- **User Profiles**: Stored in Firebase Realtime Database

### 📝 Note Management
- **Rich Text Editor**: Full-featured editor with formatting options (bold, italic, lists, etc.)
- **CRUD Operations**: Create, read, update, and delete notes
- **Date-Based Organization**: Filter and view notes by specific dates
- **Color Coding**: Customize note colors for better categorization
- **Formatted Preview**: Rich text preview with full formatting support
- **Soft Delete**: Recoverable note deletion

### 🎨 User Interface
- **Modern Design**: Clean, gradient-based UI with smooth animations
- **Responsive Layout**: Optimized for all screen sizes
- **Horizontal Week View**: Intuitive date navigation
- **Sidebar Navigation**: Quick access to app features
- **Settings Screen**: Account and app configuration options
- **Multi-language Support**: English and Vietnamese localization

### ☁️ Firebase Integration
- **Firebase Authentication**: Multiple authentication providers
- **Realtime Database**: Live data synchronization
- **User Data Isolation**: Secure, per-user data access
- **Offline Support**: Automatic sync when connection is restored

---

## 📦 Project Structure

Typical layout of key app modules and files:

```
lib/
├── core/
│   ├── routes/               # AppRouter, route names
│   ├── services/             # AuthService, NoteService, Firebase wiring
│   └── themes/               # Light/Dark theme
├── data/
│   ├── models/               # Note, UserProfile, enums
│   └── repositories/         # NoteRepository, UserRepository
├── presentation/
│   ├── screens/              # HomeScreen, EditorScreen, SettingsScreen
│   ├── widgets/              # Reusable UI components
│   └── state/                # State management (e.g. Provider/Bloc)
└── shared/
    └── widgets/
        └── NoteCards.dart    # Note card list/grid UI
```

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.9.2 or higher
- **Dart SDK**: 3.9.2 or higher
- **Firebase Account**: Active Firebase project
- **Platform-specific Tools**:
  - Android Studio / Xcode (for mobile development)
  - Chrome (for web development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd daily_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase** (see [Configuration](#-configuration) below)

4. **Run the app**
   ```bash
   flutter run
   ```

### Quick Start Commands

```bash
# Install dependencies
flutter pub get

# Run on connected device
flutter run

# Run tests
flutter test

# Build for production
flutter build apk --release        # Android
flutter build ios --release         # iOS
flutter build web --release         # Web
```

---

## 📚 Dependencies

Core runtime dependencies (see `pubspec.yaml` for the complete list and versions):

- flutter, flutter_localizations
- firebase_core, firebase_auth, firebase_database
- google_sign_in
- flutter_quill (rich text editor)
- provider / riverpod / bloc (choose one for state management)
- intl, collection

Development tooling:

- flutter_lints, very_good_analysis (optional)
- flutterfire_cli (for Firebase configuration)

Install/update:

```bash
flutter pub get
flutter pub upgrade --major-versions
```

---

## ⚙️ Configuration

### Firebase Setup

#### 1. Create Firebase Project
- Visit [Firebase Console](https://console.firebase.google.com/)
- Create a new project or use an existing one
- Enable billing if using Realtime Database (Blaze plan)

#### 2. Enable Authentication Methods
Navigate to **Authentication > Sign-in method** and enable:
- ✅ **Email/Password**
- ✅ **Anonymous** (for guest access)
- ✅ **Google** (configure OAuth consent screen)

#### 3. Setup Realtime Database
- Navigate to **Realtime Database**
- Create a new database (choose your preferred location)
- Configure security rules (see [Security](#-security) section)

#### 4. Add Firebase Configuration Files

**Android:**
- Download `google-services.json` from Firebase Console
- Place in `android/app/google-services.json`

**iOS:**
- Download `GoogleService-Info.plist` from Firebase Console
- Place in `ios/Runner/GoogleService-Info.plist`

**Web:**
- Add Firebase config to `web/index.html`
- See Firebase Web setup documentation

**Automatic Configuration:**
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for all platforms
flutterfire configure
```

### Google Sign-In Setup

For detailed Google Sign-In configuration instructions, see `GOOGLE_SIGN_IN_SETUP.md`.

**Quick Setup:**
1. Enable Google Sign-In in Firebase Console
2. Add SHA-1 fingerprint (Android) or configure OAuth (iOS/Web)
3. Download updated configuration files
4. Test authentication flow

---

## 📱 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android  | ✅ Full Support | Minimum SDK: 21 |
| iOS      | ✅ Full Support | Minimum iOS: 12.0 |
| Web      | ✅ Full Support | Chrome, Firefox, Safari |
| Windows  | ✅ Full Support | Windows 10+ |
| macOS    | ✅ Full Support | macOS 10.14+ |
| Linux    | ✅ Full Support | Ubuntu 18.04+ |

---

## 🔒 Security

### Authentication Security
- Secure password hashing via Firebase Authentication
- OAuth 2.0 for Google Sign-In
- Token-based session management
- Automatic token refresh

### Data Security
- User-specific data isolation (userId filtering)
- Firebase Security Rules enforcement
- Secure note storage with encryption in transit
- Anonymous user data cleanup

---

## 🔄 Update Notes

### Version 1.0.0 (Current)

**Major Features Added:**
- Complete authentication system with multiple providers
- Rich text note editing capabilities
- Firebase Realtime Database integration
- User-specific data management
- Modern UI with horizontal week view

**Technical Improvements:**
- Clean architecture implementation
- Repository pattern for data access
- State management optimization
- Error handling enhancements
- Performance optimizations

**Known Issues:**
- None reported

**Migration Notes:**
- This is the initial production release
- No migration required for new installations

---

## 🧪 Testing

Run the test suite:
```bash
flutter test
```

For widget tests:
```bash
flutter test test/widget_test.dart
```

---

## 🤝 Contributing

We welcome contributions! To get started:

1. Fork the repository and create your feature branch:
   ```bash
   git checkout -b feat/your-feature
   ```
2. Install dependencies and run locally:
   ```bash
   flutter pub get && flutter run
   ```
3. Write tests and ensure they pass:
   ```bash
   flutter test
   ```
4. Follow Conventional Commits (e.g., `feat:`, `fix:`, `chore:`) and open a pull request.

Guidelines:
- Keep PRs small and focused.
- Include screenshots/GIFs for UI changes.
- Add/adjust tests for new behavior.

---

## 📝 License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

**Built with ❤️ using Flutter and Firebase**
