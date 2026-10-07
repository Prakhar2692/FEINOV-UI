# FEINOV UI

FEINOV UI is a Flutter-based commerce storefront for a premium skincare brand. The app is structured around a feature-first, clean architecture and includes catalog, search, cart, checkout, auth, profile, orders, wishlist, and payment-related flows.

## Project status

This repository is no longer a starter template. It is a working storefront foundation with implemented feature modules, shared UI primitives, router setup, environment-aware API configuration, and platform scaffolding for Android, iOS, Linux, macOS, and Windows.

## Core stack

- Flutter + Dart
- Riverpod / hooks_riverpod
- GoRouter
- Dio
- flutter_secure_storage
- Freezed + JSON serialization
- Material 3 design system

## Quick start

### 1) Install prerequisites

- Flutter SDK 3.12.2+
- Android Studio / Xcode as needed for native builds
- Git

### 2) Install dependencies

```bash
flutter pub get
```

### 3) Generate code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4) Run the app

```bash
flutter run --dart-define=APP_ENV=development
```

Supported values:

- `development`
- `staging`
- `production`

See [docs/environment-and-config.md](docs/environment-and-config.md) for environment and API endpoint rules.

## Project structure

```text
lib/
├── core/
│   ├── config/
│   ├── constants/
│   ├── di/
│   ├── error/
│   ├── network/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── auth/
│   ├── cart/
│   ├── categories/
│   ├── checkout/
│   ├── home/
│   ├── orders/
│   ├── payment/
│   ├── products/
│   ├── profile/
│   ├── search/
│   └── wishlist/
├── main.dart
└── routes.dart
```

## Implemented feature areas

- Authentication and OTP flow
- Home and category browsing
- Product listing and detail flows
- Search with recent searches and suggestions
- Cart and checkout flow structure
- Wishlist and profile data organization
- Orders and payment integration scaffolding
- Shared premium design system and reusable widgets

## Documentation index

- [docs/setup.md](docs/setup.md) — environment prerequisites and local setup
- [docs/environment-and-config.md](docs/environment-and-config.md) — backend URLs and runtime config
- [docs/api-reference.md](docs/api-reference.md) — endpoint and contract overview
- [docs/roadmap.md](docs/roadmap.md) — staged delivery plan
- [docs/backlog.md](docs/backlog.md) — implemented vs planned feature list
- [docs/contributing.md](docs/contributing.md) — branch, commit, and PR conventions
- [docs/code-generation.md](docs/code-generation.md) — codegen workflow
- [docs/testing.md](docs/testing.md) — testing and verification strategy
- [docs/adr/0001-clean-architecture.md](docs/adr/0001-clean-architecture.md) — architecture decision record
- [ARCHITECTURE.md](ARCHITECTURE.md) — architecture overview
- [Style.md](Style.md) — design language and visual conventions
- [System Component Design.md](System%20Component%20Design.md) — component-level design references

## Verification commands

```bash
flutter analyze
flutter test
```

## Notes

Production readiness still depends on final backend contract validation, app signing configuration, and release environment checks. The project is, however, organized and configured for real feature development rather than a blank scaffold.
