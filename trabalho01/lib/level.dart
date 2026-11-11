// Níveis do jogo e quais símbolos (macarrões) cada nível oferece.

enum Level { easy, medium, advanced, hard }

// Símbolos básicos, presentes em todos os níveis.
const _basic = ['+', '-', '*', '/', '(', ')'];

// Símbolos de cada nível, conforme a especificação do trabalho.
// '**' é a exponencial, '|' é o módulo (usado duas vezes: abre e fecha),
// ⌊ ⌋ é a base (floor) e ⌈ ⌉ é o teto (ceil).
// Quanto mais difícil o nível, MAIS símbolos liberados.
const Map<Level, List<String>> levelSymbols = {
  Level.easy: [..._basic, '|'],
  Level.medium: [..._basic, '√', '!', '|'],
  Level.advanced: [..._basic, '√', '∛', '!', '**', '|'],
  Level.hard: [..._basic, '√', '∛', '!', '**', '|', '⌊', '⌋', '⌈', '⌉'],
};

// Só o nível com TODOS os símbolos aceita divisão com resultado não inteiro
// (na especificação essa regra é do nível que tem mais símbolos).
bool allowsFractions(Level level) => level == Level.hard;

// Quantos símbolos (operadores, parênteses e o '=') cabem na sopa ao mesmo tempo.
const int maxOperators = 9;

// Macarrões do prato. Cada um pode ser usado quantas vezes quiser
// (o limite é maxOperators na sopa). O '=' vem sempre primeiro.
List<String> buildTray(Level level) => ['=', ...levelSymbols[level]!];

// Como cada símbolo aparece na tela (o código interno usa '*' e '/').
const _labels = {'*': '×', '/': '÷', '**': '^'};

String symbolLabel(String symbol) => _labels[symbol] ?? symbol;