// As páginas (rotas) do aplicativo.
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'digits_page.dart';
import 'game_loader.dart';
import 'level_page.dart';
import 'login_page.dart';
import 'mode_page.dart';
import 'settings_page.dart';
import 'shell_page.dart';
import 'soup_bowl.dart';

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';


// Monta uma página com fundo próprio e transição circular.
// A página nova aparece dentro de um círculo que cresce a partir do centro
// da tela, como a sopa se espalhando. Ao voltar, o círculo encolhe.
// Como o fundo da página nova é opaco, as duas nunca se misturam.
// soup: false tira a sopa do fundo (usado na tela de jogo).
Page<void> _page(GoRouterState state, Widget child, {bool soup = true}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 450),
    reverseTransitionDuration: const Duration(milliseconds: 350),
    child: PageBackground(soup: soup, child: child),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child) {
          // Terminou a animação: mostra a página normalmente, sem recorte.
          if (animation.value >= 1) return child!;
          return ClipPath(
            clipper: _CircleReveal(Curves.easeInOut.transform(animation.value)),
            child: child,
          );
        },
      );
    },
  );
}

// Recorte em círculo: progress vai de 0 (nada aparece) a 1 (tela inteira).
class _CircleReveal extends CustomClipper<Path> {
  _CircleReveal(this.progress);

  final double progress;

  @override
  Path getClip(Size size) {
    // Raio que cobre a tela toda: metade da diagonal.
    final maxRadius = sqrt(size.width * size.width + size.height * size.height) / 2;
    return Path()
      ..addOval(
        Rect.fromCircle(
          center: size.center(Offset.zero),
          radius: maxRadius * progress,
        ),
      );
  }

  @override
  bool shouldReclip(_CircleReveal oldClipper) => oldClipper.progress != progress;
}

// Atualiza o GoRouter quando o estado de autenticação muda.
class _AuthRefreshListenable extends ChangeNotifier {
  _AuthRefreshListenable(Stream<User?> stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<User?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// Cria o roteador. A página inicial vem de fora porque o aplicativo reabre
// na última página guardada (veja persistence.dart e main.dart).
GoRouter buildRouter({required String initialLocation}) {
  final authRefresh = _AuthRefreshListenable(
    FirebaseAuth.instance.authStateChanges(),
  );

  return GoRouter(
    initialLocation: initialLocation,

    refreshListenable: authRefresh,

    // Protege as páginas internas.
    redirect: (context, state) {
      final loggedIn = FirebaseAuth.instance.currentUser != null;

      final location = state.matchedLocation;

      final isLogin = location == '/login';

      // Usuário não autenticado não pode acessar o jogo.
      if (!loggedIn && !isLogin) {
        return '/login';
      }

      // Usuário autenticado não precisa voltar ao login.
      if (loggedIn && isLogin) {
        return '/modes';
      }

      return null;
    },

    routes: [
      // Login e cadastro (a tela do firebase_ui_auth faz os dois)
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) =>
            _page(state, const LoginPage()),
      ),

      // Demais páginas protegidas.
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/modes',
            pageBuilder: (context, state) =>
                _page(state, const ModePage()),
          ),
          GoRoute(
            path: '/levels',
            pageBuilder: (context, state) =>
                _page(state, const LevelPage()),
          ),
          GoRoute(
            path: '/digits',
            pageBuilder: (context, state) =>
                _page(state, const DigitsPage()),
          ),
          GoRoute(
            path: '/game',
            pageBuilder: (context, state) =>
                _page(state, const GameLoader(), soup: false),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) =>
                _page(state, const SettingsPage()),
          ),
        ],
      ),
    ],
  );
}