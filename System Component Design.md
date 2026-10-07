# System component design

This document summarizes the reusable app building blocks that power the FEINOV storefront interface.

## 1. Foundational constants

- Colors: luxury palette with deep green, soft cream, warm neutrals, and muted gold accents
- Typography: premium editorial hierarchy using Material typography and supporting serif-style emphasis where appropriate
- Spacing: consistent 8-point scale for spacing and layout rhythm
- Radius: soft corners for cards, chips, and surfaces

## 2. Core theme

The app theme is configured in `lib/core/theme/app_theme.dart` and is intentionally designed around Material 3 defaults with brand-specific overrides for card, button, input, and app bar surfaces.

## 3. Reusable system components

The following shared widgets are the foundation for feature UI:

- `AppButton`: action CTA with loading and style variants
- `AppTextField`: branded form input with spacing and icon conventions
- `AppProductCard`: product tile for catalog grid layouts
- `AppTopBar`: consistent screen header patterns
- `AppShimmer`: loading skeletons for product cards and lists
- `AppBottomSheet`: modal interaction layer for actions and filters
- `CartBadge`: compact cart indicator used in app navigation

## 4. Design and implementation guidance

- Reuse shared widgets before creating custom screen-specific components.
- Keep spacing and color decisions centralized in the core theme.
- Favor consistent component combinations across catalog, search, cart, and profile screens.

See also:

- [Style.md](Style.md)
- [ARCHITECTURE.md](ARCHITECTURE.md)
