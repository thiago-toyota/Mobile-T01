import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'l10n/app_localizations.dart';

// Janela de explicação do modo Educativo.
// "onShowExample" é chamado quando o jogador pede para ver o exemplo
// montado na sopa.
Future<void> showTutorialDialog(
  BuildContext context, {
  required VoidCallback onShowExample,
}) {
  final l10n = AppLocalizations.of(context)!;

  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.tutorialWelcome),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.tutorialObjective),
            const SizedBox(height: 12),
            Text(l10n.example),
            const SizedBox(height: 4),
            Center(
              child: Math.tex(
                r'2 \cdot 3 = 3 + 3',
                textStyle: Theme.of(dialogContext).textTheme.headlineSmall,
              ),
            ),
            Text(l10n.tutorialEqualityCorrect),
            const SizedBox(height: 12),
            Text(l10n.tutorialStep1),
            const SizedBox(height: 6),
            Text(l10n.tutorialStep2),
            const SizedBox(height: 6),
            Text(l10n.tutorialStep3),
            const SizedBox(height: 6),
            Text(l10n.tutorialStep4),
            const SizedBox(height: 6),
            Text(l10n.tutorialStep5),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(dialogContext).pop();
            onShowExample();
          },
          child: Text(l10n.showExampleInSoup),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(l10n.understood),
        ),
      ],
    ),
  );
}
