import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

  void _start() {
    ref.read(digitsProvider.notifier).set(_controller.text);
    context.push('/game');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escolha os 4 algarismos')),
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
                  style: const TextStyle(fontSize: 32, letterSpacing: 8),
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
                    if (_ready) _start();
                  },
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _ready ? _start : null,
                  child: const Text('Começar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
