import 'dart:ui';

import 'package:flutter/animation.dart';

class Constants {
  static const double defaultStrokeWidth = 4;
  static const Color defaultStrokeColor = Color(0xff000000);

  static const Color defaultBorderColor = Color(0x997c90c1);
  static const double minStrokeSize = 1;
  static const double maxStrokeSize = 30;

  static const Curve defaultAnimationCurve = Cubic(0.48, 1.11, 0.67, 1.18);
  static const Duration defaultAnimationDuration = Duration(milliseconds: 200);

  static const double menuIconInitialXAlignment = 0.9;
  static const double menuIconInitialYAlignment = 0.95;

  static const double strokeWidthIconVisibleAlignment = 0.55;
  static const double strokeColorIconVisibleAlignment = 0.75;

  static const double strokeUndoIconVisibleAlignment = 0.35;
  static const double strokeCleanIconVisibleAlignment = 0.15;

  static const double strokeSliderVisibleAlignment = -0.9;
  static const double strokeSliderHiddenAlignment = -1.2;
}
