import 'package:flutter_test/flutter_test.dart';

import 'package:btc_app/core/responsive/app_breakpoints.dart';

void main() {
  group('AppBreakpoints', () {
    test('maps widths to the expected layout size', () {
      expect(AppBreakpoints.fromWidth(599), AppLayoutSize.mobile);
      expect(AppBreakpoints.fromWidth(600), AppLayoutSize.tablet);
      expect(AppBreakpoints.fromWidth(1023), AppLayoutSize.tablet);
      expect(AppBreakpoints.fromWidth(1024), AppLayoutSize.desktop);
    });
  });
}
