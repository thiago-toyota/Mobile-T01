import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'level.dart';
import 'state.dart';

const _levelNames = {
  Level.easy: 'Fácil',
  Level.medium: 'Intermediário',
  Level.advanced: 'Avançado',
  Level.hard: 'Difícil',
};

class LevelPage extends ConsumerWidget {
  const LevelPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escolha o nível')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final level in Level.values)
                Card(
                  child: ListTile(
                    title: Text(_levelNames[level]!),
                    // A descrição mostra os símbolos que o nível oferece.
                    subtitle: Text(levelSymbols[level]!.map(symbolLabel).join('   ')),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ref.read(levelProvider.notifier).select(level);
                      context.push('/digits');
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
