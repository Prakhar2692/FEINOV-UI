# Environment and backend configuration

FEINOV uses a lightweight environment switch defined in `lib/core/config/app_environment.dart` and consumed by `lib/core/constants/app_endpoints.dart`.

## Supported environments

| Environment | Value | Base URL |
| --- | --- | --- |
| Development | `development` | `https://api-dev.feinov.local/v1` |
| Staging | `staging` | `https://api-staging.feinov.com/v1` |
| Production | `production` | `https://api.feinov.com/v1` |

## How it works

The app reads the environment at compile time through `String.fromEnvironment('APP_ENV', defaultValue: 'development')`.

Example:

```bash
flutter run --dart-define=APP_ENV=staging
```

## Runtime usage

The API base URL is centralized in `AppEndpoints.baseUrl`:

```dart
static String get baseUrl => AppEnvironment.current.baseUrl;
```

Feature endpoints are defined as constants, such as:

- `/auth/login`
- `/auth/register`
- `/products`
- `/categories`
- `/cart`
- `/orders`
- `/payments`

## Recommended configuration practice

- Keep environment logic centralized in the `core/config` layer.
- Do not hardcode API URLs inside feature repositories.
- Prefer environment-aware configuration for staging and production deployments.
- For local development, use a mocked or local backend service if the real service is not available.

## Local backend notes

If the backend is unavailable, use the `mockBaseUrl` value in the endpoint layer for isolated UI work while the service contract is being finalized.

## Deployment checklist

- Confirm the deployed build uses the correct `APP_ENV` value.
- Verify the backend is reachable from the target platform.
- Confirm signing and environment keys are configured for release builds.
- Validate auth, cart, product, and order flows against the selected backend.
