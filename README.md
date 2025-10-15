
# Expenses App

A cross-platform Flutter application for managing and viewing expenses, with a modular structure for easy extension.

## Features

- Home screen with custom AppBar and navigation icons
- Note cards grid for quick notes and reminders
- Modular widget structure for easy feature addition
- Light theme with indigo primary color
- Basic widget test included

## Project Structure

- `lib/main.dart` — App entry point, launches `MyExpensesApp`
- `lib/presentation/screens/home.dart` — Main home screen scaffold and layout
- `lib/common/widgets/NoteCards.dart` — Grid of note cards (sample data)
- `lib/utils/notesection.dart` — Card widget for displaying note title/content
- `lib/core/themes/app_theme.dart` — Centralized theme configuration
- `lib/core/constants/placeholder.dart` — App name constant
- `test/widget_test.dart` — Basic widget test for home screen

## Getting Started

1. Install Flutter: [Flutter installation guide](https://docs.flutter.dev/get-started/install)
2. Clone this repository:
	```powershell
	git clone <your-repo-url>
	cd expenses_app
	```
3. Get dependencies:
	```powershell
	flutter pub get
	```
4. Run the app:
	```powershell
	flutter run
	```

## Running Tests

To run the included widget test:
```powershell
flutter test
```

## Dependencies

- `flutter_svg` for SVG asset support
- `cupertino_icons` for iOS-style icons

## Platform Support

This app is configured for Android, iOS, Web, Windows, macOS, and Linux. See respective folders for platform-specific files.

## Customization & Extension

- Add new features in `lib/features/`
- Add new screens in `lib/presentation/screens/`
- Add new widgets in `lib/common/widgets/`

## License

This project is private and not published to pub.dev.
