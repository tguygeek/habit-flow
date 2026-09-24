import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';

/// Screen 5: language and theme preferences.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final SettingsProvider settings = context.watch<SettingsProvider>();
    final String currentLang =
        settings.locale?.languageCode ?? Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(l10n.language),
            trailing: SegmentedButton<String>(
              segments: const <ButtonSegment<String>>[
                ButtonSegment<String>(value: 'en', label: Text('EN')),
                ButtonSegment<String>(value: 'fr', label: Text('FR')),
              ],
              selected: <String>{currentLang},
              onSelectionChanged: (Set<String> selection) {
                settings.setLocale(Locale(selection.first));
              },
            ),
          ),
          ListTile(
            title: Text(l10n.theme),
            trailing: SegmentedButton<ThemeMode>(
              segments: <ButtonSegment<ThemeMode>>[
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  label: Text(l10n.systemTheme),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  label: Text(l10n.lightTheme),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  label: Text(l10n.darkTheme),
                ),
              ],
              selected: <ThemeMode>{settings.themeMode},
              onSelectionChanged: (Set<ThemeMode> selection) {
                settings.setThemeMode(selection.first);
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(l10n.about),
            subtitle: Text(l10n.aboutBody),
          ),
        ],
      ),
    );
  }
}
