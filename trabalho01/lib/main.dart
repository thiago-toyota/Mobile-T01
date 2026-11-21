
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'persistence.dart';
import 'router.dart';
import 'state.dart';
import 'l10n/app_localizations.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Necessário porque vamos usar o SharedPreferences antes do runApp.
  WidgetsFlutterBinding.ensureInitialized();

    // Inicializa o Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Na web, o Firebase demora um instante para lembrar quem estava logado.
  // Esperamos esse primeiro aviso antes de abrir o app; senão o roteador
  // acharia que ninguém está logado e mandaria para o login por engano
  // (e o app não reabriria na última página).
  await FirebaseAuth.instance.authStateChanges().first;

  final prefs = await SharedPreferences.getInstance();

  // O "container" guarda o estado do Riverpod. Criamos ele aqui para
  // restaurar o que estava guardado antes de o aplicativo aparecer.
  final container = ProviderContainer(
    overrides: [prefsProvider.overrideWithValue(prefs)],
  );
  setUpPersistence(container, prefs);

  // O aplicativo abre na última página em que estava (ou no login).
  final router = buildRouter(initialLocation: savedLocation(prefs));

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: SoupApp(router: router),
    ),
  );
}

class SoupApp extends ConsumerWidget {
  const SoupApp({super.key, required this.router});

  final GoRouter router;

  // Cria um tema a partir das configurações selecionadas.
  ThemeData _buildTheme(AppSettings settings, Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: settings.seedColor,
      brightness: brightness,
    );

    final baseTheme = ThemeData.from(
      colorScheme: colorScheme,
      useMaterial3: true,
    );

    final textTheme = GoogleFonts.getTextTheme(
      settings.font.label,
      baseTheme.textTheme,
    );

    final primaryTextTheme = GoogleFonts.getTextTheme(
      settings.font.label,
      baseTheme.primaryTextTheme,
    );

    TextTheme scaleTextTheme(TextTheme theme) {
      return theme.copyWith(
        displayLarge: theme.displayLarge?.copyWith(
          fontSize: (theme.displayLarge?.fontSize ?? 57) * settings.fontScale,
        ),
        displayMedium: theme.displayMedium?.copyWith(
          fontSize: (theme.displayMedium?.fontSize ?? 45) * settings.fontScale,
        ),
        displaySmall: theme.displaySmall?.copyWith(
          fontSize: (theme.displaySmall?.fontSize ?? 36) * settings.fontScale,
        ),
        headlineLarge: theme.headlineLarge?.copyWith(
          fontSize: (theme.headlineLarge?.fontSize ?? 32) * settings.fontScale,
        ),
        headlineMedium: theme.headlineMedium?.copyWith(
          fontSize: (theme.headlineMedium?.fontSize ?? 28) * settings.fontScale,
        ),
        headlineSmall: theme.headlineSmall?.copyWith(
          fontSize: (theme.headlineSmall?.fontSize ?? 24) * settings.fontScale,
        ),
        titleLarge: theme.titleLarge?.copyWith(
          fontSize: (theme.titleLarge?.fontSize ?? 22) * settings.fontScale,
        ),
        titleMedium: theme.titleMedium?.copyWith(
          fontSize: (theme.titleMedium?.fontSize ?? 16) * settings.fontScale,
        ),
        titleSmall: theme.titleSmall?.copyWith(
          fontSize: (theme.titleSmall?.fontSize ?? 14) * settings.fontScale,
        ),
        bodyLarge: theme.bodyLarge?.copyWith(
          fontSize: (theme.bodyLarge?.fontSize ?? 16) * settings.fontScale,
        ),
        bodyMedium: theme.bodyMedium?.copyWith(
          fontSize: (theme.bodyMedium?.fontSize ?? 14) * settings.fontScale,
        ),
        bodySmall: theme.bodySmall?.copyWith(
          fontSize: (theme.bodySmall?.fontSize ?? 12) * settings.fontScale,
        ),
        labelLarge: theme.labelLarge?.copyWith(
          fontSize: (theme.labelLarge?.fontSize ?? 14) * settings.fontScale,
        ),
        labelMedium: theme.labelMedium?.copyWith(
          fontSize: (theme.labelMedium?.fontSize ?? 12) * settings.fontScale,
        ),
        labelSmall: theme.labelSmall?.copyWith(
          fontSize: (theme.labelSmall?.fontSize ?? 11) * settings.fontScale,
        ),
      );
    }

    return baseTheme.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      textTheme: scaleTextTheme(textTheme),
      primaryTextTheme: scaleTextTheme(primaryTextTheme),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp.router(
      locale: settings.locale,
      localizationsDelegates: [
        ...AppLocalizations.localizationsDelegates,
        // Traduz os textos da tela de login do Firebase UI.
        FirebaseUILocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      routerConfig: router,

      theme: _buildTheme(settings, Brightness.light),
      darkTheme: _buildTheme(settings, Brightness.dark),

      // Segue o dispositivo, ou utiliza a preferência escolhida.
      themeMode: settings.themeMode,
    );
  }
}
