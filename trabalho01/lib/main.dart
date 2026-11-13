
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'router.dart';
import 'state.dart';

void main() {
  runApp(const ProviderScope(child: SoupApp()));
}

class SoupApp extends ConsumerWidget {
  const SoupApp({super.key});

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
      title: 'Sopa de Contas',
      routerConfig: router,

      theme: _buildTheme(settings, Brightness.light),
      darkTheme: _buildTheme(settings, Brightness.dark),

      // Segue o dispositivo, ou utiliza a preferência escolhida.
      themeMode: settings.themeMode,
    );
  }
}
