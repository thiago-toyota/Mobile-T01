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
            Text('• Nos níveis com potência, dois × seguidos (× ×) '
                'valem uma potência.'),
            SizedBox(height: 6),
            Text('• Você tem 30 segundos. Toque em Verificar para testar.'),
            SizedBox(height: 6),
            Text('• Fora do nível Fácil, divisões e resultados não inteiros '
                'não são permitidos.'),
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