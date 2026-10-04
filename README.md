# Feinov UI - Skincare E-commerce

A Flutter skincare e-commerce platform built with Clean Architecture and Riverpod.

## Features (Planned)
- Product Browsing
- Shopping Cart
- User Profiles
- Responsive Layout (Mobile, Tablet, Desktop)

## Implementation Details

This project uses:
- **Clean Architecture**: Separation of concerns across Presentation, Application, Domain, and Data layers.
- **Feature-First Structure**: Code organized by business features.
- **Riverpod**: State management with code generation.
- **GoRouter**: Declarative routing.
- **Material 3**: Modern UI components and theming.
- **Dio**: Robust API communication.
- **Freezed**: Immutable models.

For a detailed breakdown of the architecture, see [ARCHITECTURE.md](./ARCHITECTURE.md).

## Getting Started

1. Install Flutter SDK.
2. Clone the repository.
3. Run `flutter pub get`.
4. Generate code:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
5. Run the app:
   ```bash
   flutter run
   ```
