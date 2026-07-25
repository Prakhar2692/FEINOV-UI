Design System Components:

1. Foundational Constants:
   - Colors (app_colors.dart): A luxury-focused palette featuring Deep Forest Green (primary), Muted Gold (secondary), and Soft Cream (background).
   - Typography (app_typography.dart): Clean hierarchy using Serif fonts (Georgia fallback) for headlines to evoke a premium feel.
   - Spacing (app_spacing.dart): Comprehensive scale for padding, margins, and soft rounded corners (Radius L/XL).

2. Core Theme (app_theme.dart):
   - Full Material 3 configuration.
   - Customized component themes for Buttons, Cards, Input Decoration, and AppBars.

3. Reusable UI Components (lib/core/widgets/):
   - AppButton: Supports primary and outlined styles with built-in loading state.
   - AppTextField: Minimal design with soft corners and clear labeling.
   - AppProductCard: Stacked layout with image, brand, name, and price; includes a favorite toggle.
   - AppTopBar: Standardized header with automatic back button handling.
   - AppLoadingIndicator: Branded circular progress indicator.
   - AppShimmer: Customizable shimmer loaders, including a pre-built AppProductShimmer.
   - AppBottomSheet: Elegant modal with a handle and customizable actions.

Getting Started with the Design System:
All widgets are built to be flexible and consistent with the luxury aesthetic. You can now use them across your feature modules.

Note: I've added the shimmer package to your pubspec.yaml to support the skeleton loading states.
