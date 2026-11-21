import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'level.dart';

// Números que o jogador já resolveu, guardados no Firestore.
//
// Estrutura no banco (cada jogador só enxerga a própria pasta):
//   users / {uid do jogador} / solved / {os 4 algarismos, ex.: "2333"}
//       digits:   "2333"
//       level:    "easy"
//       solvedAt: (data e hora do servidor)
//
// Usar os algarismos como nome do documento evita repetição: resolver o
// mesmo número de novo só atualiza o documento que já existe.
CollectionReference<Map<String, dynamic>> _solvedCollection() {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('solved');
}

// Guarda, na memória, o conjunto de números já resolvidos
// (ex.: {"2333", "0451"}) para o resto do app consultar sem esperar a rede.
class SolvedNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  // Lê tudo do Firestore. Quem chama espera (await) e trata o erro.
  Future<void> load() async {
    final snapshot = await _solvedCollection().get();
    state = {for (final doc in snapshot.docs) doc.id};
  }

  // Marca como resolvido: na memória na hora, e no Firestore em seguida.
  Future<void> markSolved(String digits, Level level) async {
    state = {...state, digits};
    try {
      await _solvedCollection().doc(digits).set({
        'digits': digits,
        'level': level.name,
        'solvedAt': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      // Sem internet ou sem permissão: o jogo continua, só não guardou.
      debugPrint('Não foi possível guardar o número $digits: $error');
    }
  }
}

final solvedProvider = NotifierProvider<SolvedNotifier, Set<String>>(
  SolvedNotifier.new,
);

// Sorteia 4 algarismos que o jogador ainda não resolveu.
// Monta a lista de todos os 10 000 números ("0000" a "9999"), tira os
// resolvidos e sorteia um dos que sobraram.
String pickUnsolvedDigits(Set<String> solved) {
  final unsolved = <String>[];
  for (var n = 0; n < 10000; n++) {
    final digits = n.toString().padLeft(4, '0');
    if (!solved.contains(digits)) unsolved.add(digits);
  }

  final random = Random();
  // Se o jogador resolveu todos (!), volta a sortear qualquer um.
  if (unsolved.isEmpty) return random.nextInt(10000).toString().padLeft(4, '0');
  return unsolved[random.nextInt(unsolved.length)];
}
