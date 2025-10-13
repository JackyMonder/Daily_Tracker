# expenses_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Project structure (added)

I added a small, common structure under `lib/src/` to make the app easier to extend:

- `lib/src/app.dart` - App entry widget that configures `MaterialApp`.
- `lib/src/screens/home_screen.dart` - Home screen scaffold and layout.
- `lib/src/widgets/expenses_list.dart` - Placeholder list widget for expenses.
- `lib/src/theme/app_theme.dart` - Centralized theme configuration.

The `lib/main.dart` now exports `App` so tests and other code can import `package:expenses_app/main.dart`.
