import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'game_page.dart';
import 'l10n/app_localizations.dart';
import 'mode.dart';
import 'soup_loader.dart';
import 'solved_service.dart';
import 'state.dart';


// Porteiro da tela de jogo.
//
// No modo Aleatório, antes de mostrar a partida é preciso saber quais
// números o jogador já resolveu (Firestore) para sortear um novo. Esta
// página espera isso com um FutureBuilder, mostrando o SoupLoader enquanto
// carrega, e só então abre o GamePage.
//
// Nos outros modos não há o que esperar: abre o GamePage direto.
class GameLoader extends ConsumerStatefulWidget {
  const GameLoader({super.key});

  @override
  ConsumerState<GameLoader> createState() => _GameLoaderState();
}

class _GameLoaderState extends ConsumerState<GameLoader> {
  late Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = _prepare();
  }

  Future<void> _prepare() async {
    if (ref.read(modeProvider) != GameMode.random) return;

    // 1) Lê os números já resolvidos.
    //await ref.read(solvedProvider.notifier).load();
    await Future.wait([
    ref.read(solvedProvider.notifier).load(),
    Future<void>.delayed(const Duration(seconds: 1)),
  ]);

    // 2) Se ainda não há número (acabou de escolher o nível) ou o número
    //    guardado já foi resolvido, sorteia um novo. Se o jogador só
    //    recarregou a página no meio de uma partida, o número continua o mesmo.
    final digits = ref.read(digitsProvider);
    final solved = ref.read(solvedProvider);
    if (digits.length != 4 || solved.contains(digits)) {
      ref.read(digitsProvider.notifier).set(pickUnsolvedDigits(solved));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<void>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SoupLoader(),
                const SizedBox(height: 16),
                Text(l10n.loadingSoup),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.loadError, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => setState(() => _future = _prepare()),
                    child: Text(l10n.tryAgain),
                  ),
                ],
              ),
            ),
          );
        }

        return const GamePage();
      },
    );
  }
}
