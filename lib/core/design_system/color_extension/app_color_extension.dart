import 'package:flutter/material.dart';

/// `ThemeExtension` for E_learning custom colors.
///
/// This extension includes colors from the E_learning palette and can be easily used
/// throughout the app for consistent theming.
///
/// Usage example: `Theme.of(context).extension<AppColorExtension>()?.textPrimary`.
class AppColorExtension extends ThemeExtension<AppColorExtension> {
  const AppColorExtension({
    required this.textPrimary,
    required this.textTertiary,
    required this.surfaceCard,
    required this.textHighlightBlue,
    required this.surface,
    required this.inactiveButton,
    required this.activeButton,
    required this.textWhite,
    required this.iconRed,
    required this.iconBlue,
    required this.buttonTertiary,
    required this.buttonSecondary,
  });

  final Color textPrimary;
  final Color textTertiary;
  final Color surfaceCard;
  final Color textHighlightBlue;
  final Color surface;
  final Color inactiveButton;
  final Color activeButton;
  final Color textWhite;
  final Color iconRed;
  final Color iconBlue;
  final Color buttonTertiary;
  final Color buttonSecondary;

  @override
  ThemeExtension<AppColorExtension> copyWith({
    Color? textPrimary,
    Color? textTertiary,
    Color? surfaceCard,
    Color? textHighlightBlue,
    Color? surface,
    Color? inactiveButton,
    Color? activeButton,
    Color? textWhite,
    Color? iconRed,
    Color? iconBlue,
    Color? buttonTertiary,
    Color? buttonSecondary,
  }) {
    return AppColorExtension(
      textPrimary: textPrimary ?? this.textPrimary,
      textTertiary: textTertiary ?? this.textTertiary,
      surfaceCard: surfaceCard ?? this.surfaceCard,
      textHighlightBlue: textHighlightBlue ?? this.textHighlightBlue,
      surface: surface ?? this.surface,
      inactiveButton: inactiveButton ?? this.inactiveButton,
      activeButton: activeButton ?? this.activeButton,
      textWhite: textWhite ?? this.textWhite,
      iconRed: iconRed ?? this.iconRed,
      iconBlue: iconBlue ?? this.iconBlue,
      buttonTertiary: buttonTertiary ?? this.buttonTertiary,
      buttonSecondary: buttonSecondary ?? this.buttonSecondary,
    );
  }

  @override
  ThemeExtension<AppColorExtension> lerp(
    covariant ThemeExtension<AppColorExtension>? other,
    double t,
  ) {
    if (other is! AppColorExtension) {
      return this;
    }
    return AppColorExtension(
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      textHighlightBlue:
          Color.lerp(textHighlightBlue, other.textHighlightBlue, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      inactiveButton: Color.lerp(inactiveButton, other.inactiveButton, t)!,
      activeButton: Color.lerp(activeButton, other.activeButton, t)!,
      textWhite: Color.lerp(textWhite, other.textWhite, t)!,
      iconRed: Color.lerp(iconRed, other.iconRed, t)!,
      iconBlue: Color.lerp(iconBlue, other.iconBlue, t)!,
      buttonTertiary: Color.lerp(buttonTertiary, other.buttonTertiary, t)!,
      buttonSecondary: Color.lerp(buttonSecondary, other.buttonSecondary, t)!,
    );
  }
}

/// Extension to create a ColorScheme from AppColorExtension.
extension ColorSchemeBuilder on AppColorExtension {
  ColorScheme toColorScheme(Brightness brightness) {
    return ColorScheme(
      brightness: brightness,
      primary: textPrimary,
      onPrimary: textWhite,
      secondary: activeButton,
      onSecondary: buttonSecondary,
      error: iconRed,
      onError: textWhite,
      surface: surface,
      onSurface: textPrimary,
    );
  }
}
