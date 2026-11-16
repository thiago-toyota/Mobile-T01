// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'Language';

  @override
  String get systemLanguage => 'System language';

  @override
  String get music => 'Music';

  @override
  String get backgroundMusic => 'Background music';

  @override
  String get tutorialWelcome => 'Welcome to the tutorial';

  @override
  String get tutorialObjective =>
      'Objective: use the 4 digits, always in the order they appear, to form an equation. Here the digits are 2 3 3 3.';

  @override
  String get example => 'Example:';

  @override
  String get tutorialEqualityCorrect =>
      'Both sides equal 6, so the equation is correct.';

  @override
  String get tutorialStep1 =>
      '• Drag the noodles from the plate into the spaces between the digits.';

  @override
  String get tutorialStep2 =>
      '• Place the = sign and the operators: 2 ? 3 ? 3 ? 3.';

  @override
  String get tutorialStep3 =>
      '• To remove a noodle from the soup, drag it outside.';

  @override
  String get tutorialStep4 => '• When you think it\'s correct, tap Check.';

  @override
  String get tutorialStep5 =>
      '• There is no timer or scoring here: feel free to experiment.';

  @override
  String get showExampleInSoup => 'See the example in the soup';

  @override
  String get understood => 'Got it';

  @override
  String get chickenBroth => 'Chicken broth';

  @override
  String get blue => 'Blue';

  @override
  String get green => 'Green';

  @override
  String get red => 'Red';

  @override
  String get purple => 'Purple';

  @override
  String get orange => 'Orange';

  @override
  String get turquoise => 'Turquoise';

  @override
  String get brown => 'Brown';

  @override
  String get blueGrey => 'Blue-grey';

  @override
  String get pink => 'Pink';

  @override
  String get chooseMode => 'Choose a mode';

  @override
  String get educational => 'Educational';

  @override
  String get tutorialStepByStep => 'Tutorial with a step-by-step example';

  @override
  String get specific => 'Specific';

  @override
  String get chooseFourDigits => 'You choose the 4 digits';

  @override
  String get random => 'Random';

  @override
  String get gameChoosesFourDigits => 'The game randomly selects the 4 digits';

  @override
  String get close => 'Close';

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get appTheme => 'App theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get typography => 'Typography';

  @override
  String get fontSize => 'Font size';

  @override
  String get small => 'Small';

  @override
  String get medium => 'Medium';

  @override
  String get large => 'Large';

  @override
  String get fontFamily => 'Font family';

  @override
  String get font => 'Font';

  @override
  String get preview => 'Preview';

  @override
  String get previewTitle => 'The number soup is ready!';

  @override
  String get previewDescription =>
      'This is a preview of the selected typography.';

  @override
  String get appColors => 'App colors';

  @override
  String get chooseSeedColor => 'Choose a seed color';

  @override
  String get seedColorDescription =>
      'The selected color will be used to generate the app palette.';

  @override
  String selectedColor(Object color) {
    return 'Selected color: $color';
  }

  @override
  String get custom => 'Custom';

  @override
  String get disableMusic => 'Disable music';

  @override
  String get enableMusic => 'Enable music';

  @override
  String get restoreDefaultSettings => 'Restore default settings';

  @override
  String get appTitle => 'Math Soup';

  @override
  String get levelPageTitle => 'Choose the level';

  @override
  String get levelEasy => 'Easy';

  @override
  String get levelMedium => 'Intermediate';

  @override
  String get levelAdvanced => 'Advanced';

  @override
  String get levelHard => 'Hard';

  @override
  String get helpTitle => 'How to play';

  @override
  String get helpObjective =>
      'Objective: create an equality using the 4 digits in the order they appear. Example: 3 × 2 = 3 + 3.';

  @override
  String get helpRule1 =>
      '• Drag the noodles from the plate into the soup, before, after, or between the digits.';

  @override
  String get helpRule2 => '• To remove a noodle, drag it out of the soup.';

  @override
  String get helpRule3 =>
      '• You can use up to 9 symbols in total, including parentheses and the = sign.';

  @override
  String get helpRule4 =>
      '• Two digits side by side do not form a larger number: an operator must be placed between them.';

  @override
  String get helpRule5 =>
      '• In Easy and Intermediate levels, two consecutive × symbols (× ×) represent an exponentiation.';

  @override
  String get helpRule6 =>
      '• Outside Easy mode, divisions and non-integer results are not allowed.';

  @override
  String get helpTimeAndPoints => 'Time and points';

  @override
  String get helpTimeRule1 =>
      '• You have 30 seconds. Tap Check to test your equation.';

  @override
  String get helpTimeRule2 =>
      '• If time runs out, you lose 10 points and the timer restarts.';

  @override
  String get helpTimeRule3 =>
      '• Each symbol in the soup is worth points: + − × ÷ floor and ceiling are worth 10; exponentiation (× ×) and roots are worth 20; ! and absolute value are worth 30. Parentheses are worth nothing.';

  @override
  String get helpUnderstood => 'Got it';

  @override
  String get digitsPageTitle => 'Choose the 4 digits';

  @override
  String get digitsPageStart => 'Start';

  @override
  String get errorNoEquals => 'Missing the = sign';

  @override
  String get errorManyEquals => 'Use only one = sign';

  @override
  String get errorEmptySide =>
      'Both sides of the = sign must contain something';

  @override
  String get errorMissingOperator => 'Missing an operator between two numbers';

  @override
  String get errorBadSyntax =>
      'Invalid expression (check operators and parentheses)';

  @override
  String get errorDivisionByZero => 'Division by zero';

  @override
  String get errorNonIntegerDivision =>
      'Non-integer division is not allowed at this level';

  @override
  String get errorNotInteger =>
      'Non-integer result is not allowed at this level';

  @override
  String get errorBadFactorial =>
      'Factorial is only valid for non-negative integers';

  @override
  String get errorUndefined => 'This calculation has no valid result';

  @override
  String get skipNumberTitle => 'Skip this number?';

  @override
  String skipNumberMessage(int points) {
    return 'You will lose $points points and receive another number.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get skip => 'Skip';

  @override
  String timeoutMessage(int points) {
    return 'Time\'s up: -$points points';
  }

  @override
  String get nextNumber => 'Next number';

  @override
  String get ok => 'OK';

  @override
  String get wellDone => 'Well done!';

  @override
  String get correctEquality => 'You created a correct equality.';

  @override
  String get correctTitle => 'Correct!';

  @override
  String correctScoreMessage(int points) {
    return 'The equality is correct. +$points points';
  }

  @override
  String operatorLimitMessage(int maxOperators) {
    return 'Maximum of $maxOperators operators in the soup';
  }

  @override
  String get differentSides => 'The two sides are different';

  @override
  String noodlePlate(int usedCount, int maxOperators) {
    return 'Noodle plate: drag into the soup ($usedCount/$maxOperators)';
  }

  @override
  String get backToStart => 'Back to start';

  @override
  String timeRemaining(int seconds) {
    return 'Time: $seconds';
  }

  @override
  String score(int points) {
    return 'Score: $points';
  }

  @override
  String get explanation => 'Explanation';

  @override
  String get clear => 'Clear';

  @override
  String get verify => 'Check';

  @override
  String skipWithPenalty(int points) {
    return 'Skip (-$points points)';
  }
}
