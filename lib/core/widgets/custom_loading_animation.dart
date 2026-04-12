import 'package:flutter/material.dart';
import '../../ui/widgets/pulsing_loader.dart';

class CustomLoadingAnimation extends StatelessWidget {
  final double size;
  final Color? color;
  final double? value; // Unused in PulsingLoader but kept for compatibility

  const CustomLoadingAnimation({
    super.key,
    this.size = 60.0,
    this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PulsingLoader(
        size: size,
        color: color,
      ),
    );
  }
}
