
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'level.dart';
import 'mode.dart';
import 'spoon_menu.dart';
import 'state.dart';
import 'l10n/app_localizations.dart';

class LevelPage extends ConsumerWidget {
  const LevelPage({super.key});

  // Texto do cabo da colher: os símbolos do nível.
  String _symbolsText(Level level) {
    return [
      ...levelSymbols[level]!.map(symbolLabel),
      // A potência não tem macarrão próprio, então aparece como "××".
      if (allowsPower(level)) '××',
    ].join(' ');
  }

  // Escolheu um nível: o que vem depois depende do modo.
  void _choose(BuildContext context, WidgetRef ref, Level level) {
    ref.read(levelProvider.notifier).select(level);

    if (ref.read(modeProvider) == GameMode.random) {
      // Aleatório: sorteia os algarismos e vai direto para o jogo.
      ref.read(digitsProvider.notifier).set(randomDigits());
      context.push('/game');
    } else {
      // Específico: o jogador digita os algarismos.
      context.push('/digits');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final levelNames = {
      Level.easy: l10n.levelEasy,
      Level.medium: l10n.levelMedium,
      Level.advanced: l10n.levelAdvanced,
      Level.hard: l10n.levelHard,
    };

    return SpoonMenu(
      title: l10n.levelPageTitle,
      items: [
        for (final level in Level.values)
          SpoonItem(
            title: levelNames[level]!,
            subtitle: _symbolsText(level),
            onTap: () => _choose(context, ref, level),
          ),
      ],
    );
  }
}
