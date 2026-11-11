// As páginas (rotas) do aplicativo.
import 'package:go_router/go_router.dart';

import 'digits_page.dart';
import 'game_page.dart';
import 'level_page.dart';
import 'login_page.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/levels', builder: (context, state) => const LevelPage()),
    GoRoute(path: '/digits', builder: (context, state) => const DigitsPage()),
    GoRoute(path: '/game', builder: (context, state) => const GamePage()),
  ],
);
