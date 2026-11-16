
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'expression.dart';
import 'level.dart';
import 'mode.dart';
import 'noodle.dart';
import 'score.dart';
import 'soup_bowl.dart';
import 'state.dart';
import 'tutorial_dialog.dart';
import 'l10n/app_localizations.dart';

const int _gameSeconds = 30;

// Um macarrão sendo arrastado. Se veio da sopa, guardamos a posição dele
// na lista (fromIndex). Se veio do prato, fromIndex é nulo.
class Piece {
  const Piece(this.symbol, {this.fromIndex});

  final String symbol;
  final int? fromIndex;
}

bool _isDigitToken(String t) => t.length == 1 && '0123456789'.contains(t);

String _errorText(GameError error, AppLocalizations l10n) {
  switch (error) {
    case GameError.noEquals:
      return l10n.errorNoEquals;
    case GameError.manyEquals:
      return l10n.errorManyEquals;
    case GameError.emptySide:
      return l10n.errorEmptySide;
    case GameError.missingOperator:
      return l10n.errorMissingOperator;
    case GameError.badSyntax:
      return l10n.errorBadSyntax;
    case GameError.divisionByZero:
      return l10n.errorDivisionByZero;
    case GameError.nonIntegerDivision:
      return l10n.errorNonIntegerDivision;
    case GameError.notInteger:
      return l10n.errorNotInteger;
    case GameError.badFactorial:
      return l10n.errorBadFactorial;
    case GameError.undefined:
      return l10n.errorUndefined;
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

  // true no modo Educativo: sem tempo, sem pontos e com a janela de explicação.
  late final bool _tutorial;

  // true no modo Aleatório: o jogador pode pular o número (perde pontos).
  late final bool _isRandomMode;

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
    final mode = ref.read(modeProvider);
    _tutorial = mode == GameMode.educational;
    _isRandomMode = mode == GameMode.random;
    _tray = buildTray(_level);
    final digits = ref.read(digitsProvider);
    _items.addAll(digits.split(''));
    // O relógio só roda se os 4 algarismos existem e não é o tutorial.
    if (digits.length == 4 && !_tutorial) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    }
    // No tutorial, a janela de explicação abre assim que a tela aparece.
    if (_tutorial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showTutorial();
      });
    }
  }

  // Pular o número (só no modo Aleatório): confirma, tira pontos,
  // sorteia outro número e recomeça o relógio.
  Future<void> _skip() async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.skipNumberTitle),
        content: Text(l10n.skipNumberMessage(skipPenalty)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.skip),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    ref.read(scoreProvider.notifier).penalize(skipPenalty);

    _loadNewNumber();
  }

  // Modo Aleatório: coloca um novo número na sopa (ao pular ou ao acertar).
  void _loadNewNumber() {
    // Sorteia outro número, diferente do atual.
    final old = ref.read(digitsProvider);
    var digits = randomDigits();
    while (digits == old) {
      digits = randomDigits();
    }
    ref.read(digitsProvider.notifier).set(digits);

    // A sopa volta a ter só os algarismos novos (os símbolos usados somem,
    // junto com os pontos deles) e o relógio recomeça do início.
    setState(() {
      _items
        ..clear()
        ..addAll(digits.split(''));
      _secondsLeft = _gameSeconds;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _showTutorial() {
    showTutorialDialog(context, onShowExample: _fillExample);
  }

  // Monta o exemplo da explicação na sopa: 2 × 3 = 3 + 3.
  void _fillExample() {
    setState(() {
      _items
        ..clear()
        ..addAll(['2', '*', '3', '=', '3', '+', '3']);
    });
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
      // O jogo não acaba: perde pontos e o relógio recomeça.
      ref.read(scoreProvider.notifier).penalize(timeoutPenalty);
      setState(() => _secondsLeft = _gameSeconds);
      final l10n = AppLocalizations.of(context)!;
      _showMessage(l10n.timeoutMessage(timeoutPenalty));
    }
  }

  // Mostra o resultado. Depois de fechar, no modo Aleatório (continueRandom)
  // vem outro número; nos demais casos, volta para a escolha do modo.
  Future<void> _showEndDialog(
    String title,
    String message, {
    bool continueRandom = false,
  }) async {
    final l10n = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(continueRandom ? l10n.nextNumber : l10n.ok),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (continueRandom) {
      _loadNewNumber();
    } else {
      context.go('/modes');
    }
  }

  // ------------------------------------------------- mover os macarrões

  // Quantos símbolos (tudo que não é algarismo) já estão na sopa.
  int get _usedCount => _items.where((t) => !_isDigitToken(t)).length;

  // Soltou um macarrão no ponto de inserção "index" (antes do item de mesmo índice).
  void _place(int index, Piece piece) {
    // Veio do prato: aumenta a quantidade usada, então confere o limite.
    if (piece.fromIndex == null && _usedCount >= maxOperators) {
      final l10n = AppLocalizations.of(context)!;
      _showMessage(l10n.operatorLimitMessage(maxOperators));
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
    final l10n = AppLocalizations.of(context)!;

    try {
      final correct = checkEquation(
        _items,
        allowFractions: allowsFractions(_level),
        allowPower: allowsPower(_level),
      );
      if (correct) {
        _timer?.cancel();
        if (_tutorial) {
          // O tutorial não dá pontos.
          _showEndDialog(
            l10n.wellDone,
            l10n.correctEquality,
          );
          return;
        }
        // Os pontos dos símbolos usados passam a fazer parte do score.
        final earned = soupPoints(_items);
        ref.read(scoreProvider.notifier).add(earned);
        _showEndDialog(
          l10n.correctTitle,
          l10n.correctScoreMessage(earned),
          // O modo Aleatório não acaba: depois de acertar, vem outro número.
          continueRandom: _isRandomMode,
        );
      } else {
        _showMessage(l10n.differentSides);
      }
    } on GameException catch (e) {
      _showMessage(_errorText(e.error, l10n));
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
    final l10n = AppLocalizations.of(context)!;

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
          Text(l10n.noodlePlate(_usedCount, maxOperators)),
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
    final l10n = AppLocalizations.of(context)!;
    final digits = ref.watch(digitsProvider);

    // Se abriu esta tela sem escolher os algarismos (ex.: recarregou a página).
    if (digits.length != 4) {
      return Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/modes'),
            child: Text(l10n.backToStart),
          ),
        ),
      );
    }

    // Score mostrado = pontos já garantidos + pontos dos símbolos na sopa agora.
    final score = ref.watch(scoreProvider) + soupPoints(_items);

    return Scaffold(
      appBar: AppBar(
        // No tutorial não há tempo nem pontos. Nos outros modos, o FittedBox
        // encolhe tempo e score juntos se a tela for estreita.
        title: _tutorial
            ? Text(l10n.educational)
            : FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.timeRemaining(_secondsLeft),
                      style: TextStyle(color: _secondsLeft <= 10 ? Colors.red : null),
                    ),
                    const SizedBox(width: 24),
                    Text(l10n.score(score)),
                  ],
                ),
              ),
        actions: [
          // No tutorial, dá para abrir a explicação de novo.
          if (_tutorial)
            IconButton(
              tooltip: l10n.explanation,
              icon: const Icon(Icons.info_outline),
              onPressed: _showTutorial,
            ),
          IconButton(
            tooltip: l10n.clear,
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
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: _check,
                        icon: const Icon(Icons.play_arrow),
                        label: Text(l10n.verify),
                      ),
                      // Pular só existe no modo Aleatório.
                      if (_isRandomMode)
                        OutlinedButton.icon(
                          onPressed: _skip,
                          icon: const Icon(Icons.skip_next),
                          label: Text(l10n.skipWithPenalty(skipPenalty)),
                        ),
                    ],
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
