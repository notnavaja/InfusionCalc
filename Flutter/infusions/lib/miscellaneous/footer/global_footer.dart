import 'package:flutter/material.dart';
import 'package:infusions/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:simple_icons/simple_icons.dart';

class GlobalFooter extends StatelessWidget {
  const GlobalFooter({super.key});

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://github.com/notnavaja/InfusionCalc');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor, 
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.appTitle,
            style: TextStyle(color: Colors.white.withAlpha(150)),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: Icon(
              SimpleIcons.github,
              //size: 30,
              color: Colors.white.withAlpha(150), // or use standard GitHub color
            ),
            tooltip: 'GitHub',
            onPressed: _launchUrl,
          ),
        ],
      ),
    );
  }
}