import 'package:flutter/material.dart';

import 'settings_page.dart';

// Abre as configurações numa janela por cima da tela atual (como o Help).
// Assim a tela de baixo, por exemplo uma partida em andamento, continua
// como estava e basta fechar a janela para voltar a ela.
//
// A SettingsPage é usada sem nenhuma mudança: aqui só colocamos ela dentro
// de uma janela e um botão de fechar.
Future<void> showSettingsDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    // Tocar fora da janela também fecha.
    builder: (dialogContext) => Dialog(
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 640),
        child: Stack(
          children: [
            const SettingsPage(),
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                tooltip: 'Fechar',
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
