// lib/screens/error/error_screen_404.dart

import 'package:flutter/material.dart';
import 'package:infusions/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ErrorScreen404 extends StatelessWidget {
  final String? error;
  final String? details;

  const ErrorScreen404({super.key, this.error, this.details});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 80,
                color: colors.error,
              ),
              const SizedBox(height: 24),

              Text(
                l10n.error404,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              Text(
                error ?? l10n.error404,
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              if (details != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 600),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.error404details,
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        details!,
                        style: textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),

              FilledButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.home_rounded),
                label: Text(l10n.buttonBackToHome),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}