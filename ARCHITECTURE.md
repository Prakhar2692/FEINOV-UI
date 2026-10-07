# FEINOV architecture

FEINOV follows a layered, feature-first architecture designed for a commerce app with multiple business domains and a shared app shell.

## Architectural principles

- Feature isolation by business domain
- Shared infrastructure in the `core` layer
- Weak dependency between UI and data access
- Typed models and repository boundaries
- Centralized environment and network configuration
- Riverpod-first state management and dependency injection

## Layer breakdown

### 1. Presentation layer

Folder pattern:

```text
lib/features/<feature>/presentation/
```

Responsibilities:

- pages and screens
- controllers/providers
- UI state composition
- widget-level behavior and interaction logic

Examples:

- `search/presentation/pages/search_page.dart`
- `products/presentation/controllers/product_listing_controller.dart`

### 2. Domain layer

Folder pattern:

```text
lib/features/<feature>/domain/
```

Responsibilities:

- models and entities
- repository contracts
- validation and business logic boundaries
- transformation rules between API model and app model

Examples:

- `product.dart`
- `cart_item.dart`
- `wishlist_item.dart`

### 3. Data layer

Folder pattern:

```text
lib/features/<feature>/data/
```

Responsibilities:

- repository implementations
- remote/local data sources
- DTO to entity mapping
- error normalization

### 4. Core layer

Folder pattern:

```text
lib/core/
```

Responsibilities:

- environment and configuration
- dependency injection
- network client and service setup
- shared widgets
- app theme and color system
- error handling and reusable utilities

## Shared infrastructure

### App configuration

The app reads runtime environment selection from:

```bash
--dart-define=APP_ENV=development
```

This is resolved in `lib/core/config/app_environment.dart` and used in `lib/core/constants/app_endpoints.dart`.

### Routing

Navigation is centralized through the app router and feature-specific route definitions. The screen flow is authored around product browsing, auth, cart, checkout, and profile flows.

### State management

Riverpod is used throughout the app for:

- DI providers
- controller state
- screen-level feature state
- shared app settings such as session and cart state

## Feature map

The project currently organizes business concerns around:

- auth
- cart
- categories
- checkout
- home
- orders
- payment
- products
- profile
- search
- wishlist

## ADR reference

Architecture decisions are tracked in [docs/adr/0001-clean-architecture.md](docs/adr/0001-clean-architecture.md).

## Design references

- [Style.md](Style.md)
- [System Component Design.md](System%20Component%20Design.md)

## Development guidance

1. Keep feature logic inside the feature folder where possible.
2. Use the core layer for shared infrastructure only.
3. Keep repositories typed and consistent with the domain model.
4. Centralize API URLs and environment values instead of hardcoding them in screens or controllers.
5. Run code generation after model or provider changes.
