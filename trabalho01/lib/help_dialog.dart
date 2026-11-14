import 'package:flutter/material.dart';

// Janelinha de ajuda, aberta pelo ícone "?" da barra de navegação.
Future<void> showHelpDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Como jogar'),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Objetivo: montar uma igualdade usando os 4 algarismos '
                'na ordem em que aparecem. Exemplo: 3 × 2 = 3 + 3.'),
            SizedBox(height: 12),
            Text('• Arraste os macarrões do prato para a sopa, '
                'antes, depois ou entre os algarismos.'),
            SizedBox(height: 6),
            Text('• Para tirar um macarrão, arraste-o para fora da sopa.'),
            SizedBox(height: 6),
            Text('• Você pode usar até 9 símbolos ao todo, '
                'incluindo parênteses e o sinal de =.'),
            SizedBox(height: 6),
            Text('• Dois algarismos lado a lado não formam um número maior: '
                'é preciso um operador entre eles.'),
            SizedBox(height: 6),
            Text('• Nos níveis Fácil e Intermediário, dois × seguidos (× ×) '
                'valem uma potência.'),
            SizedBox(height: 6),
            Text('• Fora do nível Fácil, divisões e resultados não inteiros '
                'não são permitidos.'),
            SizedBox(height: 12),
            Text('Tempo e pontos',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text('• Você tem 30 segundos. Toque em Verificar para testar.'),
            SizedBox(height: 6),
            Text('• Se o tempo acabar, você perde 10 pontos e o relógio '
                'reinicia.'),
            SizedBox(height: 6),
            Text('• Cada símbolo na sopa vale pontos: + − × ÷ base e teto '
                'valem 10; potência (× ×), raízes valem 20; ! e módulo '
                'valem 30. Parênteses não valem nada.'),
            SizedBox(height: 6),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Entendi'),
        ),
      ],
    ),
  );
}