import 'package:flutter/material.dart';
import 'package:paint_app_challenge/canvas_painter.dart';

class PaintCanvas extends StatefulWidget {
  @override
  _PaintCanvasState createState() => _PaintCanvasState();
}

class _PaintCanvasState extends State<PaintCanvas> {
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (details) {},
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: CustomPaint(
          painter: CanvasPainter(),
        ),
      ),
    );
  }
}
