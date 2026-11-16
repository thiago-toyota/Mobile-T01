
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'l10n/app_localizations.dart';

import 'level.dart';
import 'mode.dart';
import 'spoon_menu.dart';
import 'state.dart';

// Escolha do modo de jogo: a primeira tela depois do login.
class ModePage extends ConsumerWidget {
  const ModePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.read(modeProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return SpoonMenu(
      title: l10n.chooseMode,
      items: [
        SpoonItem(
          title: l10n.educational,
          subtitle: l10n.tutorialStepByStep,
          onTap: () {
            mode.select(GameMode.educational);
            // O tutorial é sempre com 2 3 3 3. Usa o nível com menos
            // símbolos, para o prato não ficar cheio de macarrões.
            ref.read(levelProvider.notifier).select(Level.hard);
            ref.read(digitsProvider.notifier).set('2333');
            context.push('/game');
          },
        ),
        SpoonItem(
          title: l10n.specific,
          subtitle: l10n.chooseFourDigits,
          onTap: () {
            mode.select(GameMode.specific);
            context.push('/levels');
          },
        ),
        SpoonItem(
          title: l10n.random,
          subtitle: l10n.gameChoosesFourDigits,
          onTap: () {
            mode.select(GameMode.random);
            context.push('/levels');
          },
        ),
      ],
    );
  }
}
