import 'package:flutter/material.dart';

import 'constants.dart';

class CustomSlider extends StatefulWidget {
  final Function(int)? onStrokeChange;
  final double maxValue;
  final double minValue;
  final double defaultValue;

  const CustomSlider({
    this.onStrokeChange,
    this.maxValue = 10,
    this.minValue = 0,
    this.defaultValue = 0,
  });

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double _value = 0;

  @override
  void initState() {
    super.initState();

    this._value = widget.defaultValue;
  }

  void _changeStroke(double value) {
    if (mounted) {
      setState(() {
        _value = value;
      });
    }
    widget.onStrokeChange?.call(value.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 0),
                blurRadius: 10.0,
              )
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Slider(
                  value: _value,
                  min: widget.minValue,
                  max: widget.maxValue,
                  divisions: widget.maxValue.toInt() -
                    widget.minValue.toInt() +
                      1,
                  onChanged: _changeStroke,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 30.0),
                child: Text(
                    _value < 10 ? "0${_value.toInt()}" : "${_value.toInt()}"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
