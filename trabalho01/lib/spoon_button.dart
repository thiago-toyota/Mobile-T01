import 'package:flutter/material.dart';

// Tamanho "de projeto" da colher. Ela é desenhada sempre nesse tamanho e,
// se a tela for mais estreita, o FittedBox encolhe a colher INTEIRA
// (concha, cabo e texto) na mesma proporção. Em telas largas, não aumenta.
const double spoonDesignWidth = 560; // público: a tela de níveis usa para calcular a escala
const double _spoonHeight = 100;
const double _bowlWidth = 170; // largura da concha

// Botão em forma de colher, com caldo dentro da concha.
// O nome fica na concha e os símbolos no cabo.
class SpoonButton extends StatefulWidget {
  const SpoonButton({
    super.key,
    required this.title,
    required this.symbols,
    required this.onTap,
  });

  final String title;
  final String symbols;
  final VoidCallback onTap;

  @override
  State<SpoonButton> createState() => _SpoonButtonState();
}

class _SpoonButtonState extends State<SpoonButton> {
  bool _hovering = false; // mouse em cima (na web)

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        // A colher cresce um pouquinho quando o mouse passa por cima.
        child: AnimatedScale(
          scale: _hovering ? 1.04 : 1.0,
          duration: const Duration(milliseconds: 150),
          // scaleDown: só encolhe, nunca aumenta além do tamanho de projeto.
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: spoonDesignWidth,
              height: _spoonHeight,
              child: CustomPaint(
                painter: _SpoonPainter(),
                child: Row(
                  children: [
                    // concha: nome do nível
                    SizedBox(
                      width: _bowlWidth,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6B4A12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // cabo: símbolos do nível
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 28),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.symbols,
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SpoonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cy = size.height / 2;
    final bowl = Rect.fromLTWH(0, 0, _bowlWidth, size.height);

    // Silhueta da colher = concha (oval) + cabo (afina no pescoço e alarga na ponta).
    final neckX = _bowlWidth - 8;
    final endX = size.width - 22;
    final handle = Path()
      ..moveTo(neckX, cy - 13)
      ..lineTo(endX, cy - 22)
      ..arcToPoint(Offset(endX, cy + 22), radius: const Radius.circular(22))
      ..lineTo(neckX, cy + 13)
      ..close();
    final spoon = Path.combine(
      PathOperation.union,
      Path()..addOval(bowl),
      handle,
    );

    // sombra, metal e contorno
    canvas.drawShadow(spoon, Colors.black, 4, false);
    canvas.drawPath(
      spoon,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF2F2F2), Color(0xFFB5B8BD)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      spoon,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF8E9298),
    );

    // caldo dentro da concha
    final broth = bowl.deflate(9);
    canvas.drawOval(
      broth,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFFF1B8), Color(0xFFF4CC5A)],
        ).createShader(broth),
    );
  }

  // O desenho é sempre o mesmo, então nunca precisa redesenhar.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}