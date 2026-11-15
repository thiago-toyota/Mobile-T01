// Testes da lógica do jogo (sem interface): avaliador de expressões,
// LaTeX, regras dos níveis e pontuação.
// Para rodar: flutter test
import 'package:flutter_test/flutter_test.dart';
import 'package:trabalho01/expression.dart';
import 'package:trabalho01/level.dart';
import 'package:trabalho01/score.dart';

// Escreve a expressão com símbolos separados por espaço: t('1 + 1 = 2').
List<String> t(String text) => text.split(' ');

bool check(String text, {bool fractions = false, bool power = false}) {
  return checkEquation(t(text), allowFractions: fractions, allowPower: power);
}

// Espera que a expressão seja inválida com um erro específico.
Matcher throwsGame(GameError error) => throwsA(
      isA<GameException>().having((e) => e.error, 'error', error),
    );

void main() {
  group('igualdades corretas', () {
    test('soma e multiplicação', () {
      expect(check('2 * 3 = 3 + 3'), isTrue);
    });

    test('lados diferentes dão falso, sem erro', () {
      expect(check('2 + 3 = 3 + 3'), isFalse);
    });

    test('fatorial vem depois do número', () {
      expect(check('( 5 - 2 ) ! = 6 * 1'), isTrue);
      expect(check('1 + 1 - 0 = 2 !'), isTrue);
    });

    test('base (piso) e teto', () {
      expect(check('1 = 1 + 1 - ⌊ 1 ⌋'), isTrue);
      expect(check('⌈ 1 ⌉ = 1'), isTrue);
    });

    test('módulo', () {
      expect(check('| 2 - 5 | = 3'), isTrue);
    });

    test('raiz quadrada', () {
      expect(check('√ 9 = 3'), isTrue);
    });

    test('menos unário', () {
      expect(check('- ( 2 - 5 ) = 3'), isTrue);
    });
  });

  group('potência (dois * seguidos)', () {
    test('vale quando o nível permite', () {
      expect(check('2 * * 3 = 8', power: true), isTrue);
    });

    test('é erro quando o nível não permite', () {
      expect(
        () => check('2 * * 3 = 8', power: false),
        throwsGame(GameError.badSyntax),
      );
    });
  });

  group('divisão', () {
    test('não inteira é aceita só quando permitido', () {
      expect(check('5 / 2 = 5 / 2', fractions: true), isTrue);
      expect(
        () => check('5 / 2 = 5 / 2', fractions: false),
        throwsGame(GameError.nonIntegerDivision),
      );
    });

    test('por zero é erro', () {
      expect(
        () => check('1 / 0 = 1'),
        throwsGame(GameError.divisionByZero),
      );
    });
  });

  group('erros de expressão', () {
    test('dois algarismos sem operador', () {
      expect(() => check('1 0 = 1 0'), throwsGame(GameError.missingOperator));
    });

    test('! antes do número', () {
      expect(() => check('1 + 1 - 0 = ! 2'), throwsGame(GameError.badSyntax));
    });

    test('falta o =', () {
      expect(() => check('1 + 1'), throwsGame(GameError.noEquals));
    });

    test('mais de um =', () {
      expect(() => check('1 = 1 = 1'), throwsGame(GameError.manyEquals));
    });

    test('um dos lados vazio', () {
      expect(() => check('= 1'), throwsGame(GameError.emptySide));
    });
  });

  group('LaTeX', () {
    test('potência', () {
      expect(
        previewLatex(t('2 * * 3 = 8'), allowPower: true),
        '{2}^{3} = 8',
      );
    });

    test('raiz quadrada', () {
      expect(
        previewLatex(t('√ 9 = 3'), allowPower: false),
        r'\sqrt{9} = 3',
      );
    });
  });

  group('níveis', () {
    test('divisão não inteira só no Fácil', () {
      expect(allowsFractions(Level.easy), isTrue);
      expect(allowsFractions(Level.medium), isFalse);
      expect(allowsFractions(Level.advanced), isFalse);
      expect(allowsFractions(Level.hard), isFalse);
    });

    test('potência só no Fácil e no Intermediário', () {
      expect(allowsPower(Level.easy), isTrue);
      expect(allowsPower(Level.medium), isTrue);
      expect(allowsPower(Level.advanced), isFalse);
      expect(allowsPower(Level.hard), isFalse);
    });

    test('só o Fácil tem base e teto', () {
      for (final symbol in ['⌊', '⌋', '⌈', '⌉']) {
        expect(levelSymbols[Level.easy], contains(symbol));
        expect(levelSymbols[Level.medium], isNot(contains(symbol)));
      }
    });

    test('o prato começa com = e não tem macarrão de potência', () {
      final tray = buildTray(Level.hard);
      expect(tray.first, '=');
      expect(tray, isNot(contains('**')));
    });
  });

  group('pontuação', () {
    test('operadores básicos valem 10', () {
      expect(soupPoints(t('2 * 3 = 3 + 3')), 20);
    });

    test('dois * seguidos (potência) valem 20', () {
      expect(soupPoints(t('* *')), 20);
    });

    test('fatorial vale 30 e módulo vale 30 o par', () {
      expect(soupPoints(t('!')), 30);
      expect(soupPoints(t('| 1 |')), 30);
    });

    test('parênteses, = e símbolos que fecham não valem nada', () {
      expect(soupPoints(t('( ) =')), 0);
      expect(soupPoints(t('⌊ 1 ⌋')), 10);
    });
  });
}