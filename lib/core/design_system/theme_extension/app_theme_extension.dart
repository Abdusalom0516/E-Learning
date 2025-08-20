import 'package:flutter/material.dart';

import '../app_colors/app_colors.dart';
import '../color_extension/app_color_extension.dart';
import '../font_extension/font_extension.dart';

class AppTheme {
  static final light = () {
    final defaultTheme = ThemeData.light();

    return defaultTheme.copyWith(
      colorScheme: _lightAppColors.toColorScheme(Brightness.light),
      scaffoldBackgroundColor: _lightAppColors.surface,
      appBarTheme: AppBarTheme(
        color: _lightAppColors.surface,
      ),
      extensions: [
        _lightAppColors,
        _lightFontTheme,
      ],
    );
  }();

  static final dark = () {
    final defaultTheme = ThemeData.dark();

    return defaultTheme.copyWith(
      colorScheme: _darkAppColors.toColorScheme(Brightness.dark),
      scaffoldBackgroundColor: _darkAppColors.surface,
      appBarTheme: AppBarTheme(
        color: _darkAppColors.surface,
      ),
      extensions: [
        _darkAppColors,
        _darkFontTheme,
      ],
    );
  }();

  static final _lightFontTheme = AppFontThemeExtension(
    headerLarger: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: _lightAppColors.textPrimary,
    ),
    headerSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: _lightAppColors.textPrimary,
    ),
    subHeader: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: _lightAppColors.textTertiary,
    ),
    bodyMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: _lightAppColors.textPrimary,
    ),
  );

  static final _darkFontTheme = AppFontThemeExtension(
    headerLarger: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: _darkAppColors.textPrimary,
    ),
    headerSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: _darkAppColors.textPrimary,
    ),
    subHeader: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: _darkAppColors.textTertiary,
    ),
    bodyMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: _darkAppColors.textPrimary,
    ),
  );

  static const _lightAppColors = AppColorExtension(
    textPrimary: AppColor.textPrimary,
    textTertiary: AppColor.textTertiary,
    surfaceCard: AppColor.surfaceCard,
    textHighlightBlue: AppColor.textHighlightBlue,
    surface: AppColor.surface,
    inactiveButton: AppColor.inactiveButton,
    activeButton: AppColor.activeButton,
    textWhite: AppColor.textWhite,
    iconRed: AppColor.iconRed,
    iconBlue: AppColor.iconBlue,
    buttonTertiary: AppColor.buttonTertiary,
    buttonSecondary: AppColor.buttonSecondary,
  );

  static const _darkAppColors = AppColorExtension(
    textPrimary: AppColor.textWhite,
    textTertiary: AppColor.textTertiary,
    surfaceCard: AppColor.buttonSecondary,
    textHighlightBlue: AppColor.activeButtonDark,
    surface: AppColor.textPrimary,
    inactiveButton: AppColor.inactiveButton,
    activeButton: AppColor.activeButtonDark,
    textWhite: AppColor.textPrimary,
    iconRed: AppColor.iconRed,
    iconBlue: AppColor.iconBlue,
    buttonTertiary: AppColor.buttonTertiary,
    buttonSecondary: AppColor.buttonSecondary,
  );
}

extension ThemeGetter on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;
}

extension AppThemeExtension on ThemeData {
  AppColorExtension get colors =>
      extension<AppColorExtension>() ?? AppTheme._lightAppColors;

  AppFontThemeExtension get fonts =>
      extension<AppFontThemeExtension>() ?? AppTheme._lightFontTheme;
}
