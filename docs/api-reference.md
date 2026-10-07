# API reference

This project follows a feature-based API contract pattern. The central reference points are `lib/core/constants/app_endpoints.dart` and the repository implementations under each feature folder.

## Core endpoints

### Authentication

- `POST /auth/login`
- `POST /auth/register`
- `POST /auth/verify-otp`
- `POST /auth/forgot-password`
- `POST /auth/verify-email`
- `GET /auth/session`
- `POST /auth/logout`

### Catalog

- `GET /home`
- `GET /home/banners`
- `GET /home/categories`
- `GET /home/products/featured`
- `GET /products`
- `GET /categories`

### Cart and checkout

- `GET /cart`
- `POST /cart`
- `PATCH /cart/:id`
- `DELETE /cart/:id`
- `POST /orders`
- `GET /orders`
- `POST /payments`

### Profile

- `GET /profile`
- `GET /addresses`
- `POST /addresses`
- `PATCH /addresses/:id`

## Contract conventions

- Use JSON request and response bodies.
- Return error metadata with status codes and message payloads.
- Normalize all HTTP failures through the app error layer.
- Keep repository methods typed and feature-specific.

## Example response normalization

Successful and failed responses should be converted by the repository layer before they are exposed to the controller or UI state.

## Pending API work

- Finalize real backend schemas for cart, checkout, and payment callbacks.
- Add webhook and callback handling for Razorpay flows.
- Confirm OTP and email verification payloads with the backend team.
- Document pagination and filtering contract for product search.
