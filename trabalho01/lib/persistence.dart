// Guarda o estado do aplicativo no navegador/aparelho (SharedPreferences)
// para que, ao fechar e abrir de novo, ele volte como estava:
//   - a última página
//   - o modo, o nível e os algarismos do jogo
//   - as configurações (tema, fonte, cor)
//
// Na web, o SharedPreferences usa o localStorage do navegador.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'level.dart';
import 'mode.dart';
import 'state.dart';

// O SharedPreferences é aberto no main() e entregue aqui.
final prefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('prefsProvider não foi configurado no main'),
);

// Nomes das chaves guardadas.
const _routeKey = 'lastRoute';
const _modeKey = 'mode';
const _levelKey = 'level';
const _digitsKey = 'digits';
const _themeModeKey = 'themeMode';
const _fontScaleKey = 'fontScale';
const _fontKey = 'font';
const _seedColorKey = 'seedColor';

// Páginas que podem ser reabertas. O login e as janelas ficam de fora.
const _restorablePages = {'/modes', '/levels', '/digits', '/game'};

// Página inicial do aplicativo: a última guardada, ou o login.
String savedLocation(SharedPreferences prefs) {
  final saved = prefs.getString(_routeKey);
  return _restorablePages.contains(saved) ? saved! : '/login';
}

// Procura o valor de um enum pelo nome (ex.: 'dark' -> ThemeMode.dark).
T? _byName<T extends Enum>(List<T> values, String? name) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  return null;
}

// 1) Restaura o que estava guardado.  2) Passa a guardar cada mudança.
void setUpPersistence(ProviderContainer container, SharedPreferences prefs) {
  _restore(container, prefs);
  _watch(container, prefs);
}

void _restore(ProviderContainer container, SharedPreferences prefs) {
  // Jogo
  final mode = _byName(GameMode.values, prefs.getString(_modeKey));
  if (mode != null) container.read(modeProvider.notifier).select(mode);

  final level = _byName(Level.values, prefs.getString(_levelKey));
  if (level != null) container.read(levelProvider.notifier).select(level);

  final digits = prefs.getString(_digitsKey);
  if (digits != null) container.read(digitsProvider.notifier).set(digits);

  // Configurações
  final settings = container.read(settingsProvider.notifier);

  final themeMode = _byName(ThemeMode.values, prefs.getString(_themeModeKey));
  if (themeMode != null) settings.setThemeMode(themeMode);

  final fontScale = prefs.getDouble(_fontScaleKey);
  if (fontScale != null) settings.setFontScale(fontScale);

  final font = _byName(AppFont.values, prefs.getString(_fontKey));
  if (font != null) settings.setFont(font);

  final seed = prefs.getInt(_seedColorKey);
  if (seed != null) settings.setSeedColor(Color(seed));
}

void _watch(ProviderContainer container, SharedPreferences prefs) {
  container.listen<GameMode>(modeProvider, (_, mode) {
    prefs.setString(_modeKey, mode.name);
  });
  container.listen<Level>(levelProvider, (_, level) {
    prefs.setString(_levelKey, level.name);
  });
  container.listen<String>(digitsProvider, (_, digits) {
    prefs.setString(_digitsKey, digits);
  });
  container.listen<AppSettings>(settingsProvider, (_, settings) {
    prefs.setString(_themeModeKey, settings.themeMode.name);
    prefs.setDouble(_fontScaleKey, settings.fontScale);
    prefs.setString(_fontKey, settings.font.name);
    // ignore: deprecated_member_use
    prefs.setInt(_seedColorKey, settings.seedColor.value);
  });
}

// Fica dentro da moldura das páginas e guarda a página atual
// toda vez que ela muda.
class RouteSaver extends ConsumerStatefulWidget {
  const RouteSaver({super.key, required this.location, required this.child});

  final String location; // ex.: '/game'
  final Widget child;

  @override
  ConsumerState<RouteSaver> createState() => _RouteSaverState();
}

class _RouteSaverState extends ConsumerState<RouteSaver> {
  @override
  void initState() {
    super.initState();
    _save();
  }

  @override
  void didUpdateWidget(RouteSaver oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location != widget.location) _save();
  }

  void _save() {
    if (_restorablePages.contains(widget.location)) {
      ref.read(prefsProvider).setString(_routeKey, widget.location);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
