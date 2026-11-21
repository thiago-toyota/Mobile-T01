import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'l10n/app_localizations.dart';
import 'solved_service.dart';
import 'state.dart';

// Aqui o jogador digita os 4 algarismos. Depois o modo "aleatório"
// vai sortear esses números e esta tela pode ficar só para o modo manual.
class DigitsPage extends ConsumerStatefulWidget {
  const DigitsPage({super.key});

  @override
  ConsumerState<DigitsPage> createState() => _DigitsPageState();
}

class _DigitsPageState extends ConsumerState<DigitsPage> {
  final _controller = TextEditingController();

  bool get _ready => _controller.text.length == 4;

  // true enquanto confere no Firestore se o número já foi resolvido.
  bool _checking = false;

  Future<void> _start() async {
    final digits = _controller.text;
    setState(() => _checking = true);

    var play = true;
    try {
      // Lê os números já resolvidos e vê se este está entre eles.
      await ref.read(solvedProvider.notifier).load();
      if (!mounted) return;
      if (ref.read(solvedProvider).contains(digits)) {
        play = await _askSolveAgain(digits);
      }
    } catch (_) {
      // Não deu para conferir (sem internet?): deixa jogar mesmo assim.
    }

    if (!mounted) return;
    setState(() => _checking = false);
    if (!play) return;

    ref.read(digitsProvider.notifier).set(digits);
    context.push('/game');
  }

  // "Você já resolveu este número. Quer resolver de novo?"
  Future<bool> _askSolveAgain(String digits) async {
    final l10n = AppLocalizations.of(context)!;
    final again = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.alreadySolvedTitle),
        content: Text(l10n.alreadySolvedMessage(digits)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.chooseAnother),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.solveAgain),
          ),
        ],
      ),
    );
    return again ?? false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.digitsPageTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  // Estilo do tema: fonte e tamanho vêm das configurações.
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(letterSpacing: 8),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  decoration: const InputDecoration(
                    hintText: '0000',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) {
                    if (_ready && !_checking) _start();
                  },
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _ready && !_checking ? _start : null,
                  child: Text(l10n.digitsPageStart),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
