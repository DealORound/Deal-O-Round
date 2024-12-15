import 'dart:ui';

/// This class is to supplement deprecated_member_use for withOpacity
extension ColorEx on Color {
  /// Returns a new color that matches this color with the alpha channel
  /// replaced with the given `opacity` (which ranges from 0.0 to 1.0).
  ///
  /// Out of range values will have unexpected effects.
  /// Not sure why is it deprecated.
  /// I don't care about precision loss whatsoever.
  Color withOpacityEx(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withAlpha((255.0 * opacity).round());
  }
}
