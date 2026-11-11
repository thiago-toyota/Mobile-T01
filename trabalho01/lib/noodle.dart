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
      child: Text(
        symbolLabel(symbol),
        style: TextStyle(
          fontSize: big ? 30 : 24,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF6B4A12),
        ),
      ),
    );
  }
}
