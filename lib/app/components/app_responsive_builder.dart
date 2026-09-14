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
    if (context.layoutSize == AppLayoutSize.mobile) {
      return mobile(context);
    }

    if (context.layoutSize == AppLayoutSize.tablet) {
      return (tablet ?? mobile)(context);
    }

    return (desktop ?? tablet ?? mobile)(context);
  }
}
