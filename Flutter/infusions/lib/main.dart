// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:infusions/l10n/app_localizations.dart';
import 'dart:ui';
import 'package:flutter_web_plugins/url_strategy.dart';


import 'package:infusions/nav/nav.dart';
import 'package:infusions/miscellaneous/theme/theme.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();

  static MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  Locale currentLocale = const Locale('en');

  @override
  void initState() {
    super.initState();
    
    // 1. Initial Load: Check system default first
    final systemLocale = PlatformDispatcher.instance.locale;
    if(systemLocale.languageCode == 'es'){
      currentLocale = const Locale('es');
    }
    
  }



  void changeThemeMode(ThemeMode newThemeMode) {
    setState(() {
      _themeMode = newThemeMode;
    });
  }

  void changesLocale(Locale newLocale) {
    setState(() {
      currentLocale = newLocale;
    });
  }

  @override
 Widget build(BuildContext context) {
      return ThemeProvider(
        themeMode: _themeMode,
        changeThemeMode: changeThemeMode,
        child: MaterialApp.router(
          routerConfig: goRouter,
          // Use onGenerateTitle instead of title
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle, 
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: _themeMode,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('es'),
          ],
          locale: currentLocale,
        ),
      );
    }
}

class ThemeProvider extends InheritedWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) changeThemeMode;

  const ThemeProvider({
    super.key,
    required this.themeMode,
    required this.changeThemeMode,
    required super.child,
  });

  static ThemeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return oldWidget.themeMode != themeMode;
  }
}