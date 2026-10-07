# Design system and visual standards

This project uses a premium skincare aesthetic built on Material 3. The design language focuses on calm luxury, clarity, and strong product storytelling.

## Design language

- Premium, minimal, and clean
- Deep forest green as the primary brand color
- Soft cream backgrounds and warm neutral surfaces
- Rounded corners and generous spacing
- Serif-inspired headings for a luxury editorial feel

## Foundations

### Colors

The app color system is centralized in `lib/core/theme/app_colors.dart`.

- `primary`: deep green brand tone
- `secondary`: muted gold accent
- `background`: soft cream canvas
- `surface`: white for cards and elevated surfaces
- `surfaceVariant`: subtle neutral containers
- `error`: validation and destructive states

### Typography

The type scale is defined in the app theme layer and is intended to support a premium commerce UI without compromising readability.

### Spacing and radius

The spacing scale is intentionally consistent across the app and is centralized in `lib/core/constants/app_spacing.dart`.

- `xs`: 4
- `s`: 8
- `m`: 16
- `l`: 24
- `xl`: 32
- `xxl`: 48

## Shared UI components

Reusable widgets are implemented in `lib/core/widgets` and should be used before custom one-offs are introduced.

- `AppButton`
- `AppTextField`
- `AppProductCard`
- `AppShimmer`
- `AppTopBar`
- `AppBottomSheet`
- `CartBadge`

## Implementation note

The visual system is intended to be consistent across the catalog, product, search, cart, and profile flows. New UI should follow the same spacing scale, shape language, and brand colors.

See also:

- [README.md](README.md)
- [ARCHITECTURE.md](ARCHITECTURE.md)
