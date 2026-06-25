import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:infusions/nav/main_layout.dart';

import 'package:infusions/screens/calculator/calculator_screen.dart';
import 'package:infusions/screens/error/error_screen_404.dart';


Page<void> _buildInstantPage(BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: Duration.zero, 
    reverseTransitionDuration: Duration.zero,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child; 
    },
  );
}

final goRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => ErrorScreen404(error: state.error.toString()),
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        // ShellRoute uses builder, internal routes use pageBuilder
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => _buildInstantPage(context, state, const CalculatorScreen()),
        ),
        
      ],
    ),
  ],
);