import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'expression.dart';
import 'level.dart';
import 'noodle.dart';
import 'soup_bowl.dart';
import 'state.dart';

const int _gameSeconds = 30;

// Um macarrão sendo arrastado. Se veio da sopa, guardamos a posição dele
// na lista (fromIndex). Se veio do prato, fromIndex é nulo.
class Piece {
  const Piece(this.symbol, {this.fromIndex});

  final String symbol;
  final int? fromIndex;
}

bool _isDigitToken(String t) => t.length == 1 && '0123456789'.contains(t);

String _errorText(GameError error) {
  switch (error) {
    case GameError.noEquals:
      return 'Falta o sinal de =';
    case GameError.manyEquals:
      return 'Use só um sinal de =';
    case GameError.emptySide:
      return 'Os dois lados do = precisam ter algo';
    case GameError.missingOperator:
      return 'Falta um operador entre dois números';
    case GameError.badSyntax:
      return 'Expressão inválida (confira operadores e parênteses)';
    case GameError.divisionByZero:
      return 'Divisão por zero';
    case GameError.nonIntegerDivision:
      return 'Divisão não inteira não é permitida neste nível';
    case GameError.notInteger:
      return 'Resultado não inteiro não é permitido neste nível';
    case GameError.badFactorial:
      return 'Fatorial só vale para inteiros não negativos';
    case GameError.undefined:
      return 'Esta conta não tem resultado válido';
  }
}

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage>
    with SingleTickerProviderStateMixin {
  late final Level _level;

  // Animação: os macarrões ficam balançando de leve no caldo (repete para sempre).
  late final AnimationController _bob;


  late final List<String> _tray; // macarrões do prato (infinitos)

  // A expressão inteira, na ordem em que aparece na sopa.
  // Começa só com os 4 algarismos, ex.: ['1','0','1','0'].
  // Os operadores são inseridos em qualquer posição; os algarismos nunca mudam de ordem.
  final List<String> _items = [];

  int _secondsLeft = _gameSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _bob = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
    _level = ref.read(levelProvider);
    _tray = buildTray(_level);
    final digits = ref.read(digitsProvider);
    _items.addAll(digits.split(''));
    // Só começa a contar se os 4 algarismos existem.
    if (digits.length == 4) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    }
  }

  @override
  void dispose() {
    _bob.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------------- tempo

  void _tick() {
    setState(() => _secondsLeft--);
    if (_secondsLeft <= 0) {
      _timer?.cancel();
      _showEndDialog('Tempo esgotado', 'Não deu tempo desta vez.');
    }
  }

  Future<void> _showEndDialog(String title, String message) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    context.go('/levels');
  }

  // ------------------------------------------------- mover os macarrões

  // Quantos símbolos (tudo que não é algarismo) já estão na sopa.
  int get _usedCount => _items.where((t) => !_isDigitToken(t)).length;

  // Soltou um macarrão no ponto de inserção "index" (antes do item de mesmo índice).
  void _place(int index, Piece piece) {
    // Veio do prato: aumenta a quantidade usada, então confere o limite.
    if (piece.fromIndex == null && _usedCount >= maxOperators) {
      _showMessage('Limite de $maxOperators operadores na sopa');
      return;
    }
    setState(() {
      if (piece.fromIndex == null) {
        _items.insert(index, piece.symbol);
      } else {
        // Veio de outro lugar da sopa: só muda de posição.
        final from = piece.fromIndex!;
        _items.removeAt(from);
        // Ao remover o item de antes, os índices depois dele andam uma casa.
        _items.insert(from < index ? index - 1 : index, piece.symbol);
      }
    });
  }

  // Soltou fora de qualquer ponto de inserção: se estava na sopa, o macarrão some.
  // (O prato é infinito, então não precisa devolver nada.)
  void _dropOutside(Piece piece) {
    if (piece.fromIndex == null) return;
    setState(() => _items.removeAt(piece.fromIndex!));
  }

  // Vassourinha: tira todos os operadores, ficam só os algarismos.
  void _clear() {
    setState(() => _items.removeWhere((t) => !_isDigitToken(t)));
  }

  // ----------------------------------------------------------- conferir

  void _check() {
    try {
      final correct = checkEquation(
        _items,
        allowFractions: allowsFractions(_level),
        allowPower: allowsPower(_level),
      );
      if (correct) {
        _timer?.cancel();
        _showEndDialog('Acertou!', 'A igualdade está correta.');
      } else {
        _showMessage('Os dois lados são diferentes');
      }
    } on GameException catch (e) {
      _showMessage(_errorText(e.error));
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  // ------------------------------------------------------------- widgets

  // Macarrão que pode ser arrastado.
  Widget _draggable(Piece piece) {
    return Draggable<Piece>(
      data: piece,
      feedback: Material(
        color: Colors.transparent,
        child: Noodle(piece.symbol),
      ),
      // No prato o macarrão não some (é infinito); na sopa, fica apagado.
      childWhenDragging: piece.fromIndex == null
          ? Noodle(piece.symbol)
          : Opacity(opacity: 0.3, child: Noodle(piece.symbol)),
      onDraggableCanceled: (_, __) => _dropOutside(piece),
      child: Noodle(piece.symbol),
    );
  }

  // Faz o widget subir e descer de leve, como se boiasse no caldo.
  // O "index" muda a fase para os macarrões não se mexerem todos juntos.
  Widget _float(int index, Widget child) {
    return AnimatedBuilder(
      animation: _bob,
      child: child,
      builder: (context, child) {
        final angle = _bob.value * 2 * pi + index;
        return Transform.translate(offset: Offset(0, sin(angle) * 3), child: child);
      },
    );
  }

  // Um ponto de inserção: fica entre dois itens da expressão (ou nas pontas).
  // Dá para soltar quantos macarrões quiser em qualquer um deles.
  Widget _insertionPoint(int index) {
    final prevIsDigit = index > 0 && _isDigitToken(_items[index - 1]);
    final nextIsDigit = index < _items.length && _isDigitToken(_items[index]);
    // Dois algarismos lado a lado: falta algo ali, então o espaço é maior.
    final gap = prevIsDigit && nextIsDigit;

    return DragTarget<Piece>(
      onAcceptWithDetails: (details) => _place(index, details.data),
      builder: (context, candidates, rejected) {
        final hovering = candidates.isNotEmpty;
        // O espaço é sempre invisível. A única pista aparece quando o macarrão
        // está em cima dele: um tracinho laranja mostra onde ele vai entrar.
        // (Para não mostrar nada, é só deixar a largura do tracinho em 0.)
        return SizedBox(
          width: gap ? 40 : 24,
          height: 56,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: hovering ? 4 : 0,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      },
    );
  }

  // A expressão boiando no caldo: ponto de inserção, item, ponto, item...
  Widget _soup() {
    // Uma linha só (Row). O FittedBox encolhe a linha inteira se ela não couber
    // na largura da tigela (ex.: 4 algarismos + 9 símbolos, ou tela pequena).
    return SoupBowl(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var i = 0; i <= _items.length; i++) ...[
              _insertionPoint(i),
              if (i < _items.length)
                _float(
                  i,
                  _isDigitToken(_items[i])
                      ? Noodle(_items[i], big: true) // algarismo: fixo
                      : _draggable(Piece(_items[i], fromIndex: i)),
                ),
            ],
          ],
        ),
      ),
    );
  }

  // Guardanapo com a fórmula em LaTeX.
  Widget _napkin() {
    final latex = previewLatex(_items, allowPower: allowsPower(_level));
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Center(
          child: Math.tex(
            latex,
            textStyle: const TextStyle(fontSize: 28, color: Colors.black87),
            onErrorFallback: (_) => Text(latex),
          ),
        ),
      ),
    );
  }

  // Prato com os macarrões (visualmente separado da sopa).
  Widget _plate() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDCE6F2),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: const Color(0xFF8FB8DE), width: 4),
      ),
      child: Column(
        children: [
          Text('Prato de macarrões: arraste para a sopa ($_usedCount/$maxOperators)'),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [for (final symbol in _tray) _draggable(Piece(symbol))],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final digits = ref.watch(digitsProvider);

    // Se abriu esta tela sem escolher os algarismos (ex.: recarregou a página).
    if (digits.length != 4) {
      return Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/levels'),
            child: const Text('Voltar ao início'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tempo: $_secondsLeft',
          style: TextStyle(color: _secondsLeft <= 10 ? Colors.red : null),
        ),
        actions: [
          IconButton(
            tooltip: 'Limpar',
            icon: const Icon(Icons.cleaning_services),
            onPressed: _clear,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _soup(),
                  const SizedBox(height: 16),
                  _napkin(),
                  const SizedBox(height: 16),
                  _plate(),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _check,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Verificar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}