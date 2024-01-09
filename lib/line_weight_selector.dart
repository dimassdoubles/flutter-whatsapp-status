import 'package:flutter/material.dart';
import 'package:whatsapp_status/app_colors.dart';

enum _Weight {
  regular(2, "line-regular"),
  medium(5, "line-medium"),
  bold(10, "line-bold");

  const _Weight(this.number, this.iconName);
  final String iconName;
  final double number;
}

class LineWeightSelector extends StatefulWidget {
  final void Function(double weight)? _onBrushWeightChanged;
  const LineWeightSelector({
    super.key,
    void Function(double weight)? onBrushWeightChanged,
  }) : _onBrushWeightChanged = onBrushWeightChanged;

  @override
  State<LineWeightSelector> createState() => _LineWeightSelectorState();
}

class _LineWeightSelectorState extends State<LineWeightSelector> {
  _Weight weight = _Weight.regular;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionButton(
            onTap: () {
              setState(() {
                weight = _Weight.regular;
              });
              widget._onBrushWeightChanged?.call(weight.number);
            },
            weight: _Weight.regular,
            groupWeight: weight,
          ),
          _ActionButton(
            onTap: () {
              setState(() {
                weight = _Weight.medium;
              });
              widget._onBrushWeightChanged?.call(weight.number);
            },
            weight: _Weight.medium,
            groupWeight: weight,
          ),
          _ActionButton(
            onTap: () {
              setState(() {
                weight = _Weight.bold;
              });
              widget._onBrushWeightChanged?.call(weight.number);
            },
            weight: _Weight.bold,
            groupWeight: weight,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final void Function()? _onTap;
  final _Weight _groupWeight;
  final _Weight _weight;
  const _ActionButton({
    void Function()? onTap,
    required _Weight weight,
    required _Weight groupWeight,
  })  : _onTap = onTap,
        _weight = weight,
        _groupWeight = groupWeight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _weight == _groupWeight ? Colors.white : AppColors.grey,
        ),
        child: Image.asset(
            "images/${_weight.iconName}${_groupWeight == _weight ? "-active" : ""}.png"),
      ),
    );
  }
}
