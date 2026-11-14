// Níveis do jogo e quais símbolos (macarrões) cada nível oferece.

enum Level { easy, medium, advanced, hard }

// Símbolos básicos, presentes em todos os níveis.
const _basic = ['+', '-', '*', '/', '(', ')'];

// Símbolos de cada nível, conforme a especificação do trabalho.
// '|' é o módulo (usado duas vezes: abre e fecha),
// ⌊ ⌋ é a base (floor) e ⌈ ⌉ é o teto (ceil).
// A potência não tem macarrão próprio: ela é feita com dois '*' seguidos
// (veja allowsPower).
const Map<Level, List<String>> levelSymbols = {
  Level.easy: [..._basic, '√', '∛', '!', '|', '⌊', '⌋', '⌈', '⌉'],
  Level.medium: [..._basic, '√', '∛', '!', '|'],
  Level.advanced: [..._basic, '√', '!', '|'],
  Level.hard: [..._basic, '|'],
};

// Só o nível Fácil aceita divisão com resultado não inteiro.
bool allowsFractions(Level level) => level == Level.easy;

// Potência (dois '*' seguidos): só nos níveis Fácil e Intermediário,
// que são os que têm a exponencial na especificação.
bool allowsPower(Level level) => level == Level.easy || level == Level.medium;

// Quantos símbolos (operadores, parênteses e o '=') cabem na sopa ao mesmo tempo.
const int maxOperators = 9;

// Macarrões do prato. Cada um pode ser usado quantas vezes quiser
// (o limite é maxOperators na sopa). O '=' vem sempre primeiro.
List<String> buildTray(Level level) => ['=', ...levelSymbols[level]!];

// Como cada símbolo aparece na tela (o código interno usa '*' e '/').
const _labels = {'*': '×', '/': '÷'};

String symbolLabel(String symbol) => _labels[symbol] ?? symbol;