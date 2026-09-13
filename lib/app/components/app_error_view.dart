import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:btc_app/app/localization/locale_keys.g.dart';
import 'package:btc_app/core/extensions/build_context_extensions.dart';

class AppErrorView extends StatelessWidget {
  final String messageKey;
  final String? message;
  final VoidCallback onRetry;

  const AppErrorView({
    super.key,
    required this.messageKey,
    this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final backendMessage = message?.trim();
    final displayMessage = backendMessage?.isNotEmpty == true
        ? backendMessage!
        : context.tr(messageKey);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined, color: context.colors.textSecondary),
            const SizedBox(height: 16),
            Text(
              displayMessage,
              textAlign: TextAlign.center,
              style: context.bodyLarge,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onRetry,
              child: Text(context.tr(LocaleKeys.common_retry)),
            ),
          ],
        ),
      ),
    );
  }
}
