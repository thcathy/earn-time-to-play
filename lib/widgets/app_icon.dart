import 'package:flutter/material.dart';

/// App icon widget that displays the PNG icon
class AppIcon extends StatelessWidget {
  final double size;

  const AppIcon({
    super.key,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.18),
      child: Image.asset(
        'assets/icon/app_icon.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
