# FEINOV setup guide

This document covers the required local setup for FEINOV UI, including prerequisites, dependency installation, code generation, and verification.

## Requirements

- Flutter SDK 3.12.2 or newer
- Dart SDK bundled with Flutter
- Xcode for iOS/macOS builds
- Android Studio with Android SDK for Android builds
- VS Code or Android Studio for editing
- Git for source control
- A backend environment or mock API endpoint for product and auth flows

## Install Flutter

1. Install Flutter from the official SDK distribution for your OS.
2. Ensure the Flutter toolchain is on your PATH.
3. Validate the setup:

```bash
flutter --version
flutter doctor
```

Resolve any issues reported by `flutter doctor` before continuing.

## Clone and install dependencies

```bash
git clone <repo-url>
cd FEINOV-UI
flutter pub get
```

## Generate code

This project uses Riverpod, Freezed, and JSON serialization. Run the generator after changing models or providers:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

For a watch mode during development:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Run the app

Use the environment flag to select the API target:

```bash
flutter run --dart-define=APP_ENV=development
```

Available values:

- `development`
- `staging`
- `production`

## Common verification commands

```bash
flutter analyze
flutter test
flutter test test/widget_test.dart
```

## Troubleshooting

- If generated files are stale, run `flutter pub run build_runner clean` and rebuild.
- If Android or iOS tools are missing, install the corresponding SDKs and re-run `flutter doctor`.
- If routing fails, confirm the app is using the latest generated router/provider outputs.

## Recommended local workflow

1. `flutter pub get`
2. `flutter pub run build_runner build --delete-conflicting-outputs`
3. `flutter run --dart-define=APP_ENV=development`
4. `flutter test` before pushing changes
5. `flutter analyze` before opening a PR
