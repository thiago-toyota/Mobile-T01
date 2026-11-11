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
        final width = min(constraints.maxWidth, 560.0);
        return Center(
          child: SizedBox(
            width: width,
            child: CustomPaint(
              painter: _BowlPainter(),
              child: ConstrainedBox(
                // Altura mínima = 85% da largura (quase um círculo).
                constraints: BoxConstraints(minHeight: width * 0.85),
                child: Padding(
                  padding: EdgeInsets.all(width * 0.14),
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

class _BowlPainter extends CustomPainter {
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