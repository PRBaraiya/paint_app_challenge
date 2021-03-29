import 'dart:ui';

import 'package:flutter/rendering.dart';

import 'stroke.dart';

class CanvasPainter extends CustomPainter {
  final List<Stroke> strokes;

  CanvasPainter({this.strokes = const []});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeJoin = StrokeJoin.round;

    for (Stroke stroke in strokes) {
      if (stroke.points.length < 1) continue;

      // TODO: Add Code to Paint On Canvas.
      paint.strokeWidth = stroke.width;
      paint.color = stroke.color;
      paint.strokeCap = StrokeCap.round;

      if (stroke.points.length == 1) {
        canvas.drawPoints(PointMode.points, stroke.points, paint);
        continue;
      }

      Path path = Path();
      path.moveTo(stroke.points[0].dx, stroke.points[0].dy);
      for (int i = 1; i < stroke.points.length; i++) {
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
