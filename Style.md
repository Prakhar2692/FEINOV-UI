# Design System & Style Guide

This document outlines the design system for the Feinov UI Skincare Application, built with Material 3.

## 1. Design Language
- **Aesthetic**: Premium, Minimal, Clean.
- **Palette**: Deep Forest Green, Muted Gold, Soft Cream.
- **Shape**: Soft rounded corners (16dp - 32dp).

## 2. Foundations

### Colors (`lib/core/theme/app_colors.dart`)
| Name | Value | Usage |
| :--- | :--- | :--- |
| `primary` | `#2D4739` | Main brand color (Deep Green) |
| `secondary` | `#D4AF37` | Accents and highlights (Muted Gold) |
| `background` | `#FDFBFA` | Main app background (Soft Cream) |
| `surface` | `#FFFFFF` | Cards and elevated elements |
| `surfaceVariant` | `#F2EFE9` | Subtle background for image containers |
| `error` | `#BA1A1A` | Error states |

### Typography (`lib/core/theme/app_typography.dart`)
Uses Serif (Georgia) for headings to provide a luxury feel and Sans-Serif for body text.
- **Display Large**: 57pt (Hero text)
- **Headline Large**: 32pt (Page titles)
- **Headline Medium**: 28pt (Section headers)
- **Title Large**: 22pt (Sub-headers)
- **Body Large**: 16pt (Primary body text)
- **Label Small**: 11pt (Badges and small uppercase labels)

### Spacing (`lib/core/constants/app_spacing.dart`)
- **Base Unit**: 8dp
- **Scale**: `xs: 4`, `s: 8`, `m: 16`, `l: 24`, `xl: 32`, `xxl: 48`
- **Border Radius**: `radiusM: 8`, `radiusL: 16`, `radiusXL: 24`, `radiusXXL: 32`

---

## 3. Reusable Widgets

### `AppButton`
A standard button supporting primary (Elevated) and secondary (Outlined) styles.
- **Features**: Automatic loading indicator support.
- **Usage**:
  ```dart
  AppButton(
    text: 'Add to Cart',
    onPressed: () => print('Pressed'),
    isLoading: false,
  )
  ```

### `AppTextField`
Clean input fields with integrated labels.
- **Features**: Password masking, validation, and prefix/suffix icons.
- **Style**: Filled with soft rounded borders.

### `AppProductCard`
A specialized card for skincare products.
- **Includes**: Brand (uppercase), Name, Price, and Favorite button.
- **Visuals**: Uses `surfaceVariant` for the image background to create subtle contrast.

### `AppTopBar`
Standardized App Bar for the project.
- **Features**: Center-aligned titles and automatic back-button handling.

### `AppLoadingIndicator`
Custom branded `CircularProgressIndicator` following the primary color scheme.

### `AppShimmer`
Skeleton loaders for smooth data fetching UX.
- **`AppShimmer`**: Base rectangular shimmer.
- **`AppProductShimmer`**: Pre-composed skeleton that matches the `AppProductCard` layout.

### `AppBottomSheet`
Premium modal bottom sheet with a handle and flexible action area.
- **Entry point**: `AppBottomSheet.show(context: ..., title: ..., child: ...)`

---

## 4. Theme Configuration (`lib/core/theme/app_theme.dart`)
The `AppTheme.lightTheme` getter configures the global `ThemeData`:
- Enables **Material 3**.
- Configures `ColorScheme` based on `AppColors`.
- Sets global styles for `CardTheme`, `InputDecorationTheme`, and `ButtonThemes` to ensure consistency without manual styling.
