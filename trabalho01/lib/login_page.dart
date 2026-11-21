import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'language_selector.dart';

const _googleClientId = '205156906686-61th3155ctov5csc8k2k9hlgedd8oc1t.apps.googleusercontent.com';

const _groupMembers = ['Raul Yoshiyuki Komai', 'Thiago Massayuki Toyota'];

// Tela de login e cadastro, pronta do firebase_ui_auth.
// Ela já tem: entrar com e-mail/senha, "criar conta" (cadastro),
// "esqueci a senha" e o botão de entrar com o Google. Os textos e as
// mensagens de erro dela são traduzidos pelo firebase_ui_localizations.
//
// Depois de entrar, o redirect do roteador (router.dart) leva para /modes.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // O SignInScreen ocupa a tela inteira. Para a largura ficar igual à das
    // outras telas (e encolher junto com a janela), limitamos ele a 400 px
    // de largura e centralizamos. Em telas menores que isso, ele usa a
    // largura toda; em maiores, fica no meio. Como ele nunca passa do
    // "breakpoint" (800 px), usa sempre o layout de uma coluna só, e a
    // página rola quando o conteúdo não cabe na altura.
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: _signIn(),
      ),
    );
  }

  Widget _signIn() {
    return SignInScreen(
      providers: [
        EmailAuthProvider(),
        GoogleProvider(clientId: _googleClientId),
      ],

      // Em cima do formulário: nome do jogo e grupo. O cabeçalho tem altura
      // limitada (headerMaxExtent), por isso só leva o que é pequeno.
      headerMaxExtent: 220,
      headerBuilder: (context, constraints, shrinkOffset) {
        // Ao rolar a página, a altura do cabeçalho vai diminuindo até zero.
        // Se o conteúdo fosse uma Column comum, ele passaria da altura e
        // apareceria "bottom overflowed". Dentro de um SingleChildScrollView
        // (com rolagem desligada), o conteúdo só é cortado, sem erro.
        return const SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(20),
          child: _GameTitle(),
        );
      },

      // Embaixo do formulário: escolha do idioma (a especificação pede
      // o seletor também na página de login).
      footerBuilder: (context, action) {
        return const Padding(
          padding: EdgeInsets.only(top: 24, bottom: 24),
          child: LanguageSelector(),
        );
      },
    );
  }
}

// Nome do jogo e integrantes do grupo.
class _GameTitle extends StatelessWidget {
  const _GameTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppLocalizations.of(context)!.appTitle,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        for (final name in _groupMembers) Text(name),
      ],
    );
  }
}