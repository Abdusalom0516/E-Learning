import 'package:flutter/material.dart';
import 'generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Extension method to get localized strings easier
extension LocalizationExtension on BuildContext {
  /// Get the translation strings instance
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Utility methods for localization
class Localization {
  Localization._();

  /// Get all available locales
  static List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  /// Get all localization delegates
  static List<LocalizationsDelegate<dynamic>> get localizationDelegates => [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ];

  /// Get a friendly display name for a locale
  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'ja':
        return '日本語';
      case 'zh':
        return '中文';
      case 'ar':
        return 'العربية';
      case 'pt':
        return 'Português';
      case 'ru':
        return 'Русский';
      case 'ko':
        return '한국어';
      case 'it':
        return 'Italiano';
      case 'en':
      default:
        return 'English';
    }
  }

  /// Get a flag emoji for a language
  static String getLanguageFlag(String languageCode) {
    switch (languageCode) {
      case 'es':
        return '🇪🇸';
      case 'fr':
        return '🇫🇷';
      case 'de':
        return '🇩🇪';
      case 'ja':
        return '🇯🇵';
      case 'zh':
        return '🇨🇳';
      case 'ar':
        return '🇸🇦';
      case 'pt':
        return '🇧🇷';
      case 'ru':
        return '🇷🇺';
      case 'ko':
        return '🇰🇷';
      case 'it':
        return '🇮🇹';
      case 'en':
      default:
        return '🇺🇸';
    }
  }
}
