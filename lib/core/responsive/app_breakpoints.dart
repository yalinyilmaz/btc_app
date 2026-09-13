enum AppLayoutSize { mobile, tablet, desktop }

abstract final class AppBreakpoints {
  static const tablet = 600.0;
  static const desktop = 1024.0;
  static const maxContentWidth = 1200.0;

  static AppLayoutSize fromWidth(double width) {
    if (width < tablet) {
      return AppLayoutSize.mobile;
    }
    if (width < desktop) {
      return AppLayoutSize.tablet;
    }
    return AppLayoutSize.desktop;
  }
}
