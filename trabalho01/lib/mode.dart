import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Os três modos de jogo.
//   educational: tutorial com os algarismos 2 3 3 3 e um exemplo.
//   specific:    o jogador escolhe a dificuldade e digita os 4 algarismos.
//   random:      o jogador escolhe a dificuldade e o jogo sorteia os algarismos.
enum GameMode { educational, specific, random }

class ModeNotifier extends Notifier<GameMode> {
  @override
  GameMode build() => GameMode.specific;

  void select(GameMode mode) => state = mode;
}

final modeProvider = NotifierProvider<ModeNotifier, GameMode>(ModeNotifier.new);

final _random = Random();

// Sorteia 4 algarismos, cada um de 0 a 9 (ex.: '4071').
String randomDigits() => List.generate(4, (_) => _random.nextInt(10)).join();
