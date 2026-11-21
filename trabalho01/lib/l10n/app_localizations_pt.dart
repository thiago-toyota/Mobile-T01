// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get loadingSoup => 'Preparando a sopa...';

  @override
  String get loadError => 'Não foi possível carregar seus números resolvidos.';

  @override
  String get tryAgain => 'Tentar de novo';

  @override
  String get alreadySolvedTitle => 'Você já resolveu este número';

  @override
  String alreadySolvedMessage(String digits) {
    return 'Você já resolveu o número $digits. Quer resolver de novo?';
  }

  @override
  String get solveAgain => 'Resolver de novo';

  @override
  String get chooseAnother => 'Escolher outro';

  @override
  String get language => 'Idioma';

  @override
  String get logout => 'Sair da Conta';

  @override
  String get systemLanguage => 'Idioma do sistema';

  @override
  String get music => 'Música';

  @override
  String get backgroundMusic => 'Música de fundo';

  @override
  String get tutorialWelcome => 'Bem-vindo ao tutorial';

  @override
  String get tutorialObjective =>
      'Objetivo: usar os 4 algarismos, sempre na ordem em que aparecem, para montar uma igualdade. Aqui os algarismos são 2 3 3 3.';

  @override
  String get example => 'Exemplo:';

  @override
  String get tutorialEqualityCorrect =>
      'Os dois lados dão 6, então a igualdade está correta.';

  @override
  String get tutorialStep1 =>
      '• Arraste os macarrões do prato para os espaços entre os algarismos.';

  @override
  String get tutorialStep2 => '• Coloque o = e os operadores: 2 ? 3 ? 3 ? 3.';

  @override
  String get tutorialStep3 =>
      '• Para tirar um macarrão da sopa, arraste-o para fora.';

  @override
  String get tutorialStep4 =>
      '• Quando achar que está certo, toque em Verificar.';

  @override
  String get tutorialStep5 =>
      '• Aqui não há tempo nem pontos: fique à vontade para experimentar.';

  @override
  String get showExampleInSoup => 'Ver o exemplo na sopa';

  @override
  String get understood => 'Entendi';

  @override
  String get chickenBroth => 'Caldo de galinha';

  @override
  String get blue => 'Azul';

  @override
  String get green => 'Verde';

  @override
  String get red => 'Vermelho';

  @override
  String get purple => 'Roxo';

  @override
  String get orange => 'Laranja';

  @override
  String get turquoise => 'Turquesa';

  @override
  String get brown => 'Marrom';

  @override
  String get blueGrey => 'Azul acinzentado';

  @override
  String get pink => 'Rosa';

  @override
  String get chooseMode => 'Escolha o modo';

  @override
  String get educational => 'Educativo';

  @override
  String get tutorialStepByStep => 'Tutorial com um exemplo passo a passo';

  @override
  String get specific => 'Específico';

  @override
  String get chooseFourDigits => 'Você escolhe os 4 algarismos';

  @override
  String get random => 'Aleatório';

  @override
  String get gameChoosesFourDigits => 'O jogo sorteia os 4 algarismos';

  @override
  String get close => 'Fechar';

  @override
  String get settings => 'Configurações';

  @override
  String get appearance => 'Aparência';

  @override
  String get appTheme => 'Tema do aplicativo';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Escuro';

  @override
  String get typography => 'Tipografia';

  @override
  String get fontSize => 'Tamanho da fonte';

  @override
  String get small => 'Pequeno';

  @override
  String get medium => 'Médio';

  @override
  String get large => 'Grande';

  @override
  String get fontFamily => 'Família tipográfica';

  @override
  String get font => 'Fonte';

  @override
  String get preview => 'Pré-visualização';

  @override
  String get previewTitle => 'A sopa de contas está pronta!';

  @override
  String get previewDescription =>
      'Esta é uma demonstração da tipografia selecionada.';

  @override
  String get appColors => 'Cores do aplicativo';

  @override
  String get chooseSeedColor => 'Escolha uma cor semente';

  @override
  String get seedColorDescription =>
      'A cor selecionada será utilizada para gerar a paleta do aplicativo.';

  @override
  String selectedColor(Object color) {
    return 'Cor selecionada: $color';
  }

  @override
  String get custom => 'Personalizada';

  @override
  String get disableMusic => 'Desativar música';

  @override
  String get enableMusic => 'Ativar música';

  @override
  String get restoreDefaultSettings => 'Restaurar configurações padrão';

  @override
  String get appTitle => 'Sopa de Contas';

  @override
  String get levelPageTitle => 'Escolha o nível';

  @override
  String get levelEasy => 'Fácil';

  @override
  String get levelMedium => 'Intermediário';

  @override
  String get levelAdvanced => 'Avançado';

  @override
  String get levelHard => 'Difícil';

  @override
  String get helpTitle => 'Como jogar';

  @override
  String get helpObjective =>
      'Objetivo: montar uma igualdade usando os 4 algarismos na ordem em que aparecem. Exemplo: 3 × 2 = 3 + 3.';

  @override
  String get helpRule1 =>
      '• Arraste os macarrões do prato para a sopa, antes, depois ou entre os algarismos.';

  @override
  String get helpRule2 =>
      '• Para tirar um macarrão, arraste-o para fora da sopa.';

  @override
  String get helpRule3 =>
      '• Você pode usar até 9 símbolos ao todo, incluindo parênteses e o sinal de =.';

  @override
  String get helpRule4 =>
      '• Dois algarismos lado a lado não formam um número maior: é preciso um operador entre eles.';

  @override
  String get helpRule5 =>
      '• Nos níveis Fácil e Intermediário, dois × seguidos (× ×) valem uma potência.';

  @override
  String get helpRule6 =>
      '• Fora do nível Fácil, divisões e resultados não inteiros não são permitidos.';

  @override
  String get helpTimeAndPoints => 'Tempo e pontos';

  @override
  String get helpTimeRule1 =>
      '• Você tem 30 segundos. Toque em Verificar para testar.';

  @override
  String get helpTimeRule2 =>
      '• Se o tempo acabar, você perde 10 pontos e o relógio reinicia.';

  @override
  String get helpTimeRule3 =>
      '• Cada símbolo na sopa vale pontos: + − × ÷ base e teto valem 10; potência (× ×), raízes valem 20; ! e módulo valem 30. Parênteses não valem nada.';

  @override
  String get helpUnderstood => 'Entendi';

  @override
  String get digitsPageTitle => 'Escolha os 4 algarismos';

  @override
  String get digitsPageStart => 'Começar';

  @override
  String get errorNoEquals => 'Falta o sinal de =';

  @override
  String get errorManyEquals => 'Use só um sinal de =';

  @override
  String get errorEmptySide => 'Os dois lados do = precisam ter algo';

  @override
  String get errorMissingOperator => 'Falta um operador entre dois números';

  @override
  String get errorBadSyntax =>
      'Expressão inválida (confira operadores e parênteses)';

  @override
  String get errorDivisionByZero => 'Divisão por zero';

  @override
  String get errorNonIntegerDivision =>
      'Divisão não inteira não é permitida neste nível';

  @override
  String get errorNotInteger =>
      'Resultado não inteiro não é permitido neste nível';

  @override
  String get errorBadFactorial =>
      'Fatorial só vale para inteiros não negativos';

  @override
  String get errorUndefined => 'Esta conta não tem resultado válido';

  @override
  String get skipNumberTitle => 'Pular este número?';

  @override
  String skipNumberMessage(int points) {
    return 'Você perde $points pontos e recebe outro número.';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get skip => 'Pular';

  @override
  String timeoutMessage(int points) {
    return 'Tempo esgotado: -$points pontos';
  }

  @override
  String get nextNumber => 'Próximo número';

  @override
  String get ok => 'OK';

  @override
  String get wellDone => 'Muito bem!';

  @override
  String get correctEquality => 'Você montou uma igualdade correta.';

  @override
  String get correctTitle => 'Acertou!';

  @override
  String correctScoreMessage(int points) {
    return 'A igualdade está correta. +$points pontos';
  }

  @override
  String operatorLimitMessage(int maxOperators) {
    return 'Limite de $maxOperators operadores na sopa';
  }

  @override
  String get differentSides => 'Os dois lados são diferentes';

  @override
  String noodlePlate(int usedCount, int maxOperators) {
    return 'Prato de macarrões: arraste para a sopa ($usedCount/$maxOperators)';
  }

  @override
  String get backToStart => 'Voltar ao início';

  @override
  String timeRemaining(int seconds) {
    return 'Tempo: $seconds';
  }

  @override
  String score(int points) {
    return 'Score: $points';
  }

  @override
  String get explanation => 'Explicação';

  @override
  String get clear => 'Limpar';

  @override
  String get verify => 'Verificar';

  @override
  String skipWithPenalty(int points) {
    return 'Pular (-$points pontos)';
  }
}
