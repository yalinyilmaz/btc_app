import 'package:flutter/material.dart';

import 'package:btc_app/core/extensions/build_context_extensions.dart';
import 'package:btc_app/core/responsive/app_breakpoints.dart';

class AppPageBody extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const AppPageBody({
    super.key,
    required this.child,
    this.maxWidth = AppBreakpoints.maxContentWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.pageHorizontalPadding,
            ),
            child: SizedBox.expand(child: child),
          ),
        ),
      ),
    );
  }
}
