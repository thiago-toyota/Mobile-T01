import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'level.dart';
import 'soup_bowl.dart';
import 'spoon_button.dart';
import 'state.dart';

const _levelNames = {
  Level.easy: 'Fácil',
  Level.medium: 'Intermediário',
  Level.advanced: 'Avançado',
  Level.hard: 'Difícil',
};

class LevelPage extends ConsumerWidget {
  const LevelPage({super.key});

  // Uma colher que escolhe o nível ao ser tocada.
  Widget _spoon(BuildContext context, WidgetRef ref, Level level) {
    return SpoonButton(
      title: _levelNames[level]!,
      // A potência não tem macarrão próprio, então aparece como "× ×".
      symbols: [
        ...levelSymbols[level]!.map(symbolLabel),
        if (allowsPower(level)) '××',
      ].join(' '),
      onTap: () {
        ref.read(levelProvider.notifier).select(level);
        context.push('/digits');
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Este LayoutBuilder enxerga o mesmo espaço que a tigela do fundo,
    // então a conta do tamanho da tigela dá o mesmo resultado nos dois.
    return LayoutBuilder(
      builder: (context, constraints) {
        // A colher mede 85% da tigela do fundo (no máximo o tamanho de projeto).
        // Quando a tigela encolhe para caber na tela, a colher encolhe junto.
        final spoonWidth = min(spoonDesignWidth, bowlSizeFor(constraints) * 0.85);
        final scale = spoonWidth / spoonDesignWidth;

        return Scaffold(
          // O corpo ocupa a tela inteira (inclusive atrás da barra de título).
          // Assim o centro do corpo é o mesmo centro da tigela do fundo,
          // e as colheres ficam no meio da sopa.
          extendBodyBehindAppBar: true,
          appBar: AppBar(title: const Text('Escolha o nível')),
          body: Center(
            child: SingleChildScrollView(
              // Margem igual em cima e embaixo: mantém o grupo centralizado
              // e deixa as colheres longe da barra de título se precisar rolar.
              padding: EdgeInsets.symmetric(vertical: kToolbarHeight),
              child: SizedBox(
                width: spoonWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < Level.values.length; i++)
                      Padding(
                        // Espaço entre as colheres, também acompanhando a escala.
                        padding: EdgeInsets.only(top: i == 0 ? 0 : 16 * scale),
                        child: _spoon(context, ref, Level.values[i]),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}