import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

// Janela de explicação do modo Educativo.
// "onShowExample" é chamado quando o jogador pede para ver o exemplo
// montado na sopa.
Future<void> showTutorialDialog(
  BuildContext context, {
  required VoidCallback onShowExample,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Bem-vindo ao tutorial'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Objetivo: usar os 4 algarismos, sempre na ordem em '
                'que aparecem, para montar uma igualdade. Aqui os algarismos '
                'são 2 3 3 3.'),
            const SizedBox(height: 12),
            const Text('Exemplo:'),
            const SizedBox(height: 4),
            Center(
              child: Math.tex(
                r'2 \cdot 3 = 3 + 3',
                textStyle: Theme.of(dialogContext).textTheme.headlineSmall,
              ),
            ),
            const Text('Os dois lados dão 6, então a igualdade está correta.'),
            const SizedBox(height: 12),
            const Text('• Arraste os macarrões do prato para os espaços '
                'entre os algarismos.'),
            const SizedBox(height: 6),
            const Text('• Coloque o = e os operadores: '
                '2 ? 3 ? 3 ? 3.'),
            const SizedBox(height: 6),
            const Text('• Para tirar um macarrão da sopa, arraste-o para fora.'),
            const SizedBox(height: 6),
            const Text('• Quando achar que está certo, toque em Verificar.'),
            const SizedBox(height: 6),
            const Text('• Aqui não há tempo nem pontos: fique à vontade '
                'para experimentar.'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(dialogContext).pop();
            onShowExample();
          },
          child: const Text('Ver o exemplo na sopa'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Entendi'),
        ),
      ],
    ),
  );
}
