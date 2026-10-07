# ADR 0001: Use a layered feature-first architecture

- Status: Accepted
- Date: 2026-10-07

## Context

The application is a Flutter storefront with multiple business domains such as auth, catalog, cart, orders, payment, search, and profile. The app needs to remain modular, testable, and scalable while supporting a consistent UI and domain model structure.

## Decision

The project will use a feature-first, layered structure:

- `lib/features/<feature>` for business concerns
- `lib/core` for shared infrastructure and app-wide concerns
- domain, data, and presentation boundaries inside each feature
- Riverpod for dependency injection and state management
- GoRouter for navigation
- Dio for network communication
- Freezed and JSON serialization for typed models

## Consequences

### Positive

- Clear boundaries between business logic and UI
- Better reusability of shared core components
- Easier testing by feature
- Scales well as new product capabilities are added

### Negative

- Requires more explicit structure and discipline during feature work
- Requires code generation for some layers
- Fresh contributors need to understand the feature and core boundaries

## Follow-up

Any future architectural change should be documented as a new ADR and linked from the project documentation index.
