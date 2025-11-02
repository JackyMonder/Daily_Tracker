# Daily Tracker - Note Taker App

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Latest-FFCA28?logo=firebase)](https://firebase.google.com)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web%20%7C%20Desktop-007AFF)](https://flutter.dev)

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
- [Architecture](#-architecture)
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

## 🏗️ Architecture

The app follows clean architecture principles with clear separation of concerns:

```
lib/
├── core/              # Core services and configurations
│   ├── services/      # Business logic services
│   ├── routes/        # App routing
│   └── themes/        # Theme configuration
├── data/              # Data layer
│   ├── models/        # Data models
│   └── repositories/   # Data repositories
├── presentation/      # UI layer
│   ├── screens/       # App screens
│   ├── widgets/       # Reusable UI widgets
│   └── state/         # State management
└── shared/            # Shared utilities and widgets
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
   cd daily-tracker
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

## 📦 Dependencies

### Core Dependencies
```yaml
firebase_core: ^4.2.0           # Firebase Core SDK
firebase_auth: ^6.1.1           # Firebase Authentication
firebase_database: ^12.0.3      # Firebase Realtime Database
google_sign_in: ^6.3.0          # Google Sign-In
firebase_ui_oauth_google: ^2.0.1 # Firebase UI for Google
```

### UI & Editor
```yaml
flutter_quill: ^11.5.0          # Rich text editor
flutter_svg: ^2.2.1            # SVG support
font_awesome_flutter: ^10.7.0   # Icon library
```

### Utilities
```yaml
shared_preferences: ^2.3.3     # Local storage
flutter_localizations          # Built-in localization
```

See `pubspec.yaml` for complete dependency list.

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

### Recommended Firebase Security Rules

```json
{
  "rules": {
    "notes": {
      "$noteId": {
        ".read": "auth != null && data.child('userId').val() == auth.uid",
        ".write": "auth != null && data.child('userId').val() == auth.uid"
      }
    },
    "users": {
      "$userId": {
        ".read": "auth != null && $userId == auth.uid",
        ".write": "auth != null && $userId == auth.uid"
      }
    }
  }
}
```

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

This is a private project. For internal contributors:

1. Create a feature branch from `main`
2. Make your changes with proper documentation
3. Write tests for new features
4. Submit a pull request with detailed description

### Code Style
- Follow Dart/Flutter style guide
- Use meaningful variable names
- Add comments for complex logic
- Keep functions focused and small

---

## 📄 License

This project is **private** and not published to pub.dev. All rights reserved.

---

## 📞 Support

For issues, questions, or contributions:
- Check `GOOGLE_SIGN_IN_SETUP.md` for authentication setup
- Review Firebase Console for configuration issues
- Consult Flutter documentation for development questions

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase team for robust backend services
- Flutter Quill for rich text editing capabilities
- Open source community for inspiration and tools

---

**Built with ❤️ using Flutter and Firebase**
