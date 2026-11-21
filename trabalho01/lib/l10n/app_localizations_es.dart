// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get loadingSoup => 'Preparando la sopa...';

  @override
  String get loadError => 'No se pudieron cargar tus números resueltos.';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get alreadySolvedTitle => 'Ya resolviste este número';

  @override
  String alreadySolvedMessage(String digits) {
    return 'Ya resolviste el número $digits. ¿Quieres resolverlo de nuevo?';
  }

  @override
  String get solveAgain => 'Resolver de nuevo';

  @override
  String get chooseAnother => 'Elegir otro';

  @override
  String get language => 'Idioma';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get systemLanguage => 'Idioma del sistema';

  @override
  String get music => 'Música';

  @override
  String get backgroundMusic => 'Música de fondo';

  @override
  String get tutorialWelcome => 'Bienvenido al tutorial';

  @override
  String get tutorialObjective =>
      'Objetivo: usar los 4 dígitos, siempre en el orden en que aparecen, para construir una igualdad. Aquí los dígitos son 2 3 3 3.';

  @override
  String get example => 'Ejemplo:';

  @override
  String get tutorialEqualityCorrect =>
      'Ambos lados dan 6, por lo que la igualdad es correcta.';

  @override
  String get tutorialStep1 =>
      '• Arrastra los fideos del plato a los espacios entre los dígitos.';

  @override
  String get tutorialStep2 => '• Coloca el = y los operadores: 2 ? 3 ? 3 ? 3.';

  @override
  String get tutorialStep3 =>
      '• Para quitar un fideo de la sopa, arrástralo hacia afuera.';

  @override
  String get tutorialStep4 =>
      '• Cuando creas que está correcto, toca Verificar.';

  @override
  String get tutorialStep5 =>
      '• Aquí no hay tiempo ni puntos: siéntete libre de experimentar.';

  @override
  String get showExampleInSoup => 'Ver el ejemplo en la sopa';

  @override
  String get understood => 'Entendido';

  @override
  String get chickenBroth => 'Caldo de pollo';

  @override
  String get blue => 'Azul';

  @override
  String get green => 'Verde';

  @override
  String get red => 'Rojo';

  @override
  String get purple => 'Morado';

  @override
  String get orange => 'Naranja';

  @override
  String get turquoise => 'Turquesa';

  @override
  String get brown => 'Marrón';

  @override
  String get blueGrey => 'Azul grisáceo';

  @override
  String get pink => 'Rosa';

  @override
  String get chooseMode => 'Elige el modo';

  @override
  String get educational => 'Educativo';

  @override
  String get tutorialStepByStep => 'Tutorial con un ejemplo paso a paso';

  @override
  String get specific => 'Específico';

  @override
  String get chooseFourDigits => 'Tú eliges los 4 dígitos';

  @override
  String get random => 'Aleatorio';

  @override
  String get gameChoosesFourDigits => 'El juego sortea los 4 dígitos';

  @override
  String get close => 'Cerrar';

  @override
  String get settings => 'Configuración';

  @override
  String get appearance => 'Apariencia';

  @override
  String get appTheme => 'Tema de la aplicación';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get typography => 'Tipografía';

  @override
  String get fontSize => 'Tamaño de fuente';

  @override
  String get small => 'Pequeño';

  @override
  String get medium => 'Mediano';

  @override
  String get large => 'Grande';

  @override
  String get fontFamily => 'Familia tipográfica';

  @override
  String get font => 'Fuente';

  @override
  String get preview => 'Vista previa';

  @override
  String get previewTitle => '¡La sopa de cuentas está lista!';

  @override
  String get previewDescription =>
      'Esta es una demostración de la tipografía seleccionada.';

  @override
  String get appColors => 'Colores de la aplicación';

  @override
  String get chooseSeedColor => 'Elige un color semilla';

  @override
  String get seedColorDescription =>
      'El color seleccionado se utilizará para generar la paleta de la aplicación.';

  @override
  String selectedColor(Object color) {
    return 'Color seleccionado: $color';
  }

  @override
  String get custom => 'Personalizada';

  @override
  String get disableMusic => 'Desactivar música';

  @override
  String get enableMusic => 'Activar música';

  @override
  String get restoreDefaultSettings => 'Restaurar configuración predeterminada';

  @override
  String get appTitle => 'Sopa de Cuentas';

  @override
  String get levelPageTitle => 'Elige el nivel';

  @override
  String get levelEasy => 'Fácil';

  @override
  String get levelMedium => 'Intermedio';

  @override
  String get levelAdvanced => 'Avanzado';

  @override
  String get levelHard => 'Difícil';

  @override
  String get helpTitle => 'Cómo jugar';

  @override
  String get helpObjective =>
      'Objetivo: crear una igualdad utilizando los 4 dígitos en el orden en que aparecen. Ejemplo: 3 × 2 = 3 + 3.';

  @override
  String get helpRule1 =>
      '• Arrastra los fideos del plato a la sopa, antes, después o entre los dígitos.';

  @override
  String get helpRule2 =>
      '• Para quitar un fideo, arrástralo fuera de la sopa.';

  @override
  String get helpRule3 =>
      '• Puedes utilizar hasta 9 símbolos en total, incluidos los paréntesis y el signo =.';

  @override
  String get helpRule4 =>
      '• Dos dígitos uno al lado del otro no forman un número mayor: debe haber un operador entre ellos.';

  @override
  String get helpRule5 =>
      '• En los niveles Fácil e Intermedio, dos símbolos × consecutivos (× ×) representan una potencia.';

  @override
  String get helpRule6 =>
      '• Fuera del nivel Fácil, no se permiten divisiones ni resultados no enteros.';

  @override
  String get helpTimeAndPoints => 'Tiempo y puntos';

  @override
  String get helpTimeRule1 =>
      '• Tienes 30 segundos. Pulsa Comprobar para verificar tu igualdad.';

  @override
  String get helpTimeRule2 =>
      '• Si se acaba el tiempo, pierdes 10 puntos y el temporizador se reinicia.';

  @override
  String get helpTimeRule3 =>
      '• Cada símbolo en la sopa otorga puntos: + − × ÷ suelo y techo valen 10; las potencias (× ×) y las raíces valen 20; ! y el valor absoluto valen 30. Los paréntesis no valen nada.';

  @override
  String get helpUnderstood => 'Entendido';

  @override
  String get digitsPageTitle => 'Elige los 4 dígitos';

  @override
  String get digitsPageStart => 'Comenzar';

  @override
  String get errorNoEquals => 'Falta el signo de =';

  @override
  String get errorManyEquals => 'Usa solo un signo de =';

  @override
  String get errorEmptySide => 'Ambos lados del = deben contener algo';

  @override
  String get errorMissingOperator => 'Falta un operador entre dos números';

  @override
  String get errorBadSyntax =>
      'Expresión inválida (comprueba los operadores y los paréntesis)';

  @override
  String get errorDivisionByZero => 'División por cero';

  @override
  String get errorNonIntegerDivision =>
      'La división no entera no está permitida en este nivel';

  @override
  String get errorNotInteger =>
      'El resultado no entero no está permitido en este nivel';

  @override
  String get errorBadFactorial =>
      'El factorial solo es válido para enteros no negativos';

  @override
  String get errorUndefined => 'Este cálculo no tiene un resultado válido';

  @override
  String get skipNumberTitle => '¿Saltar este número?';

  @override
  String skipNumberMessage(int points) {
    return 'Perderás $points puntos y recibirás otro número.';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get skip => 'Saltar';

  @override
  String timeoutMessage(int points) {
    return 'Tiempo agotado: -$points puntos';
  }

  @override
  String get nextNumber => 'Siguiente número';

  @override
  String get ok => 'OK';

  @override
  String get wellDone => '¡Muy bien!';

  @override
  String get correctEquality => 'Has creado una igualdad correcta.';

  @override
  String get correctTitle => '¡Correcto!';

  @override
  String correctScoreMessage(int points) {
    return 'La igualdad es correcta. +$points puntos';
  }

  @override
  String operatorLimitMessage(int maxOperators) {
    return 'Límite de $maxOperators operadores en la sopa';
  }

  @override
  String get differentSides => 'Los dos lados son diferentes';

  @override
  String noodlePlate(int usedCount, int maxOperators) {
    return 'Plato de fideos: arrastra a la sopa ($usedCount/$maxOperators)';
  }

  @override
  String get backToStart => 'Volver al inicio';

  @override
  String timeRemaining(int seconds) {
    return 'Tiempo: $seconds';
  }

  @override
  String score(int points) {
    return 'Puntuación: $points';
  }

  @override
  String get explanation => 'Explicación';

  @override
  String get clear => 'Limpiar';

  @override
  String get verify => 'Comprobar';

  @override
  String skipWithPenalty(int points) {
    return 'Saltar (-$points puntos)';
  }
}
