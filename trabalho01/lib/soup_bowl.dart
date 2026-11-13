import 'dart:math';

import 'package:flutter/material.dart';

// A tigela de sopa, desenhada por código (sem imagens).
// O "child" fica em cima do caldo.
// A altura é proporcional à largura, para a tigela ficar bem redonda.
class SoupBowl extends StatelessWidget {
  const SoupBowl({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Tigela larga: até 900 de largura.
        final width = min(constraints.maxWidth, 900.0);
        return Center(
          child: SizedBox(
            width: width,
            child: CustomPaint(
              painter: BowlPainter(),
              child: ConstrainedBox(
                // Altura mínima: 55% da largura, e nunca menos que 300.
                constraints: BoxConstraints(minHeight: max(width * 0.55, 300.0)),
                child: Padding(
                  // A expressão fica numa linha só, no meio da tigela,
                  // onde ela é mais larga. Por isso a margem lateral é pequena.
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.06,
                    vertical: width * 0.06,
                  ),
                  child: Center(child: child),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Tamanho da tigela do fundo para o espaço disponível na tela.
// Fica numa função para outros widgets (como as colheres) poderem usar a
// mesma conta e acompanhar a tigela quando ela encolhe.
double bowlSizeFor(BoxConstraints constraints) =>
    min(constraints.maxWidth, constraints.maxHeight);

// Tigela grande e translúcida que fica no fundo das telas.
// É colocada pelo PageBackground, atrás do conteúdo de cada página.
class SoupBackground extends StatelessWidget {
  const SoupBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = bowlSizeFor(constraints);
          return Center(
            child: Opacity(
              opacity: 0.35, // quanto menor, mais transparente
              child: SizedBox(
                width: size,
                height: size * 0.9,
                child: CustomPaint(painter: BowlPainter()),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Fundo de uma página. Cada página carrega o seu próprio fundo OPACO
// (com ou sem a sopa translúcida). Assim, na troca de telas, a página nova
// cobre a antiga por completo e as duas não se misturam.
class PageBackground extends StatelessWidget {
  const PageBackground({super.key, required this.child, this.soup = true});

  final Widget child;
  final bool soup; // false: fundo liso (usado na tela de jogo)

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (soup)
          const SoupBackground()
        else
          ColoredBox(color: Theme.of(context).colorScheme.surface),
        child,
      ],
    );
  }
}

// Desenha a tigela dentro do espaço que receber.
class BowlPainter extends CustomPainter {
  // Pedacinhos boiando no caldo (posição em fração da tigela).
  // Posições pares são cenouras, ímpares são salsinha.
  static const _bits = [
    Offset(0.18, 0.35),
    Offset(0.82, 0.40),
    Offset(0.30, 0.80),
    Offset(0.70, 0.78),
    Offset(0.50, 0.12),
    Offset(0.12, 0.62),
    Offset(0.88, 0.62),
    Offset(0.50, 0.90),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final outer = Offset.zero & size;

    // sombra embaixo da tigela
    canvas.drawOval(
      outer.shift(const Offset(0, 6)),
      Paint()..color = const Color(0x33000000),
    );

    // louça (borda da tigela)
    canvas.drawOval(outer, Paint()..color = const Color(0xFFFFFBF0));
    canvas.drawOval(
      outer,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = const Color(0xFF8FB8DE),
    );

    // parte de dentro da tigela
    final inner = outer.deflate(size.shortestSide * 0.06);
    canvas.drawOval(inner, Paint()..color = const Color(0xFFE9E1CF));

    // caldo de galinha
    final broth = inner.deflate(6);
    canvas.drawOval(
      broth,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFFF1B8), Color(0xFFF4CC5A)],
        ).createShader(broth),
    );

    // cenouras e salsinha
    for (var i = 0; i < _bits.length; i++) {
      final center = Offset(size.width * _bits[i].dx, size.height * _bits[i].dy);
      final color = i.isEven ? const Color(0xFFF2994A) : const Color(0xFF6FA84B);
      canvas.drawCircle(center, 7, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}