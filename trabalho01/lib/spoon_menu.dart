import 'dart:math';

import 'package:flutter/material.dart';

import 'soup_bowl.dart';
import 'spoon_button.dart';

// Uma opção do menu de colheres.
class SpoonItem {
  const SpoonItem({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title; // aparece na concha
  final String subtitle; // aparece no cabo
  final VoidCallback onTap;
}

// Tela inteira com uma lista de colheres no meio da sopa do fundo.
// É usada pela escolha do modo e pela escolha do nível.
class SpoonMenu extends StatelessWidget {
  const SpoonMenu({super.key, required this.title, required this.items});

  final String title;
  final List<SpoonItem> items;

  @override
  Widget build(BuildContext context) {
    // Este LayoutBuilder enxerga o mesmo espaço que a tigela do fundo,
    // então a conta do tamanho da tigela dá o mesmo resultado nos dois.
    return LayoutBuilder(
      builder: (context, constraints) {
        // A colher mede 85% da tigela do fundo (no máximo o tamanho de projeto).
        // Quando a tigela encolhe para caber na tela, a colher encolhe junto.
        final spoonWidth = min(spoonDesignWidth, bowlSizeFor(constraints) * 0.70);
        final scale = spoonWidth / spoonDesignWidth;

        return Scaffold(
          // O corpo ocupa a tela inteira (inclusive atrás da barra de título).
          // Assim o centro do corpo é o mesmo centro da tigela do fundo,
          // e as colheres ficam no meio da sopa.
          extendBodyBehindAppBar: true,
          appBar: AppBar(title: Text(title)),
          body: Center(
            child: SingleChildScrollView(
              // Margem igual em cima e embaixo: mantém o grupo centralizado
              // e deixa as colheres longe da barra de título se precisar rolar.
              padding: const EdgeInsets.symmetric(vertical: kToolbarHeight),
              child: SizedBox(
                width: spoonWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < items.length; i++)
                      Padding(
                        // Espaço entre as colheres, também acompanhando a escala.
                        padding: EdgeInsets.only(top: i == 0 ? 0 : 16 * scale),
                        child: SpoonButton(
                          title: items[i].title,
                          symbols: items[i].subtitle,
                          onTap: items[i].onTap,
                        ),
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
