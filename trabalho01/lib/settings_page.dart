
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ---------------------------------------------------------------
          // Tema
          // ---------------------------------------------------------------

          Text(
            'Aparência',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tema do aplicativo'),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<ThemeMode>(
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text('Sistema'),
                          icon: Icon(Icons.settings_suggest),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text('Claro'),
                          icon: Icon(Icons.light_mode),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text('Escuro'),
                          icon: Icon(Icons.dark_mode),
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
            'Tipografia',
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
                      const Text('Tamanho da fonte'),
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
                      const Text('Pequeno'),
                      Text(
                        'Médio',
                        style: TextStyle(
                          fontSize: 16 * settings.fontScale,
                        ),
                      ),
                      Text(
                        'Grande',
                        style: TextStyle(
                          fontSize: 20 * settings.fontScale,
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  const Text('Família tipográfica'),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<AppFont>(
                    value: settings.font,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Fonte',
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

                  const Text('Pré-visualização'),

                  const SizedBox(height: 8),

                  Text(
                    'A sopa de contas está pronta!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  Text(
                    'Esta é uma demonstração da tipografia selecionada.',
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
            'Cores do aplicativo',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Escolha uma cor semente'),

                  const SizedBox(height: 8),

                  Text(
                    'A cor selecionada será utilizada para gerar '
                    'a paleta do aplicativo.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),

                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      for (final entry in seedColors.entries)
                        Tooltip(
                          message: entry.value,
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
                    'Cor selecionada: '
                    '${seedColors[settings.seedColor] ?? 'Personalizada'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ---------------------------------------------------------------
          // Restaurar configurações
          // ---------------------------------------------------------------

          OutlinedButton.icon(
            onPressed: notifier.reset,
            icon: const Icon(Icons.restore),
            label: const Text('Restaurar configurações padrão'),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
