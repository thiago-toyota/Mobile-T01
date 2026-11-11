// Estado compartilhado entre as telas (Riverpod).
// Guarda o que o jogador escolheu: o nível e os 4 algarismos.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'level.dart';

class LevelNotifier extends Notifier<Level> {
  @override
  Level build() => Level.easy;

  void select(Level level) => state = level;
}

final levelProvider = NotifierProvider<LevelNotifier, Level>(LevelNotifier.new);

class DigitsNotifier extends Notifier<String> {
  @override
  String build() => '';

  void set(String digits) => state = digits;
}

final digitsProvider = NotifierProvider<DigitsNotifier, String>(DigitsNotifier.new);
