import 'package:flutter/material.dart';
import 'package:paint_app_challenge/constants.dart';

import 'canvas_painter.dart';
import 'custom_slider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _menuExpanded = false;

  double _strokeWidthIconXAlignment = Constants.menuIconInitialXAlignment;
  double _strokeWidthIconYAlignment = Constants.menuIconInitialYAlignment;

  double _strokeColorIconXAlignment = Constants.menuIconInitialXAlignment;
  double _strokeColorIconYAlignment = Constants.menuIconInitialYAlignment;

  double _menuIconXAlignment = Constants.menuIconInitialXAlignment;
  double _menuIconYAlignment = Constants.menuIconInitialYAlignment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Listener(
                onPointerDown: (details) {
                  print("Hey There");
                },
                child: Container(
                  height:  MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: CustomPaint(
                    painter: CanvasPainter(),
                  ),
                ),
              ),
              Stack(
                children: [
                  AnimatedAlign(
                alignment: Alignment(
                    _strokeWidthIconXAlignment, _strokeWidthIconYAlignment),
                duration: Constants.defaultAnimationDuration,
                child: FloatingActionButton(
                  elevation: 0,
                  onPressed: () {
                    print("FLoating Action button Pressed.");
                  },
                  child: Icon(Icons.line_weight_rounded),
                ),
              ),
              AnimatedAlign(
                alignment: Alignment(
                    _strokeColorIconXAlignment, _strokeColorIconYAlignment),
                duration: Constants.defaultAnimationDuration,
                child: FloatingActionButton(
                  elevation: 0,
                  onPressed: () {
                    print("FLoating Action button Pressed.");
                  },
                  child: Icon(Icons.color_lens),
                ),
              ),
              AnimatedAlign(
                duration: Constants.defaultAnimationDuration,
                alignment: Alignment(_menuIconXAlignment, _menuIconYAlignment),
                child: FloatingActionButton(
                  onPressed: () {},
                  child: Icon(Icons.add),
                ),
              ),
              AnimatedAlign(
                duration: Constants.defaultAnimationDuration,
                alignment: Alignment(0, -0.9), // Bottom Alignment is 1.2
                curve: Constants.defaultAnimationCurve,
                child: CustomSlider(
                  onStrokeChange: (value) {
                    print("Stroke Width: $value");
                  },
                ),
              ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Buttons

// Stroke
// Color
// Undo
// Reset
