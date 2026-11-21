import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/app_localizations.dart';
import 'state.dart';

// Escolha do idioma. É a mesma lista nas configurações e no login:
// as duas mexem no "locale" do settingsProvider, que o persistence.dart
// já guarda. "Sistema" (locale nulo) segue o idioma do aparelho.
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: RadioGroup<String>(
        groupValue: settings.locale?.languageCode ?? 'system',
        onChanged: (value) {
          if (value == 'system') {
            notifier.setLocale(null);
          } else if (value != null) {
            notifier.setLocale(Locale(value));
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              value: 'system',
              title: Text(l10n.systemLanguage),
              secondary: const Icon(Icons.settings),
            ),
            const Divider(height: 1),
            const RadioListTile<String>(
              value: 'pt',
              title: Text('🇧🇷  Português'),
            ),
            const Divider(height: 1),
            const RadioListTile<String>(
              value: 'en',
              title: Text('🇺🇸  English'),
            ),
            const Divider(height: 1),
            const RadioListTile<String>(
              value: 'es',
              title: Text('🇪🇸  Español'),
            ),
          ],
        ),
      ),
    );
  }
}
