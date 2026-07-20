# Project Architecture: Skincare E-commerce Platform

This project follows **Clean Architecture** principles with a **Feature-First** folder structure.

## Architecture Layers

### 1. Presentation Layer
- **Location**: `lib/features/<feature_name>/presentation`
- **Responsibilities**: UI components, Widgets, Pages, and Riverpod Providers for UI state.
- **Tools**: Material 3, Responsive Layouts.

### 2. Application Layer
- **Location**: `lib/features/<feature_name>/application`
- **Responsibilities**: Service classes that coordinate between Domain and Data layers. Orchestrates use cases (if explicitly needed) and complex state logic.

### 3. Domain Layer
- **Location**: `lib/features/<feature_name>/domain`
- **Responsibilities**: Business logic, Entity models, and Repository interfaces.
- **Tools**: Freezed (for immutable models), JsonSerializable.

### 4. Data Layer
- **Location**: `lib/features/<feature_name>/data`
- **Responsibilities**: Repository implementations, Data Sources (Remote/Local), and DTOs.
- **Tools**: Dio (API communication).

### 5. Core Layer
- **Location**: `lib/core`
- **Responsibilities**: Cross-cutting concerns shared across features.
  - `constants/`: App-wide constants (spacing, strings).
  - `di/`: Dependency Injection setup (Riverpod providers).
  - `error/`: Failure and Exception classes.
  - `network/`: Dio client configuration.
  - `theme/`: App colors, typography, and theme data.
  - `utils/`: Helper classes and extensions.
  - `widgets/`: Shared UI components.

---

## Tech Stack

- **State Management**: [Riverpod](https://riverpod.dev/) (with code generation).
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router).
- **Networking**: [Dio](https://pub.dev/packages/dio).
- **Models**: [Freezed](https://pub.dev/packages/freezed) & [JsonSerializable](https://pub.dev/packages/json_serializable).
- **UI Framework**: Flutter with **Material 3**.
- **Code Generation**: [Build Runner](https://pub.dev/packages/build_runner).

---

## Getting Started

1.  **Dependencies**: Run `flutter pub get`.
2.  **Code Generation**: Run `flutter pub run build_runner build --delete-conflicting-outputs` to generate necessary files for Riverpod and Freezed.
3.  **Run**: `flutter run`.

## Folder Structure Example
```text
lib/
├── core/
│   ├── constants/
│   ├── di/
│   ├── error/
│   ├── network/
│   ├── theme/
│   └── utils/
├── features/
│   └── home/
│       ├── application/
│       ├── data/
│       ├── domain/
│       │   └── models/
│       └── presentation/
│           ├── pages/
│           └── widgets/
└── main.dart
```
