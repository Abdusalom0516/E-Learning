import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object> get props => [];
}

class ChangeLocaleEvent extends LocaleEvent {
  final String languageCode;

  const ChangeLocaleEvent(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}

class LoadLocaleEvent extends LocaleEvent {}

// State
class LocaleState extends Equatable {
  final Locale locale;

  const LocaleState(this.locale);

  @override
  List<Object> get props => [locale];
}

// BLoC
class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  static const String LOCALE_KEY = 'app_locale';

  LocaleBloc() : super(const LocaleState(Locale('en'))) {
    on<ChangeLocaleEvent>(_onChangeLocale);
    on<LoadLocaleEvent>(_onLoadLocale);

    // Load saved locale when bloc is created
    add(LoadLocaleEvent());
  }

  Future<void> _onChangeLocale(
      ChangeLocaleEvent event, Emitter<LocaleState> emit) async {
    final locale = Locale(event.languageCode);
    emit(LocaleState(locale));

    // Save the locale preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LOCALE_KEY, event.languageCode);
  }

  Future<void> _onLoadLocale(
      LoadLocaleEvent event, Emitter<LocaleState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? languageCode = prefs.getString(LOCALE_KEY);

      if (languageCode != null) {
        emit(LocaleState(Locale(languageCode)));
      }
    } catch (e) {
      // If there's an error, keep using the default locale
    }
  }
}

// Extension for easy use with BuildContext
extension LocaleBlocExtension on BuildContext {
  void changeLocale(String languageCode) {
    read<LocaleBloc>().add(ChangeLocaleEvent(languageCode));
  }

  Locale get locale => read<LocaleBloc>().state.locale;
}
