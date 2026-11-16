
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'level.dart';


class LevelNotifier extends Notifier<Level> {
  @override
  Level build() => Level.easy;

  void select(Level level) => state = level;
}

final levelProvider = NotifierProvider<LevelNotifier, Level>(
  LevelNotifier.new,
);

class DigitsNotifier extends Notifier<String> {
  @override
  String build() => '';

  void set(String digits) => state = digits;
}

final digitsProvider = NotifierProvider<DigitsNotifier, String>(
  DigitsNotifier.new,
);


// Famílias tipográficas disponíveis.
enum AppFont {
  roboto('Roboto'),
  garamond('EB Garamond'),
  lato('Lato');

  const AppFont(this.label);

  final String label;
}

// Cores semente disponíveis.
Map<Color, String> seedColors = {
  Color(0xFFF4CC5A): 'chickenBroth',
  Color(0xFF2196F3): 'blue',
  Color(0xFF4CAF50): 'green',
  Color(0xFFE57373): 'red',
  Color(0xFFAB47BC): 'purple',
  Color(0xFFFF9800): 'orange',
  Color(0xFF00897B): 'turquoise',
  Color(0xFF795548): 'brown',
  Color(0xFF607D8B): 'blueGrey',
  Color(0xFFE91E63): 'pink',
};

// Estado de todas as configurações.
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.fontScale = 1.0,
    this.font = AppFont.roboto,
    this.seedColor = const Color(0xFFF4CC5A),
    this.locale,
  });

  final ThemeMode themeMode;
  final double fontScale;
  final AppFont font;
  final Color seedColor;
   final Locale? locale;

  AppSettings copyWith({
    ThemeMode? themeMode,
    double? fontScale,
    AppFont? font,
    Color? seedColor,
    Locale? locale,
    bool clearLocale = false,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      fontScale: fontScale ?? this.fontScale,
      font: font ?? this.font,
      seedColor: seedColor ?? this.seedColor,
      locale: clearLocale ? null : locale ?? this.locale,
    );
  }
}

// Gerencia as configurações.
class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() => const AppSettings();

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  void setFontScale(double scale) {
    state = state.copyWith(fontScale: scale);
  }

  void setFont(AppFont font) {
    state = state.copyWith(font: font);
  }

  void setSeedColor(Color color) {
    state = state.copyWith(seedColor: color);
  }

  void setLocale(Locale? locale) {
    state = state.copyWith(
      locale: locale,
      clearLocale: locale == null,
    );
  }

  void reset() {
    state = const AppSettings();
  }
  
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);
