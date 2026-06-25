// lib/miscellaneous/footer/global_footer.dart

import 'package:flutter/material.dart';

import 'package:infusions/l10n/app_localizations.dart';

class GlobalFooter extends StatelessWidget {
  const GlobalFooter({super.key});
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor, 
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      alignment: Alignment.center,
      child:  Text(
        l10n.appTitle,
        style: TextStyle(color: Colors.white.withAlpha(150)),
      ),
    );
  }
}