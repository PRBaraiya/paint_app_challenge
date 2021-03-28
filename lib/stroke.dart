import 'dart:ui';

import 'constants.dart';

class Stroke {
  final List<Offset> points;
  final Color color;
  final double width;

  const Stroke({this.points = const [], this.color = Constants.defaultStrokeColor, this.width = Constants.defaultStrokeWidth,});
}