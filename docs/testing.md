# Testing strategy

## Test goals

The FEINOV app should validate:

- domain logic and model mapping
- controller behavior and state transitions
- critical user flows such as login, cart updates, and search
- smoke coverage for app bootstrap and navigation

## Test layers

### Unit tests

Focus on:

- model serialization and deserialization
- repository rules and mapping logic
- edge cases in validation or parsing

### Widget tests

Focus on:

- app shell rendering
- major screens and routes
- screen-level interactions such as submitting search and tapping product cards

### Integration tests

Use when validating end-to-end flows, especially:

- checkout completion
- authentication verification
- payment status handling
- profile and address updates

## Current test commands

```bash
flutter test
flutter test test/features/storefront/storefront_models_test.dart
flutter test test/widget_test.dart
```

## Testing conventions

- Keep tests deterministic.
- Test behavior, not implementation details.
- Use real app runtime logic when possible.
- Avoid over-mocking critical state transitions.
- Name tests around the user behavior they validate.

## CI recommendation

A basic CI pipeline should run:

1. `flutter pub get`
2. `flutter pub run build_runner build --delete-conflicting-outputs`
3. `flutter analyze`
4. `flutter test`
