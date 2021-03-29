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

  _FABAlignmentNotifier _widthIconAlignmentNotifier =
      _FABAlignmentNotifier(Constants.menuIconInitialYAlignment);

  _FABAlignmentNotifier _colorIconAlignmentNotifier =
      _FABAlignmentNotifier(Constants.menuIconInitialYAlignment);

  _FABAlignmentNotifier _strokeRangeAlignmentNotifier =
      _FABAlignmentNotifier(Constants.strokeSliderHiddenAlignment);

  _FABAlignmentNotifier _undoStrokeAlignmentNotifier =
      _FABAlignmentNotifier(Constants.menuIconInitialYAlignment);

  _FABAlignmentNotifier _cleanStrokesAlignmentNotifier =
      _FABAlignmentNotifier(Constants.menuIconInitialYAlignment);

  _PaintingStrokeProvider _paintDataProvider = _PaintingStrokeProvider();

  double _strokeWidthIconXAlignment = Constants.menuIconInitialXAlignment;

  double _strokeColorIconXAlignment = Constants.menuIconInitialXAlignment;

  double _menuIconXAlignment = Constants.menuIconInitialXAlignment;
  double _menuIconYAlignment = Constants.menuIconInitialYAlignment;

  Color _currentStrokeColor = Constants.defaultStrokeColor;

  double _currentStrokeWidth = Constants.defaultStrokeWidth;

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
    _undoStrokeAlignmentNotifier
        .update(Constants.strokeUndoIconVisibleAlignment);
    _cleanStrokesAlignmentNotifier
        .update(Constants.strokeCleanIconVisibleAlignment);
    this._menuExpanded = true;
  }

  void _hideMenu() {
    _colorIconAlignmentNotifier.update(Constants.menuIconInitialYAlignment);
    _widthIconAlignmentNotifier.update(Constants.menuIconInitialYAlignment);
    _undoStrokeAlignmentNotifier.update(Constants.menuIconInitialYAlignment);
    _cleanStrokesAlignmentNotifier.update(Constants.menuIconInitialYAlignment);
    this._menuExpanded = false;
  }

  void _toggleMenu() {
    if (this._menuExpanded)
      _hideMenu();
    else
      _showMenu();
  }

  void _changeStrokeColor(Color color) => this._currentStrokeColor = color;

  void _changeStrokeWidth(int value) {
    _currentStrokeWidth = value.toDouble();
  }

  void _displayColor() {
    _hideMenu();

    showDialog(
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
                  if (this._changingStrokes)
                    _hideStrokeChanger();
                  else if (this._menuExpanded)
                    _hideMenu();
                  else {
                    _paintDataProvider.addStroke(
                      Stroke(
                        points: [details.localPosition],
                        color: _currentStrokeColor,
                        width: _currentStrokeWidth,
                      ),
                      details.pointer,
                    );
                  }
                },
                onPointerMove: (details) {
                  _paintDataProvider.addPoint(
                      details.localPosition, details.pointer);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ValueListenableBuilder<Map<int, Stroke>>(
                    valueListenable: _paintDataProvider,
                    builder: (_, value, __) {
                      return CustomPaint(
                        painter: CanvasPainter(
                          strokes: _paintDataProvider.strokes,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Stack(
                children: [
                  ValueListenableBuilder<double>(
                    valueListenable: _cleanStrokesAlignmentNotifier,
                    builder: (_, value, __) => AnimatedAlign(
                      alignment: Alignment(_strokeWidthIconXAlignment, value),
                      duration: Constants.defaultAnimationDuration,
                      curve: this._menuExpanded
                          ? Constants.defaultAnimationCurve
                          : Curves.linear,
                      child: FloatingActionButton(
                        elevation: this._menuExpanded ? 6 : 0,
                        onPressed: _paintDataProvider.reset,
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder<double>(
                    valueListenable: _undoStrokeAlignmentNotifier,
                    builder: (_, value, __) => AnimatedAlign(
                      alignment: Alignment(_strokeWidthIconXAlignment, value),
                      duration: Constants.defaultAnimationDuration,
                      curve: this._menuExpanded
                          ? Constants.defaultAnimationCurve
                          : Curves.linear,
                      child: FloatingActionButton(
                        elevation: this._menuExpanded ? 6 : 0,
                        onPressed: _paintDataProvider.undo,
                        child: Icon(
                          Icons.undo_rounded,
                          size: 30.0,
                        ),
                      ),
                    ),
                  ),
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
                        onPressed: _toggleMenu,
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

class _FABAlignmentNotifier extends ValueNotifier<double> {
  _FABAlignmentNotifier(double value) : super(value);

  void update(double newValue) {
    if (newValue != this.value) {
      this.value = newValue;
      notifyListeners();
    }
  }
}

class _PaintingStrokeProvider extends ValueNotifier<Map<int, Stroke>> {
  _PaintingStrokeProvider() : super({});

  List<Stroke> get strokes => value.values.toList();

  void addStroke(Stroke stroke, int pointer) {
    value.addAll({pointer: stroke});
    notifyListeners();
  }

  void addPoint(Offset point, int pointer) {
    value[pointer]?.points.add(point);
    notifyListeners();
  }

  void undo() {
    try {
      List keys = value.keys.toList();
      keys.sort();
      int last = keys.last;
      value.remove(last);
      notifyListeners();
    } catch (e) {}
  }

  void reset() {
    value.clear();
    notifyListeners();
  }
}
