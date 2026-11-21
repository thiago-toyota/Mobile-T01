import 'dart:math';

import 'package:flutter/material.dart';

// Indicador de carregamento próprio do jogo (no lugar do
// CircularProgressIndicator padrão): cinco macarrões com os símbolos da
// sopa giram em círculo, como se alguém estivesse mexendo o caldo.
class SoupLoader extends StatefulWidget {
  const SoupLoader({super.key, this.size = 120});

  final double size;

  @override
  State<SoupLoader> createState() => _SoupLoaderState();
}

class _SoupLoaderState extends State<SoupLoader>
    with SingleTickerProviderStateMixin {
  static const _symbols = ['+', '−', '×', '÷', '='];

  // Uma volta completa a cada 3 segundos, repetindo para sempre.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final pieceSize = widget.size * 0.3;
    final radius = (widget.size - pieceSize) / 2;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              for (var i = 0; i < _symbols.length; i++)
                _piece(
                  symbol: _symbols[i],
                  // Cada macarrão começa num ponto diferente do círculo.
                  angle: 2 * pi * (_controller.value + i / _symbols.length),
                  radius: radius,
                  size: pieceSize,
                  colors: colors,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _piece({
    required String symbol,
    required double angle,
    required double radius,
    required double size,
    required ColorScheme colors,
  }) {
    return Transform.translate(
      offset: Offset(cos(angle) * radius, sin(angle) * radius),
      child: Transform.rotate(
        angle: angle + pi / 2,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(size / 2),
            border: Border.all(color: colors.primary, width: 1.5),
          ),
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                symbol,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colors.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
