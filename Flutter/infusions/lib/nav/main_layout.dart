// nav/main_layout.dart

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:infusions/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:infusions/main.dart';
import 'package:infusions/miscellaneous/footer/global_footer.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, required this.child});
  final Widget child;

  @override
  MainLayoutState createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isScrolled = false;

  void _updateUserTheme(ThemeMode mode) {
    final themeProvider = ThemeProvider.of(context);
    themeProvider?.changeThemeMode(mode);
  }

  void _updateUserLocale(String languageCode) {
    MyApp.of(context)?.changesLocale(ui.Locale(languageCode));
  }

  void _showThemeDialog(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    showDialog(
      context: context, 
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Center(child: Text(l10n.selectThemeMode)),
        content: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.light_mode),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(l10n.lightTheme),
                    ),
                  ],
                ), onTap: () { Navigator.pop(dialogContext); _updateUserTheme(ThemeMode.light); }
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.dark_mode),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(l10n.darkTheme),
                    ),
                  ],
                ), onTap: () { Navigator.pop(dialogContext); _updateUserTheme(ThemeMode.dark); }
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_mode),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(l10n.systemTheme),
                    ),
                  ],
                ), onTap: () { Navigator.pop(dialogContext); _updateUserTheme(ThemeMode.system); }
              ),
            ),
          ]
        ),
      )
    );
  }
  
  void _showLanguageDialog(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    showDialog(
      context: context, 
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Center(child: Text(l10n.selectLanguage)),
        content: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(title: const Text('🇺🇸 English'), onTap: () { Navigator.pop(dialogContext); _updateUserLocale('en'); }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(title: const Text('🇲🇽 Español'), onTap: () { Navigator.pop(dialogContext); _updateUserLocale('es'); }),
            ),
          ]
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouter.of(context).routeInformationProvider.value.uri.path;
    final bool isDashboard = currentPath == '/';

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1100; 
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    
    final Color textColor = (isDashboard && !_isScrolled) 
        ? colorScheme.onSurface 
        : colorScheme.primary;

    final Color iconColor = colorScheme.onSurface.withValues(alpha: 0.7);

    return Scaffold(
      key: _scaffoldKey, 
      drawerScrimColor: Theme.of(context).brightness == Brightness.light ? Colors.transparent : null, 
      extendBodyBehindAppBar: true,
      backgroundColor: theme.scaffoldBackgroundColor, 
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: _buildGlassAppBar(context, theme, l10n, isMobile, textColor, iconColor),
      ),
      drawer: isMobile ? _buildMobileDrawer(context, theme, l10n) : null,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification && notification.metrics.axis == Axis.vertical) {
            final isScrolled = notification.metrics.pixels > 20;
            if (isScrolled != _isScrolled) setState(() => _isScrolled = isScrolled);
          }
          return false;
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    widget.child, 
                    Container(
                      height: 5, 
                      color: Theme.of(context).inputDecorationTheme.fillColor
                    ),
                    const GlobalFooter(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGlassAppBar(BuildContext context, ThemeData theme, AppLocalizations l10n, bool isMobile, Color textColor, Color iconColor) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: _isScrolled ? 15.0 : 0.0, sigmaY: _isScrolled ? 15.0 : 0.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          alignment: Alignment.center,
          child: SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (isMobile) 
                      IconButton(
                        icon: Icon(Icons.menu, color: textColor), 
                        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                      ),
                    InkWell(
                      onTap: () => context.go('/'),
                      child: Text(
                        l10n.appTitle,
                        style: TextStyle(fontFamily: 'Inter', color: textColor, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5),                      ),
                    ),
                  ],
                ),
                if (!isMobile)
                 
                _buildThemeAndLanguageMenu(context, theme, l10n, textColor, isMobile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeAndLanguageMenu(BuildContext context, ThemeData theme, AppLocalizations l10n, Color textColor, bool isMobile) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            color: textColor.withValues(alpha: 0.1), 
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: textColor.withValues(alpha: 0.2), width: 0.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4.0), 
          child: PopupMenuButton<String>(
            tooltip: l10n.selectLanguageAndTheme,
            color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            offset: const Offset(0, 45),
            icon: Icon(Icons.settings, color: textColor),
            itemBuilder: (context) => [
              PopupMenuItem(child: Text(l10n.selectThemeMode), onTap: () => Future.delayed(Duration.zero, () { if (context.mounted) _showThemeDialog(context, theme, l10n); })),
              PopupMenuItem(child: Text(l10n.selectLanguage), onTap: () => Future.delayed(Duration.zero, () { if (context.mounted) _showLanguageDialog(context, theme, l10n); })),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileDrawer(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Material(
            type: MaterialType.transparency,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1))),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    mainAxisAlignment: MainAxisAlignment.center, 
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.calculate_outlined),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.appTitle, 
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2, 
                              style: TextStyle(
                                color: theme.colorScheme.onSurface, 
                                fontSize: 24, 
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5, 
                              ),
                            ),
                          ),
                        ],
                      )
                    ]
                  ),
                ),
                
                // Added Navigation Routes for Mobile
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: Colors.grey.withAlpha(50),
                    leading: const Icon(Icons.calculate), 
                    title: Text(l10n.calculator), 
                    onTap: () { Navigator.pop(context); context.go('/'); }
                  ),
                ),
            
                // ListTile(
                //   leading: const Icon(Icons.info), 
                //   title: Text(l10n.about_us), 
                //   onTap: () { Navigator.pop(context); context.go('/about-us'); }
                // ),
                
                Divider(color: theme.dividerColor),
                
                // Theme and Language Preferences
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: Colors.grey.withAlpha(50),
                    leading: const Icon(Icons.palette), 
                    title: Text(l10n.selectThemeMode), 
                    onTap: () { Navigator.pop(context); _showThemeDialog(context, theme, l10n); }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: Colors.grey.withAlpha(50),
                    leading: const Icon(Icons.language), 
                    title: Text(l10n.selectLanguage), 
                    onTap: () { Navigator.pop(context); _showLanguageDialog(context, theme, l10n); }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}