// Pontuação do jogo.
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pontos que cada símbolo vale quando está na sopa.
// Símbolos que não aparecem aqui (algarismos, parênteses, '=' e os símbolos
// que fecham base e teto) valem 0.
//
// Dois '*' seguidos (potência) valem 10 + 10 = 20, como pedido.
// Base/teto e módulo são pares: o par todo vale o combinado.
//   base ⌊ ⌋ e teto ⌈ ⌉ : só o símbolo que abre vale (10)
//   módulo | |          : os dois símbolos são iguais, então 15 cada (par = 30)
const Map<String, int> symbolPoints = {
  '+': 10,
  '-': 10,
  '*': 10,
  '/': 10,
  '⌊': 10,
  '⌈': 10,
  '√': 20,
  '∛': 20,
  '!': 30,
  '|': 15,
};

// Pontos de tudo o que está na sopa agora.
// É calculado a partir do que está na sopa (e não somado a cada peça solta),
// então colocar e tirar a mesma peça várias vezes não dá pontos de graça.
int soupPoints(List<String> tokens) =>
    tokens.fold(0, (sum, token) => sum + (symbolPoints[token] ?? 0));

// Pontos perdidos quando o tempo acaba.
const int timeoutPenalty = 10;

// Pontuação já garantida do jogador (soma dos números que ele resolveu,
// menos as penalidades de tempo). Os pontos da sopa em andamento são somados
// a isto só na hora de mostrar, e entram aqui quando o jogador acerta.
// As penalidades descem direto daqui, então aparecem no score na hora.
class ScoreNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void add(int points) => state += points;

  // Perde pontos. A pontuação pode ficar negativa.
  // (Para impedir isso, troque por: state = max(0, state - points)
  // e coloque "import 'dart:math';" no topo do arquivo.)
  void penalize(int points) => state -= points;
}

final scoreProvider = NotifierProvider<ScoreNotifier, int>(ScoreNotifier.new);