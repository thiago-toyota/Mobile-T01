import 'package:flutter/material.dart';

import 'level.dart';

// Um "macarrão" de sopa de letrinhas: usado para os algarismos (big)
// e para os operadores.
class Noodle extends StatelessWidget {
  const Noodle(this.symbol, {super.key, this.big = false});

  final String symbol;
  final bool big;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = big ? 56.0 : 44.0;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF7DC9B),
        borderRadius: BorderRadius.circular(size / 2.5),
        border: Border.all(color: const Color(0xFFD9A441), width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 3, offset: Offset(1, 2)),
        ],
      ),
      // O FittedBox encolhe o símbolo se, com fonte grande, ele não couber
      // no macarrão. O macarrão em si mantém o tamanho fixo.
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            symbolLabel(symbol),
            // Estilo do tema: a fonte e o tamanho vêm das configurações.
            style: (big ? textTheme.headlineMedium : textTheme.headlineSmall)
                ?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6B4A12),
            ),
          ),
        ),
      ),
    );
  }
}