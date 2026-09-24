import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's chosen locale and theme mode. Kept separate from
/// [HabitProvider] since it changes for entirely different reasons and
/// widgets that only care about theme/locale shouldn't rebuild when habits
/// change (and vice versa).
class SettingsProvider extends ChangeNotifier {
  SettingsProvider({SharedPreferences? preferences})
      : _preferences = preferences;

  static const String _localeKey = 'habit_flow.locale.v1';
  static const String _themeKey = 'habit_flow.theme.v1';

  SharedPreferences? _preferences;
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;

  Locale? get locale => _locale;
  ThemeMode get themeMode => _themeMode;

  Future<SharedPreferences> get _prefs async =>
      _preferences ??= await SharedPreferences.getInstance();

  Future<void> load() async {
    final SharedPreferences prefs = await _prefs;
    final String? lang = prefs.getString(_localeKey);
    if (lang != null) _locale = Locale(lang);
    final String? theme = prefs.getString(_themeKey);
    _themeMode = switch (theme) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(_localeKey, locale.languageCode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(_themeKey, mode.name);
  }
}
