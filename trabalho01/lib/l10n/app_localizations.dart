import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @language.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @systemLanguage.
  ///
  /// In pt, this message translates to:
  /// **'Idioma do sistema'**
  String get systemLanguage;

  /// No description provided for @music.
  ///
  /// In pt, this message translates to:
  /// **'Música'**
  String get music;

  /// No description provided for @backgroundMusic.
  ///
  /// In pt, this message translates to:
  /// **'Música de fundo'**
  String get backgroundMusic;

  /// No description provided for @tutorialWelcome.
  ///
  /// In pt, this message translates to:
  /// **'Bem-vindo ao tutorial'**
  String get tutorialWelcome;

  /// No description provided for @tutorialObjective.
  ///
  /// In pt, this message translates to:
  /// **'Objetivo: usar os 4 algarismos, sempre na ordem em que aparecem, para montar uma igualdade. Aqui os algarismos são 2 3 3 3.'**
  String get tutorialObjective;

  /// No description provided for @example.
  ///
  /// In pt, this message translates to:
  /// **'Exemplo:'**
  String get example;

  /// No description provided for @tutorialEqualityCorrect.
  ///
  /// In pt, this message translates to:
  /// **'Os dois lados dão 6, então a igualdade está correta.'**
  String get tutorialEqualityCorrect;

  /// No description provided for @tutorialStep1.
  ///
  /// In pt, this message translates to:
  /// **'• Arraste os macarrões do prato para os espaços entre os algarismos.'**
  String get tutorialStep1;

  /// No description provided for @tutorialStep2.
  ///
  /// In pt, this message translates to:
  /// **'• Coloque o = e os operadores: 2 ? 3 ? 3 ? 3.'**
  String get tutorialStep2;

  /// No description provided for @tutorialStep3.
  ///
  /// In pt, this message translates to:
  /// **'• Para tirar um macarrão da sopa, arraste-o para fora.'**
  String get tutorialStep3;

  /// No description provided for @tutorialStep4.
  ///
  /// In pt, this message translates to:
  /// **'• Quando achar que está certo, toque em Verificar.'**
  String get tutorialStep4;

  /// No description provided for @tutorialStep5.
  ///
  /// In pt, this message translates to:
  /// **'• Aqui não há tempo nem pontos: fique à vontade para experimentar.'**
  String get tutorialStep5;

  /// No description provided for @showExampleInSoup.
  ///
  /// In pt, this message translates to:
  /// **'Ver o exemplo na sopa'**
  String get showExampleInSoup;

  /// No description provided for @understood.
  ///
  /// In pt, this message translates to:
  /// **'Entendi'**
  String get understood;

  /// No description provided for @chickenBroth.
  ///
  /// In pt, this message translates to:
  /// **'Caldo de galinha'**
  String get chickenBroth;

  /// No description provided for @blue.
  ///
  /// In pt, this message translates to:
  /// **'Azul'**
  String get blue;

  /// No description provided for @green.
  ///
  /// In pt, this message translates to:
  /// **'Verde'**
  String get green;

  /// No description provided for @red.
  ///
  /// In pt, this message translates to:
  /// **'Vermelho'**
  String get red;

  /// No description provided for @purple.
  ///
  /// In pt, this message translates to:
  /// **'Roxo'**
  String get purple;

  /// No description provided for @orange.
  ///
  /// In pt, this message translates to:
  /// **'Laranja'**
  String get orange;

  /// No description provided for @turquoise.
  ///
  /// In pt, this message translates to:
  /// **'Turquesa'**
  String get turquoise;

  /// No description provided for @brown.
  ///
  /// In pt, this message translates to:
  /// **'Marrom'**
  String get brown;

  /// No description provided for @blueGrey.
  ///
  /// In pt, this message translates to:
  /// **'Azul acinzentado'**
  String get blueGrey;

  /// No description provided for @pink.
  ///
  /// In pt, this message translates to:
  /// **'Rosa'**
  String get pink;

  /// No description provided for @chooseMode.
  ///
  /// In pt, this message translates to:
  /// **'Escolha o modo'**
  String get chooseMode;

  /// No description provided for @educational.
  ///
  /// In pt, this message translates to:
  /// **'Educativo'**
  String get educational;

  /// No description provided for @tutorialStepByStep.
  ///
  /// In pt, this message translates to:
  /// **'Tutorial com um exemplo passo a passo'**
  String get tutorialStepByStep;

  /// No description provided for @specific.
  ///
  /// In pt, this message translates to:
  /// **'Específico'**
  String get specific;

  /// No description provided for @chooseFourDigits.
  ///
  /// In pt, this message translates to:
  /// **'Você escolhe os 4 algarismos'**
  String get chooseFourDigits;

  /// No description provided for @random.
  ///
  /// In pt, this message translates to:
  /// **'Aleatório'**
  String get random;

  /// No description provided for @gameChoosesFourDigits.
  ///
  /// In pt, this message translates to:
  /// **'O jogo sorteia os 4 algarismos'**
  String get gameChoosesFourDigits;

  /// No description provided for @close.
  ///
  /// In pt, this message translates to:
  /// **'Fechar'**
  String get close;

  /// No description provided for @settings.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In pt, this message translates to:
  /// **'Aparência'**
  String get appearance;

  /// No description provided for @appTheme.
  ///
  /// In pt, this message translates to:
  /// **'Tema do aplicativo'**
  String get appTheme;

  /// No description provided for @system.
  ///
  /// In pt, this message translates to:
  /// **'Sistema'**
  String get system;

  /// No description provided for @light.
  ///
  /// In pt, this message translates to:
  /// **'Claro'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In pt, this message translates to:
  /// **'Escuro'**
  String get dark;

  /// No description provided for @typography.
  ///
  /// In pt, this message translates to:
  /// **'Tipografia'**
  String get typography;

  /// No description provided for @fontSize.
  ///
  /// In pt, this message translates to:
  /// **'Tamanho da fonte'**
  String get fontSize;

  /// No description provided for @small.
  ///
  /// In pt, this message translates to:
  /// **'Pequeno'**
  String get small;

  /// No description provided for @medium.
  ///
  /// In pt, this message translates to:
  /// **'Médio'**
  String get medium;

  /// No description provided for @large.
  ///
  /// In pt, this message translates to:
  /// **'Grande'**
  String get large;

  /// No description provided for @fontFamily.
  ///
  /// In pt, this message translates to:
  /// **'Família tipográfica'**
  String get fontFamily;

  /// No description provided for @font.
  ///
  /// In pt, this message translates to:
  /// **'Fonte'**
  String get font;

  /// No description provided for @preview.
  ///
  /// In pt, this message translates to:
  /// **'Pré-visualização'**
  String get preview;

  /// No description provided for @previewTitle.
  ///
  /// In pt, this message translates to:
  /// **'A sopa de contas está pronta!'**
  String get previewTitle;

  /// No description provided for @previewDescription.
  ///
  /// In pt, this message translates to:
  /// **'Esta é uma demonstração da tipografia selecionada.'**
  String get previewDescription;

  /// No description provided for @appColors.
  ///
  /// In pt, this message translates to:
  /// **'Cores do aplicativo'**
  String get appColors;

  /// No description provided for @chooseSeedColor.
  ///
  /// In pt, this message translates to:
  /// **'Escolha uma cor semente'**
  String get chooseSeedColor;

  /// No description provided for @seedColorDescription.
  ///
  /// In pt, this message translates to:
  /// **'A cor selecionada será utilizada para gerar a paleta do aplicativo.'**
  String get seedColorDescription;

  /// No description provided for @selectedColor.
  ///
  /// In pt, this message translates to:
  /// **'Cor selecionada: {color}'**
  String selectedColor(Object color);

  /// No description provided for @custom.
  ///
  /// In pt, this message translates to:
  /// **'Personalizada'**
  String get custom;

  /// No description provided for @disableMusic.
  ///
  /// In pt, this message translates to:
  /// **'Desativar música'**
  String get disableMusic;

  /// No description provided for @enableMusic.
  ///
  /// In pt, this message translates to:
  /// **'Ativar música'**
  String get enableMusic;

  /// No description provided for @restoreDefaultSettings.
  ///
  /// In pt, this message translates to:
  /// **'Restaurar configurações padrão'**
  String get restoreDefaultSettings;

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sopa de Contas'**
  String get appTitle;

  /// No description provided for @levelPageTitle.
  ///
  /// In pt, this message translates to:
  /// **'Escolha o nível'**
  String get levelPageTitle;

  /// No description provided for @levelEasy.
  ///
  /// In pt, this message translates to:
  /// **'Fácil'**
  String get levelEasy;

  /// No description provided for @levelMedium.
  ///
  /// In pt, this message translates to:
  /// **'Intermediário'**
  String get levelMedium;

  /// No description provided for @levelAdvanced.
  ///
  /// In pt, this message translates to:
  /// **'Avançado'**
  String get levelAdvanced;

  /// No description provided for @levelHard.
  ///
  /// In pt, this message translates to:
  /// **'Difícil'**
  String get levelHard;

  /// No description provided for @helpTitle.
  ///
  /// In pt, this message translates to:
  /// **'Como jogar'**
  String get helpTitle;

  /// No description provided for @helpObjective.
  ///
  /// In pt, this message translates to:
  /// **'Objetivo: montar uma igualdade usando os 4 algarismos na ordem em que aparecem. Exemplo: 3 × 2 = 3 + 3.'**
  String get helpObjective;

  /// No description provided for @helpRule1.
  ///
  /// In pt, this message translates to:
  /// **'• Arraste os macarrões do prato para a sopa, antes, depois ou entre os algarismos.'**
  String get helpRule1;

  /// No description provided for @helpRule2.
  ///
  /// In pt, this message translates to:
  /// **'• Para tirar um macarrão, arraste-o para fora da sopa.'**
  String get helpRule2;

  /// No description provided for @helpRule3.
  ///
  /// In pt, this message translates to:
  /// **'• Você pode usar até 9 símbolos ao todo, incluindo parênteses e o sinal de =.'**
  String get helpRule3;

  /// No description provided for @helpRule4.
  ///
  /// In pt, this message translates to:
  /// **'• Dois algarismos lado a lado não formam um número maior: é preciso um operador entre eles.'**
  String get helpRule4;

  /// No description provided for @helpRule5.
  ///
  /// In pt, this message translates to:
  /// **'• Nos níveis Fácil e Intermediário, dois × seguidos (× ×) valem uma potência.'**
  String get helpRule5;

  /// No description provided for @helpRule6.
  ///
  /// In pt, this message translates to:
  /// **'• Fora do nível Fácil, divisões e resultados não inteiros não são permitidos.'**
  String get helpRule6;

  /// No description provided for @helpTimeAndPoints.
  ///
  /// In pt, this message translates to:
  /// **'Tempo e pontos'**
  String get helpTimeAndPoints;

  /// No description provided for @helpTimeRule1.
  ///
  /// In pt, this message translates to:
  /// **'• Você tem 30 segundos. Toque em Verificar para testar.'**
  String get helpTimeRule1;

  /// No description provided for @helpTimeRule2.
  ///
  /// In pt, this message translates to:
  /// **'• Se o tempo acabar, você perde 10 pontos e o relógio reinicia.'**
  String get helpTimeRule2;

  /// No description provided for @helpTimeRule3.
  ///
  /// In pt, this message translates to:
  /// **'• Cada símbolo na sopa vale pontos: + − × ÷ base e teto valem 10; potência (× ×), raízes valem 20; ! e módulo valem 30. Parênteses não valem nada.'**
  String get helpTimeRule3;

  /// No description provided for @helpUnderstood.
  ///
  /// In pt, this message translates to:
  /// **'Entendi'**
  String get helpUnderstood;

  /// No description provided for @digitsPageTitle.
  ///
  /// In pt, this message translates to:
  /// **'Escolha os 4 algarismos'**
  String get digitsPageTitle;

  /// No description provided for @digitsPageStart.
  ///
  /// In pt, this message translates to:
  /// **'Começar'**
  String get digitsPageStart;

  /// No description provided for @errorNoEquals.
  ///
  /// In pt, this message translates to:
  /// **'Falta o sinal de ='**
  String get errorNoEquals;

  /// No description provided for @errorManyEquals.
  ///
  /// In pt, this message translates to:
  /// **'Use só um sinal de ='**
  String get errorManyEquals;

  /// No description provided for @errorEmptySide.
  ///
  /// In pt, this message translates to:
  /// **'Os dois lados do = precisam ter algo'**
  String get errorEmptySide;

  /// No description provided for @errorMissingOperator.
  ///
  /// In pt, this message translates to:
  /// **'Falta um operador entre dois números'**
  String get errorMissingOperator;

  /// No description provided for @errorBadSyntax.
  ///
  /// In pt, this message translates to:
  /// **'Expressão inválida (confira operadores e parênteses)'**
  String get errorBadSyntax;

  /// No description provided for @errorDivisionByZero.
  ///
  /// In pt, this message translates to:
  /// **'Divisão por zero'**
  String get errorDivisionByZero;

  /// No description provided for @errorNonIntegerDivision.
  ///
  /// In pt, this message translates to:
  /// **'Divisão não inteira não é permitida neste nível'**
  String get errorNonIntegerDivision;

  /// No description provided for @errorNotInteger.
  ///
  /// In pt, this message translates to:
  /// **'Resultado não inteiro não é permitido neste nível'**
  String get errorNotInteger;

  /// No description provided for @errorBadFactorial.
  ///
  /// In pt, this message translates to:
  /// **'Fatorial só vale para inteiros não negativos'**
  String get errorBadFactorial;

  /// No description provided for @errorUndefined.
  ///
  /// In pt, this message translates to:
  /// **'Esta conta não tem resultado válido'**
  String get errorUndefined;

  /// No description provided for @skipNumberTitle.
  ///
  /// In pt, this message translates to:
  /// **'Pular este número?'**
  String get skipNumberTitle;

  /// No description provided for @skipNumberMessage.
  ///
  /// In pt, this message translates to:
  /// **'Você perde {points} pontos e recebe outro número.'**
  String skipNumberMessage(int points);

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @skip.
  ///
  /// In pt, this message translates to:
  /// **'Pular'**
  String get skip;

  /// No description provided for @timeoutMessage.
  ///
  /// In pt, this message translates to:
  /// **'Tempo esgotado: -{points} pontos'**
  String timeoutMessage(int points);

  /// No description provided for @nextNumber.
  ///
  /// In pt, this message translates to:
  /// **'Próximo número'**
  String get nextNumber;

  /// No description provided for @ok.
  ///
  /// In pt, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @wellDone.
  ///
  /// In pt, this message translates to:
  /// **'Muito bem!'**
  String get wellDone;

  /// No description provided for @correctEquality.
  ///
  /// In pt, this message translates to:
  /// **'Você montou uma igualdade correta.'**
  String get correctEquality;

  /// No description provided for @correctTitle.
  ///
  /// In pt, this message translates to:
  /// **'Acertou!'**
  String get correctTitle;

  /// No description provided for @correctScoreMessage.
  ///
  /// In pt, this message translates to:
  /// **'A igualdade está correta. +{points} pontos'**
  String correctScoreMessage(int points);

  /// No description provided for @operatorLimitMessage.
  ///
  /// In pt, this message translates to:
  /// **'Limite de {maxOperators} operadores na sopa'**
  String operatorLimitMessage(int maxOperators);

  /// No description provided for @differentSides.
  ///
  /// In pt, this message translates to:
  /// **'Os dois lados são diferentes'**
  String get differentSides;

  /// No description provided for @noodlePlate.
  ///
  /// In pt, this message translates to:
  /// **'Prato de macarrões: arraste para a sopa ({usedCount}/{maxOperators})'**
  String noodlePlate(int usedCount, int maxOperators);

  /// No description provided for @backToStart.
  ///
  /// In pt, this message translates to:
  /// **'Voltar ao início'**
  String get backToStart;

  /// No description provided for @timeRemaining.
  ///
  /// In pt, this message translates to:
  /// **'Tempo: {seconds}'**
  String timeRemaining(int seconds);

  /// No description provided for @score.
  ///
  /// In pt, this message translates to:
  /// **'Score: {points}'**
  String score(int points);

  /// No description provided for @explanation.
  ///
  /// In pt, this message translates to:
  /// **'Explicação'**
  String get explanation;

  /// No description provided for @clear.
  ///
  /// In pt, this message translates to:
  /// **'Limpar'**
  String get clear;

  /// No description provided for @verify.
  ///
  /// In pt, this message translates to:
  /// **'Verificar'**
  String get verify;

  /// No description provided for @skipWithPenalty.
  ///
  /// In pt, this message translates to:
  /// **'Pular (-{points} pontos)'**
  String skipWithPenalty(int points);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
