import 'package:flutter/widgets.dart';

import 'package:btc_app/core/extensions/build_context_extensions.dart';
import 'package:btc_app/core/responsive/app_breakpoints.dart';

class AppResponsiveBuilder extends StatelessWidget {
  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;

  const AppResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return switch (context.layoutSize) {
      AppLayoutSize.mobile => mobile(context),
      AppLayoutSize.tablet => (tablet ?? mobile)(context),
      AppLayoutSize.desktop => (desktop ?? tablet ?? mobile)(context),
    };
  }
}
