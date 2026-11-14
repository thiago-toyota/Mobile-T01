import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

    return SpoonMenu(
      title: 'Escolha o modo',
      items: [
        SpoonItem(
          title: 'Educativo',
          subtitle: 'Tutorial com um exemplo passo a passo',
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
          title: 'Específico',
          subtitle: 'Você escolhe os 4 algarismos',
          onTap: () {
            mode.select(GameMode.specific);
            context.push('/levels');
          },
        ),
        SpoonItem(
          title: 'Aleatório',
          subtitle: 'O jogo sorteia os 4 algarismos',
          onTap: () {
            mode.select(GameMode.random);
            context.push('/levels');
          },
        ),
      ],
    );
  }
}
