
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n/app_localizations.dart';
import 'music.dart';

import 'state.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ---------------------------------------------------------------
          // Tema
          // ---------------------------------------------------------------

          Text(
            l10n.appearance,
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.appTheme),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<ThemeMode>(
                      showSelectedIcon: false,
                      segments: [
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text(l10n.system),
                          icon: const Icon(Icons.settings_suggest),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text(l10n.light),
                          icon: const Icon(Icons.light_mode),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text(l10n.dark),
                          icon: const Icon(Icons.dark_mode),
                        ),
                      ],
                      selected: {settings.themeMode},
                      onSelectionChanged: (selected) {
                        notifier.setThemeMode(selected.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ---------------------------------------------------------------
          // Tamanho da fonte
          // ---------------------------------------------------------------

          Text(
            l10n.typography,
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.fontSize),
                      Text(
                        '${(settings.fontScale * 100).round()}%',
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Slider(
                    value: settings.fontScale,
                    min: 0.8,
                    max: 1.2,
                    divisions: 4,
                    label: '${(settings.fontScale * 100).round()}%',
                    onChanged: notifier.setFontScale,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.small),
                      Text(
                        l10n.medium,
                        style: TextStyle(
                          fontSize: 16 * settings.fontScale,
                        ),
                      ),
                      Text(
                        l10n.large,
                        style: TextStyle(
                          fontSize: 20 * settings.fontScale,
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  Text(l10n.fontFamily),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<AppFont>(
                    value: settings.font,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: l10n.font,
                    ),
                    items: AppFont.values.map((font) {
                      return DropdownMenuItem(
                        value: font,
                        child: Text(font.label),
                      );
                    }).toList(),
                    onChanged: (font) {
                      if (font != null) {
                        notifier.setFont(font);
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  Text(l10n.preview),

                  const SizedBox(height: 8),

                  Text(
                    l10n.previewTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  Text(
                    l10n.previewDescription,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ---------------------------------------------------------------
          // Cores
          // ---------------------------------------------------------------

          Text(
            l10n.appColors,
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.chooseSeedColor),

                  const SizedBox(height: 8),

                  Text(
                    l10n.seedColorDescription,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      for (final entry in seedColors.entries)
                        Tooltip(
                          message: switch (entry.value) {
                            'chickenBroth' => l10n.chickenBroth,
                            'blue' => l10n.blue,
                            'green' => l10n.green,
                            'red' => l10n.red,
                            'purple' => l10n.purple,
                            'orange' => l10n.orange,
                            'turquoise' => l10n.turquoise,
                            'brown' => l10n.brown,
                            'blueGrey' => l10n.blueGrey,
                            'pink' => l10n.pink,
                            _ => entry.value,
                          },
                          child: GestureDetector(
                            onTap: () {
                              notifier.setSeedColor(entry.key);
                            },
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: entry.key,
                                shape: BoxShape.circle,
                                border: settings.seedColor == entry.key
                                    ? Border.all(
                                        color: colors.onSurface,
                                        width: 3,
                                      )
                                    : null,
                              ),
                              child: settings.seedColor == entry.key
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    l10n.selectedColor(
                      switch (seedColors[settings.seedColor]) {
                        'chickenBroth' => l10n.chickenBroth,
                        'blue' => l10n.blue,
                        'green' => l10n.green,
                        'red' => l10n.red,
                        'purple' => l10n.purple,
                        'orange' => l10n.orange,
                        'turquoise' => l10n.turquoise,
                        'brown' => l10n.brown,
                        'blueGrey' => l10n.blueGrey,
                        'pink' => l10n.pink,
                        _ => l10n.custom,
                      }
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

                   const SizedBox(height: 24),

          // ---------------------------------------------------------------
          // Música
          // ---------------------------------------------------------------

          Text(
            l10n.music,
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 12),

          Card(
            child: Consumer(
              builder: (context, ref, child) {
                final musicEnabled = ref.watch(musicProvider);

                return SwitchListTile(
                  secondary: Icon(
                    musicEnabled
                        ? Icons.music_note
                        : Icons.music_off,
                  ),
                  subtitle: Text(
                    musicEnabled
                        ? l10n.disableMusic
                        : l10n.enableMusic,
                  ),
                  value: musicEnabled,
                  onChanged: (_) {
                    ref.read(musicProvider.notifier).toggleMusic();
                  },
                );
              },
            ),
          ),

          Card(
          child: RadioGroup<String>(
            groupValue: settings.locale?.languageCode ?? 'system',
            onChanged: (value) {
              if (value == 'system') {
                notifier.setLocale(null);
              } else {
                notifier.setLocale(Locale(value!));
              }
            },
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'system',
                  title: Text(l10n.systemLanguage),
                  secondary: const Icon(Icons.settings),
                ),

                const Divider(height: 1),

                RadioListTile<String>(
                  value: 'pt',
                  title: const Text('🇧🇷  Português'),
                ),

                const Divider(height: 1),

                RadioListTile<String>(
                  value: 'es',
                  title: const Text('🇪🇸  Español'),
                ),

                const Divider(height: 1),

                RadioListTile<String>(
                  value: 'en',
                  title: const Text('🇺🇸  English'),
                ),
              ],
            ),
          ),
        ),
          // ---------------------------------------------------------------
          // Restaurar configurações
          // ---------------------------------------------------------------

          OutlinedButton.icon(
            onPressed: notifier.reset,
            icon: const Icon(Icons.restore),
            label: Text(l10n.restoreDefaultSettings),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
