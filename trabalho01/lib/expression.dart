// Avalia a igualdade montada pelo jogador e também gera o LaTeX dela.
//
// A expressão chega como uma lista de "tokens" (textos), por exemplo:
//   ['(', '5', '-', '2', ')', '!', '=', '6', '*', '1']
//
// Ordem de precedência (do mais fraco ao mais forte):
//   + -   <   * /   <   menos unário   <   **   <   !   <   números, ( ), | |, ⌊⌋, ⌈⌉, √, ∛

import 'dart:math';

// Tipos de erro. Cada tela decide o texto (assim dá para traduzir depois).
enum GameError {
  noEquals,
  manyEquals,
  emptySide,
  missingOperator,
  badSyntax,
  divisionByZero,
  nonIntegerDivision,
  notInteger,
  badFactorial,
  undefined,
}

class GameException implements Exception {
  const GameException(this.error);
  final GameError error;
}

// Resultado de avaliar um pedaço da expressão: valor + LaTeX.
class Evaluated {
  const Evaluated(this.value, this.latex);
  final double value;
  final String latex;
}

bool _isDigit(String t) =>
    t.length == 1 && t.codeUnitAt(0) >= 48 && t.codeUnitAt(0) <= 57;

// Avalia UM lado da igualdade (esquerdo ou direito).
class ExpressionParser {
  ExpressionParser(this.tokens, {required this.allowFractions});

  final List<String> tokens;
  final bool allowFractions;
  int _pos = 0;

  String? get _next => _pos < tokens.length ? tokens[_pos] : null;

  String _take() => tokens[_pos++];

  Evaluated parse() {
    final result = _sum();
    if (_pos < tokens.length) {
      // Sobrou alguma coisa: quase sempre é falta de operador (ex.: 1 0).
      final t = tokens[_pos];
      const startsValue = {'(', '√', '∛', '⌊', '⌈'};
      if (_isDigit(t) || startsValue.contains(t)) {
        throw const GameException(GameError.missingOperator);
      }
      throw const GameException(GameError.badSyntax);
    }
    return result;
  }

  void _expect(String closing) {
    final t = _next;
    if (t == closing) {
      _pos++;
      return;
    }
    if (t != null && _isDigit(t)) {
      throw const GameException(GameError.missingOperator);
    }
    throw const GameException(GameError.badSyntax);
  }

  // Confere se o valor é válido para o nível.
  Evaluated _make(double value, String latex) {
    if (value.isNaN || value.isInfinite || value.abs() > 1e15) {
      throw const GameException(GameError.undefined);
    }
    if (!allowFractions && value != value.roundToDouble()) {
      throw const GameException(GameError.notInteger);
    }
    return Evaluated(value, latex);
  }

  // soma e subtração
  Evaluated _sum() {
    var left = _product();
    while (_next == '+' || _next == '-') {
      final op = _take();
      final right = _product();
      final value = op == '+' ? left.value + right.value : left.value - right.value;
      left = _make(value, '${left.latex} $op ${right.latex}');
    }
    return left;
  }

  // multiplicação e divisão
  Evaluated _product() {
    var left = _unary();
    while (_next == '*' || _next == '/') {
      final op = _take();
      final right = _unary();
      if (op == '*') {
        left = _make(left.value * right.value, '${left.latex} \\cdot ${right.latex}');
      } else {
        if (right.value == 0) throw const GameException(GameError.divisionByZero);
        if (!allowFractions && left.value % right.value != 0) {
          throw const GameException(GameError.nonIntegerDivision);
        }
        left = _make(left.value / right.value, '\\frac{${left.latex}}{${right.latex}}');
      }
    }
    return left;
  }

  // menos unário: -(2 - 5)
  Evaluated _unary() {
    if (_next == '-') {
      _take();
      final inner = _unary();
      return _make(-inner.value, '-${inner.latex}');
    }
    return _power();
  }

  // exponencial (associa pela direita: 2**3**2 = 2**(3**2))
  Evaluated _power() {
    final base = _postfix();
    if (_next == '**') {
      _take();
      final exponent = _unary();
      final value = pow(base.value, exponent.value).toDouble();
      return _make(value, '{${base.latex}}^{${exponent.latex}}');
    }
    return base;
  }

  // fatorial
  Evaluated _postfix() {
    var current = _primary();
    while (_next == '!') {
      _take();
      current = _factorial(current);
    }
    return current;
  }

  Evaluated _factorial(Evaluated e) {
    final n = e.value;
    if (n < 0 || n != n.roundToDouble()) {
      throw const GameException(GameError.badFactorial);
    }
    if (n > 20) throw const GameException(GameError.undefined);
    var result = 1.0;
    for (var i = 2; i <= n; i++) {
      result *= i;
    }
    return _make(result, '${e.latex}!');
  }

  // números, parênteses, módulo, base, teto, raízes
  Evaluated _primary() {
    final t = _next;
    if (t == null) throw const GameException(GameError.badSyntax);

    if (_isDigit(t)) {
      _take();
      return Evaluated(double.parse(t), t);
    }

    switch (t) {
      case '(':
        _take();
        final inner = _sum();
        _expect(')');
        return Evaluated(inner.value, '\\left(${inner.latex}\\right)');

      case '|':
        _take();
        final inner = _sum();
        _expect('|');
        return _make(inner.value.abs(), '\\left|${inner.latex}\\right|');

      case '⌊':
        _take();
        final inner = _sum();
        _expect('⌋');
        return _make(inner.value.floorToDouble(), '\\lfloor ${inner.latex} \\rfloor');

      case '⌈':
        _take();
        final inner = _sum();
        _expect('⌉');
        return _make(inner.value.ceilToDouble(), '\\lceil ${inner.latex} \\rceil');

      case '√':
        _take();
        final arg = _primary();
        if (arg.value < 0) throw const GameException(GameError.undefined);
        return _make(sqrt(arg.value), '\\sqrt{${arg.latex}}');

      case '∛':
        _take();
        final arg = _primary();
        return _make(_cubeRoot(arg.value), '\\sqrt[3]{${arg.latex}}');

      default:
        throw const GameException(GameError.badSyntax);
    }
  }

  // Raiz cúbica (aceita negativos). Corrige o erro de arredondamento do pow.
  double _cubeRoot(double x) {
    var r = pow(x.abs(), 1 / 3).toDouble();
    final rounded = r.roundToDouble();
    if ((rounded * rounded * rounded - x.abs()).abs() < 1e-9) r = rounded;
    return x < 0 ? -r : r;
  }
}

// Dois '*' seguidos viram uma potência: [2, *, *, 3] vira [2, **, 3].
// (Só é usado nos níveis que permitem potência.)
List<String> mergePowers(List<String> tokens) {
  final merged = <String>[];
  var i = 0;
  while (i < tokens.length) {
    if (tokens[i] == '*' && i + 1 < tokens.length && tokens[i + 1] == '*') {
      merged.add('**');
      i += 2; // consumiu os dois asteriscos
    } else {
      merged.add(tokens[i]);
      i++;
    }
  }
  return merged;
}

// Confere a igualdade inteira. Retorna true se os dois lados são iguais,
// false se são diferentes, e lança GameException se a expressão é inválida.
// allowPower: se o nível aceita potência (e então '* *' vale como '**').
bool checkEquation(
  List<String> input, {
  required bool allowFractions,
  required bool allowPower,
}) {
  final tokens = allowPower ? mergePowers(input) : input;
  final equalsCount = tokens.where((t) => t == '=').length;
  if (equalsCount == 0) throw const GameException(GameError.noEquals);
  if (equalsCount > 1) throw const GameException(GameError.manyEquals);

  final at = tokens.indexOf('=');
  final left = tokens.sublist(0, at);
  final right = tokens.sublist(at + 1);
  if (left.isEmpty || right.isEmpty) {
    throw const GameException(GameError.emptySide);
  }

  final l = ExpressionParser(left, allowFractions: allowFractions).parse();
  final r = ExpressionParser(right, allowFractions: allowFractions).parse();
  return (l.value - r.value).abs() < 1e-9;
}

// ---------------------------------------------------------------------------
// LaTeX para mostrar embaixo da sopa, mesmo com a expressão incompleta.
// Se a expressão for válida, usa o LaTeX bonito do parser (\sqrt{...}, \frac...).
// Se não for, mostra os símbolos soltos, do jeito que estão.
// ---------------------------------------------------------------------------

String previewLatex(List<String> input, {required bool allowPower}) {
  final tokens = allowPower ? mergePowers(input) : input;
  final at = tokens.indexOf('=');
  final sides = at == -1
      ? [tokens]
      : [tokens.sublist(0, at), tokens.sublist(at + 1)];
  return sides.map(_sideLatex).join(' = ');
}

String _sideLatex(List<String> side) {
  if (side.isEmpty) return '\\square';
  try {
    return ExpressionParser(side, allowFractions: true).parse().latex;
  } on GameException {
    return side.map(_rawLatex).join(' ');
  }
}

const _rawLatexMap = {
  '*': '\\cdot',
  '/': '\\div',
  '**': '\\ast\\ast',
  '√': '\\surd',
  '∛': '\\sqrt[3]{\\ }',
  '⌊': '\\lfloor',
  '⌋': '\\rfloor',
  '⌈': '\\lceil',
  '⌉': '\\rceil',
};

String _rawLatex(String token) => _rawLatexMap[token] ?? token;