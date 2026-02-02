# Marketing Ads Screen (MarAds)

Flutter implementation of the marketing ads content creation form.

## Files Structure

```
lib/screen/drawer/marads/
├── mar_ads_screen.dart                      # Basic mode screen
├── mar_ads_advanced_screen.dart             # Advanced mode screen
├── widgets/
│   ├── mar_ads_text_field.dart              # Custom text field component
│   ├── mar_ads_dropdown.dart                # Custom dropdown component
│   ├── mar_ads_mode_selector.dart           # Mode selector button
│   ├── mar_ads_free_badge.dart              # Free usage badge
│   ├── mar_ads_collapsible_section.dart     # Collapsible accordion section
│   └── additional_info.dart                 # Additional info input screen
└── README.md
```

## Usage

```dart
import 'package:botnoivoice/screen/drawer/marads/mar_ads_screen.dart';

// Navigate to the screen
GoRoute(
  path: '/marads',
  builder: (context, state) => const MarAdsScreen(),
),
```

## Components

### MarAdsScreen
Main screen containing the marketing ads creation form with fields:
- Product name (required)
- Brand name
- Price
- Content style (dropdown)
- Content length (dropdown with info icon)
- Additional info label

### MarAdsTextField
Reusable text field component matching the design system.

### MarAdsDropdown
Dropdown selector with optional info icon.

### MarAdsModeSelector
Mode selector button with gradient styling.

### MarAdsFreeBadge
Badge displaying remaining free usage count.

## Design Specifications

### Colors
- Primary Gradient: `#01BFFB` → `#EB85FC`
- Background: `#F7F8FA`
- Text Main: `#262626`
- Text Secondary: `#3D3D3D`
- Text Placeholder: `#888888`
- White: `#FFFFFF`

### Typography
- Title Font: Prompt
- Body Font: Inter
- Font sizes: 12sp, 14sp, 20sp
- Font weights: Regular (400), SemiBold (600)

### Spacing
- Form fields: 16px horizontal, 5px vertical padding
- Input fields: 20px horizontal padding, 49px height
- Dropdowns: 20px horizontal padding, 46px height
- Bottom button: 16px padding, 56px height

## Features

- ✅ Responsive design using flutter_screenutil
- ✅ Custom text fields with placeholders
- ✅ Dropdown selectors with bottom sheet
- ✅ Gradient mode selector
- ✅ Free usage badge in app bar
- ✅ Form validation (product field required)
- ✅ Disabled button state
- ✅ Bottom sheet dialogs for selections
- ✅ Basic mode with simple form fields
- ✅ Advanced mode with collapsible sections
- ✅ Hamburger menu navigation
- ✅ Additional info full-screen editor

## TODO

- [ ] Connect to API for content generation
- [ ] Implement actual dropdown options from backend
- [ ] Add loading state during content creation
- [ ] Add error handling
- [ ] Implement points/credit system
- [ ] Add analytics tracking
