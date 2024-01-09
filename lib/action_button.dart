import 'package:flutter/material.dart';
import 'package:whatsapp_status/app_colors.dart';

class ActionButton extends StatelessWidget {
  final void Function()? _onTap;
  final IconData _icon;
  final Color? _backgroundColor;
  final Color? _color;
  const ActionButton({
    super.key,
    void Function()? onTap,
    required IconData icon,
    Color? backgroundColor,
    Color? color,
  })  : _onTap = onTap,
        _icon = icon,
        _backgroundColor = backgroundColor,
        _color = color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _backgroundColor ?? AppColors.grey,
        ),
        child: Icon(
          _icon,
          color: _color ?? Colors.white,
        ),
      ),
    );
  }
}
