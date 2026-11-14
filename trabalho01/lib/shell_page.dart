import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'help_dialog.dart';
import 'settings_dialog.dart';

// Moldura que envolve todas as telas depois do login.
// A barra de navegação curva fica aqui, então ela aparece em todas elas.
// O "child" é a tela atual (níveis, algarismos ou jogo).
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location; // caminho atual, ex.: '/game'
  final Widget child;

  // Posição de cada ícone na barra.
  static const _homeIndex = 0;
  static const _settingsIndex = 1;
  static const _helpIndex = 2;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final iconColor = colors.onPrimaryContainer;

    return Scaffold(
      // Fundo liso: a sopa do fundo é desenhada por cada página (PageBackground).
      backgroundColor: colors.surface,
      body: child,
      bottomNavigationBar: CurvedNavigationBar(
        // Configurações e ajuda são janelas, não páginas: a barra fica
        // sempre no ícone da casa.
        index: _homeIndex,
        height: 60,
        color: colors.primaryContainer,
        buttonBackgroundColor: colors.primaryContainer,
        backgroundColor: Colors.transparent,
        items: [
          Icon(Icons.home, color: iconColor),
          Icon(Icons.settings, color: iconColor),
          Icon(Icons.help_outline, color: iconColor),
        ],
        // Configurações e ajuda abrem uma janela por cima da tela atual e a
        // barra não muda de ícone. Por isso devolvemos false.
        letIndexChange: (index) {
          if (index == _settingsIndex) {
            showSettingsDialog(context);
            return false;
          }
          if (index == _helpIndex) {
            showHelpDialog(context);
            return false;
          }
          return true;
        },
        onTap: (index) {
          if (index == _homeIndex) context.go('/levels');
        },
      ),
    );
  }
}