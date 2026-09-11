import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Spacing, radius, elevation, and layout dimensions adhering to an 8-pt grid system.
abstract final class AppDimensions {
  // Spacing
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;

  // Corner Radii
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusFull = 999.0;

  // Icon Sizes
  static const double iconSM = 16.0;
  static const double iconMD = 20.0;
  static const double iconLG = 24.0;
  static const double iconXL = 32.0;

  // Standard Edge Insets
  static const EdgeInsets paddingScreen = EdgeInsets.symmetric(
    horizontal: spaceMD,
    vertical: spaceMD,
  );

  static const EdgeInsets paddingCard = EdgeInsets.all(spaceMD);

  // Border Radii
  static const BorderRadius borderRadiusSmall = BorderRadius.all(
    Radius.circular(radiusSmall),
  );

  static const BorderRadius borderRadiusMedium = BorderRadius.all(
    Radius.circular(radiusMedium),
  );

  static const BorderRadius borderRadiusLarge = BorderRadius.all(
    Radius.circular(radiusLarge),
  );

  static const BorderRadius borderRadiusFull = BorderRadius.all(
    Radius.circular(radiusFull),
  );

  // Soft Ambient Box Shadows (non-harsh)
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x080F172A),
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
    BoxShadow(
      color: AppColors.shadow,
      offset: Offset(0, 4),
      blurRadius: 12,
    ),
  ];
}
