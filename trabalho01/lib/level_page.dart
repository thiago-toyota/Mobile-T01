import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'level.dart';
import 'mode.dart';
import 'spoon_menu.dart';
import 'state.dart';

const _levelNames = {
  Level.easy: 'Fácil',
  Level.medium: 'Intermediário',
  Level.advanced: 'Avançado',
  Level.hard: 'Difícil',
};

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
    return SpoonMenu(
      title: 'Escolha o nível',
      items: [
        for (final level in Level.values)
          SpoonItem(
            title: _levelNames[level]!,
            subtitle: _symbolsText(level),
            onTap: () => _choose(context, ref, level),
          ),
      ],
    );
  }
}
