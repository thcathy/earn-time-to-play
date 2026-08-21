import 'package:flutter/widgets.dart';

/// Padding that keeps sheet content clear of the keyboard and system bars.
EdgeInsets edgeToEdgeContentPadding(
  MediaQueryData mediaQuery, {
  double base = 24,
}) {
  final padding = mediaQuery.padding;
  return EdgeInsets.fromLTRB(
    base + padding.left,
    base,
    base + padding.right,
    base + mediaQuery.viewInsets.bottom + padding.bottom,
  );
}
