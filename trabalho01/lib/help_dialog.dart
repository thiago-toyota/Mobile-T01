
import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

// Janelinha de ajuda, aberta pelo ícone "?" da barra de navegação.
Future<void> showHelpDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  return showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.helpTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.helpObjective),
            const SizedBox(height: 12),
            Text(l10n.helpRule1),
            const SizedBox(height: 6),
            Text(l10n.helpRule2),
            const SizedBox(height: 6),
            Text(l10n.helpRule3),
            const SizedBox(height: 6),
            Text(l10n.helpRule4),
            const SizedBox(height: 6),
            Text(l10n.helpRule5),
            const SizedBox(height: 6),
            Text(l10n.helpRule6),
            const SizedBox(height: 12),
            Text(
              l10n.helpTimeAndPoints,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(l10n.helpTimeRule1),
            const SizedBox(height: 6),
            Text(l10n.helpTimeRule2),
            const SizedBox(height: 6),
            Text(l10n.helpTimeRule3),
            const SizedBox(height: 6),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(l10n.helpUnderstood),
        ),
      ],
    ),
  );
}
