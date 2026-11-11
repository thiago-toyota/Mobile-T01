import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';

void main() {
  // ProviderScope é o que liga o Riverpod ao aplicativo.
  runApp(const ProviderScope(child: SoupApp()));
}

class SoupApp extends StatelessWidget {
  const SoupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sopa de Contas',
      routerConfig: router,
      theme: ThemeData(
        // Cor semente: caldo de galinha. Depois vira opção nas configurações.
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF4CC5A)),
        useMaterial3: true,
      ),
    );
  }
}
