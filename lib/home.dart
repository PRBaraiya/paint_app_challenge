import 'package:flutter/material.dart';

import 'canvas_painter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            CustomPaint(
              painter: CanvasPainter(),
            ),
          ],
        ),
      ),
    );
  }
}