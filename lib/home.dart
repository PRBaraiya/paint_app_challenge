import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:paint_app_challenge/constants.dart';
import 'package:paint_app_challenge/stroke.dart';

import 'canvas_painter.dart';
import 'custom_slider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _menuExpanded = false;
  bool _changingStrokes = false;

  _FABAllignmentNotifier _widthIconAlignmentNotifier =
      _FABAllignmentNotifier(Constants.menuIconInitialYAlignment);

  _FABAllignmentNotifier _colorIconAlignmentNotifier =
      _FABAllignmentNotifier(Constants.menuIconInitialYAlignment);

  _FABAllignmentNotifier _strokeRangeAlignmentNotifier =
      _FABAllignmentNotifier(Constants.strokeSliderHiddenAlignment);

  _PaintingStrokeProvider _paintDataProvider = _PaintingStrokeProvider();

  double _strokeWidthIconXAlignment = Constants.menuIconInitialXAlignment;

  double _strokeColorIconXAlignment = Constants.menuIconInitialXAlignment;

  double _menuIconXAlignment = Constants.menuIconInitialXAlignment;
  double _menuIconYAlignment = Constants.menuIconInitialYAlignment;

  int _currentStrokeWidth = Constants.defaultStrokeWidth.toInt();
  Color _currentStrokeColor = Constants.defaultStrokeColor;

  void _showStrokeChanger() {
    _strokeRangeAlignmentNotifier
        .update(Constants.strokeSliderVisibleAlignment);
    this._changingStrokes = true;
  }

  void _hideStrokeChanger() {
    _strokeRangeAlignmentNotifier.update(Constants.strokeSliderHiddenAlignment);
    this._changingStrokes = false;
  }

  void _toggleStrokeChanger() {
    if (this._changingStrokes) {
      _hideStrokeChanger();
    } else {
      _hideMenu();
      _showStrokeChanger();
    }
  }

  void _showMenu() {
    if (this._changingStrokes) _hideStrokeChanger();
    _colorIconAlignmentNotifier
        .update(Constants.strokeColorIconVisibleAlignment);
    _widthIconAlignmentNotifier
        .update(Constants.strokeWidthIconVisibleAlignment);
    this._menuExpanded = true;
  }

  void _hideMenu() {
    _colorIconAlignmentNotifier.update(Constants.menuIconInitialYAlignment);
    _widthIconAlignmentNotifier.update(Constants.menuIconInitialYAlignment);
    this._menuExpanded = false;
  }

  void _toogleMenu() {
    if (this._menuExpanded)
      _hideMenu();
    else
      _showMenu();
  }

  void _changeStrokeColor(Color color) => this._currentStrokeColor = color;

  void _changeStrokeWidth(int value) => _currentStrokeWidth = value;

  void _displayColor() async {
    await showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (_) => Dialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(
            color: Constants.defaultBorderColor,
            width: 2,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Stroke Color",
                style: TextStyle(
                  color: Constants.defaultBorderColor.withOpacity(1),
                  fontSize: 25.0,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                height: 1.0,
                color: Constants.defaultBorderColor,
              ),
              ColorPicker(
                displayThumbColor: true,
                enableAlpha: true,
                showLabel: true,
                paletteType: PaletteType.hsv,
                pickerColor: this._currentStrokeColor,
                onColorChanged: _changeStrokeColor,
              )
            ],
          ),
        ),
      ),
    );
  }

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
                  print("Pointer Down.");
                  if (this._changingStrokes)
                    _hideStrokeChanger();
                  else if (this._menuExpanded)
                    _hideMenu();
                  else {
                     // Initialize new Stroke Instance and add it to [_paintDataProvider]
                  }
                },
                onPointerUp: (details) {
                 // Add Null to Stroke.
                  print("Pointer Up.");
                },
                onPointerMove: (details) {
                  // Update Stroke points
                  print("Pointer Move.");
                },
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ValueListenableBuilder(
                    valueListenable: _paintDataProvider,
                    builder: (_, value, __) {
                      return CustomPaint(
                        painter: CanvasPainter(),
                      );
                    },
                  ),
                ),
              ),
              Stack(
                children: [
                  ValueListenableBuilder<double>(
                    valueListenable: _widthIconAlignmentNotifier,
                    builder: (_, value, __) => AnimatedAlign(
                      alignment: Alignment(_strokeWidthIconXAlignment, value),
                      duration: Constants.defaultAnimationDuration,
                      curve: this._menuExpanded
                          ? Constants.defaultAnimationCurve
                          : Curves.linear,
                      child: FloatingActionButton(
                        elevation: this._menuExpanded ? 6 : 0,
                        onPressed: _toggleStrokeChanger,
                        child: Icon(
                          Icons.line_weight_rounded,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder<double>(
                    valueListenable: _colorIconAlignmentNotifier,
                    builder: (_, value, __) => AnimatedAlign(
                      alignment: Alignment(_strokeColorIconXAlignment, value),
                      duration: Constants.defaultAnimationDuration,
                      curve: this._menuExpanded
                          ? Constants.defaultAnimationCurve
                          : Curves.linear,
                      child: FloatingActionButton(
                        elevation: this._menuExpanded ? 6 : 0,
                        onPressed: _displayColor,
                        child: Icon(
                          Icons.color_lens,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: _widthIconAlignmentNotifier,
                    builder: (_, __, ___) => AnimatedAlign(
                      duration: Constants.defaultAnimationDuration,
                      curve: Constants.defaultAnimationCurve,
                      alignment:
                          Alignment(_menuIconXAlignment, _menuIconYAlignment),
                      child: FloatingActionButton(
                        onPressed: _toogleMenu,
                        child: Icon(
                          this._menuExpanded
                              ? Icons.keyboard_arrow_down_rounded
                              : Icons.keyboard_arrow_up_rounded,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ValueListenableBuilder<double>(
                valueListenable: _strokeRangeAlignmentNotifier,
                builder: (_, value, __) => AnimatedAlign(
                  duration: Constants.defaultAnimationDuration,
                  alignment: Alignment(0.0, value),
                  curve: Constants.defaultAnimationCurve,
                  child: CustomSlider(
                    maxValue: Constants.maxStrokeSize,
                    minValue: Constants.minStrokeSize,
                    defaultValue: Constants.defaultStrokeWidth,
                    onStrokeChange: _changeStrokeWidth,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FABAllignmentNotifier extends ValueNotifier<double> {
  _FABAllignmentNotifier(double value) : super(value);

  void update(double newValue) {
    if (newValue != this.value) {
      this.value = newValue;
      notifyListeners();
    }
  }
}

class _PaintingStrokeProvider extends ValueNotifier<List<Stroke>> {
  _PaintingStrokeProvider() : super([]);

  void add(Stroke stroke) {
    value.add(stroke);
    notifyListeners();
  }

  void undo() {
    value.removeLast();
    notifyListeners();
  }

  void reset() {
    value.clear();
    notifyListeners();
  }
}
